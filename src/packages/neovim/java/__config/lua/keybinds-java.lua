-- src/packages/neovim/java/__config/lua/keybinds-java.lua
local jdtls = require("jdtls")

-- Global: Java file scaffolding (java-creator-nvim)
vim.keymap.set("n", "<leader>jc", "<cmd>JavaClass<CR>", { desc = "[J]ava [C]lass", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ji", "<cmd>JavaInterface<CR>", { desc = "[J]ava [I]nterface", noremap = true, silent = true })
vim.keymap.set("n", "<leader>je", "<cmd>JavaEnum<CR>", { desc = "[J]ava [E]num", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jr", "<cmd>JavaRecord<CR>", { desc = "[J]ava [R]ecord", noremap = true, silent = true })
vim.keymap.set("n", "<leader>jn", "<cmd>JavaNew<CR>", { desc = "[J]ava [N]ew", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ja", "<cmd>JavaAbstract<CR>", { desc = "[J]ava [A]bstract", noremap = true, silent = true })

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

    -- Test runner
    vim.keymap.set("n", "<leader>jtc", function()
      require("jdtls.dap").test_class()
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est [C]lass" })

    vim.keymap.set("n", "<leader>jtm", function()
      require("jdtls.dap").test_nearest_method()
    end, { buffer = bufnr, silent = true, desc = "[J]ava [T]est nearest [M]ethod" })

    -- Maven tasks (run in console tmux window)
    vim.keymap.set("n", "<leader>jmt", function()
      vim.fn.system("tmux send-keys -t console 'mvn test' Enter")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [T]est" })

    vim.keymap.set("n", "<leader>jmc", function()
      vim.fn.system("tmux send-keys -t console 'mvn clean' Enter")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [C]lean" })

    vim.keymap.set("n", "<leader>jmb", function()
      vim.fn.system("tmux send-keys -t console 'mvn install' Enter")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [B]uild" })

    vim.keymap.set("n", "<leader>jmp", function()
      vim.fn.system("tmux send-keys -t console 'mvn package' Enter")
    end, { buffer = bufnr, silent = true, desc = "[J]ava [M]aven [P]ackage" })
  end,
})
