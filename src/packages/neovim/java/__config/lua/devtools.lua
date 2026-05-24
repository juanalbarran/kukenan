-- src/packages/neovim/java/__config/lua/devtools.lua
-- Triggers mvn compile on Java file save so Spring Boot devtools can detect
-- the new .class files and restart the running app automatically.
-- Requires mvn to be on PATH (i.e. Neovim launched from within devenv shell).

local function compile_on_save()
  local root = vim.fs.root(0, { "pom.xml", "build.gradle", ".git" }) or vim.fn.getcwd()

  vim.notify("compiling...", vim.log.levels.INFO, { title = "Spring Boot" })

  vim.fn.jobstart({ "mvn", "compile", "-q" }, {
    cwd = root,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("reloading", vim.log.levels.INFO, { title = "Spring Boot" })
      else
        vim.notify("compilation failed", vim.log.levels.ERROR, { title = "Spring Boot" })
      end
    end,
  })
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.java",
  callback = compile_on_save,
})
