-- src/packages/neovim/java/__config/lua/dap-java.lua
local dap = require("dap")

-- Attach config for Spring Boot + devenv workflow.
-- Start the app with the debug agent in the server tmux window:
-- mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Attach (port 5005)",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- After JDTLS attaches, auto-discover @SpringBootApplication / main() classes
-- and register the DAP adapter + additional launch configs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      require("jdtls.dap").setup_dap_main_class_configs()
    end
  end,
})
