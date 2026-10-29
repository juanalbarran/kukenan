-- src/packages/neovim/java/__config/lua/keybinds-java.lua
local jdtls = require("jdtls")

-- Global: Java file scaffolding (java-creator-nvim)
vim.keymap.set("n", "<leader>jc", "<cmd>JavaClass<CR>", { desc = "[J]ava [C]lass", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ji", "<cmd>JavaInterface<CR>", { desc = "[J]ava [I]nterface", noremap = true, silent = true })
vim.keymap.set("n", "<leader>je", "<cmd>JavaEnum<CR>", { desc = "[J]ava [E]num", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jr", "<cmd>JavaRecord<CR>", { desc = "[J]ava [R]ecord", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jn", "<cmd>JavaNew<CR>", { desc = "[J]ava [N]ew", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ja", "<cmd>JavaAbstract<CR>", { desc = "[J]ava [A]bstract", noremap = true, silent = true })

-- tmux window in this Neovim's own session, so with two Java sessions open the
-- commands don't land in the other session's windows
local function tmux_window(name)
  local args = { "tmux", "display-message", "-p" }
  if vim.env.TMUX_PANE then
    vim.list_extend(args, { "-t", vim.env.TMUX_PANE })
  end
  table.insert(args, "#S")
  return vim.trim(vim.fn.system(args)) .. ":" .. name
end

-- Stop the app in the server window, wait until it is gone, then rerun the
-- last command there (`devenv shell server` from .tmux-init.conf). The app is
-- gone once the window's shell has no child processes left; the pane's
-- command name can't tell, it shows the script's interpreter (sh/bash).
local function restart_server()
  local target = tmux_window("server")
  local pane_pid = tonumber(vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "-t", target, "#{pane_pid}" })))
  vim.fn.system({ "tmux", "send-keys", "-t", target, "C-c" })

  local tries = 0
  local timer = vim.uv.new_timer()
  timer:start(
    200,
    200,
    vim.schedule_wrap(function()
      tries = tries + 1
      local stopped = not pane_pid or #vim.api.nvim_get_proc_children(pane_pid) == 0
      if stopped or tries >= 50 then
        timer:stop()
        timer:close()
        if stopped then
          vim.fn.system({ "tmux", "send-keys", "-t", target, "Up", "Enter" })
          vim.notify("restarting", vim.log.levels.INFO, { title = "Spring Boot" })
        else
          vim.notify("server didn't stop", vim.log.levels.ERROR, { title = "Spring Boot" })
        end
      end
    end)
  )
end

-- Global: Spring beans and request mappings from the Spring Boot LS, which
-- answers workspace symbol queries starting with "@+" (beans) and "@/" (web)
vim.keymap.set("n", "<leader>jb", function()
  require("fzf-lua").lsp_workspace_symbols({ lsp_query = "@+" })
end, { desc = "[J]ava Spring [B]eans", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jw", function()
  require("fzf-lua").lsp_workspace_symbols({ lsp_query = "@/" })
end, { desc = "[J]ava [W]eb endpoints", noremap = true, silent = true })

-- Global: Spring Boot server and database
vim.keymap.set("n", "<leader>jR", restart_server, { desc = "[J]ava [R]estart server", noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<leader>jq",
  "<cmd>DBUIToggle<CR>",
  { desc = "[J]ava [Q]uery database", noremap = true, silent = true }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(event)
    local bufnr = event.buf

    -- Imports
    vim.keymap.set("n", "<leader>io", jdtls.organize_imports, { buffer = bufnr, silent = true, desc = "[J]ava [O]rganize Imports" })

    -- Refactors (nvim-jdtls shows a UI prompt for the new name)
    vim.keymap.set("v", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, silent = true, desc = "[J]ava Extract [V]ariable" })
    vim.keymap.set("v", "<leader>jm", jdtls.extract_method, { buffer = bufnr, silent = true, desc = "[J]ava Extract [M]ethod" })

    -- Code generation
    vim.keymap.set("n", "<leader>jgs", function()
      vim.lsp.buf.code_action({ context = { only = { "source.generate.accessors" } }, apply = true })
    end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [S]etters/Getters" })

    vim.keymap.set("n", "<leader>jgc", function()
      vim.lsp.buf.code_action({ context = { only = { "source.generate.constructors" } }, apply = true })
    end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [C]onstructor" })

    vim.keymap.set("n", "<leader>jgt", function()
      vim.lsp.buf.code_action({ context = { only = { "source.generate.toString" } }, apply = true })
    end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [T]oString" })

    vim.keymap.set("n", "<leader>jgh", function()
      vim.lsp.buf.code_action({ context = { only = { "source.generate.hashCodeEquals" } }, apply = true })
    end, { buffer = bufnr, silent = true, desc = "[J]ava [G]enerate [H]ashCode/Equals" })

    -- Test runner (neotest)
    vim.keymap.set("n", "<leader>jtc", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est [C]lass" })

    vim.keymap.set("n", "<leader>jtm", function()
      require("neotest").run.run()
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est nearest [M]ethod" })

    vim.keymap.set("n", "<leader>jtd", function()
      require("neotest").run.run({ strategy = "dap" })
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est [D]ebug nearest" })

    vim.keymap.set("n", "<leader>jts", function()
      require("neotest").summary.toggle()
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est [S]ummary" })

    vim.keymap.set("n", "<leader>jto", function()
      require("neotest").output_panel.toggle()
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est [O]utput" })

    -- Maven tasks (run in console tmux window)
    -- The console runs a devenv shell, which doesn't have mvnd on PATH, so send
    -- the absolute path from this edition's PATH instead
    local function maven(goal)
      local mvnd = vim.fn.exepath("mvnd")
      local cmd = (mvnd ~= "" and mvnd or "mvn") .. " " .. goal
      vim.fn.system({ "tmux", "send-keys", "-t", tmux_window("console"), cmd, "Enter" })
    end

    vim.keymap.set("n", "<leader>jmt", function()
      maven("test")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [T]est" })

    vim.keymap.set("n", "<leader>jmc", function()
      maven("clean")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [C]lean" })

    vim.keymap.set("n", "<leader>jmb", function()
      maven("install")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [B]uild" })

    vim.keymap.set("n", "<leader>jmp", function()
      maven("package")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [P]ackage" })
  end,
})
