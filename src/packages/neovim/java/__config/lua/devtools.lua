-- src/packages/neovim/java/__config/lua/devtools.lua
-- Triggers mvnd test-compile on Java file save so Spring Boot devtools can
-- detect the new .class files and restart the running app automatically.
-- mvnd (Maven Daemon) keeps one warm JVM, so each compile takes ~1s instead
-- of starting a new ~365 MB Maven JVM (~3-5s) on every save. It ships with
-- this edition and picks up JAVA_HOME from devenv.
-- test-compile (not compile) because jdtls autobuild is off (lsp-java.lua),
-- so this is also what keeps target/test-classes fresh for the test runner.

local function compile_on_save()
  -- Without this guard jobstart throws E475, which also aborts the other
  -- BufWritePost handlers (including the LSP didSave notification)
  if vim.fn.executable("mvnd") == 0 then
    return
  end

  local root = vim.fs.root(0, { "pom.xml" })
  if not root then
    return
  end

  vim.notify("compiling...", vim.log.levels.INFO, { title = "Spring Boot" })

  vim.fn.jobstart({ "mvnd", "test-compile", "-q" }, {
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
