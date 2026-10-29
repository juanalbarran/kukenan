-- src/packages/neovim/java/__config/lua/neotest.lua
-- Test tree, gutter status and output panel for JUnit tests. neotest-java asks
-- jdtls for the classpath and JDK, and builds through jdtls before each run.
local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-java")({
      -- Nix-pinned jar (see _dependencies.nix) instead of a runtime download
      junit_jar = (vim.fn.system("junit-console-path"):gsub("\n", "")),
      disable_update_notifications = true,
    }),
  },
})
