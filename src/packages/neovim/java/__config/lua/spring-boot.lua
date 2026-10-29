-- src/packages/neovim/java/__config/lua/spring-boot.lua
-- Spring Boot LS: application.properties/yml completion and navigation, bean
-- and endpoint symbols. Starts on java, application*.yml and
-- application*.properties buffers. The jdtls side (extension jars) is added
-- to the bundles in lsp-java.lua.
local root = (vim.fn.system("spring-boot-path"):gsub("\n", ""))

require("spring_boot").setup({
  ls_path = root .. "/language-server",
  server = {
    -- Nix wrapper with the JDK and JVM flags (see _dependencies.nix)
    cmd = { "spring-boot-ls" },
  },
})
