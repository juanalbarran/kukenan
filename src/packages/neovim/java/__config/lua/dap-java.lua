-- src/packages/neovim/java/__config/lua/dap-java.lua
local dap = require("dap")

-- Attach config for Spring Boot + devenv workflow. The project's devenv
-- `server` script starts the app with the debug agent on $debug_port, which
-- differs per project so two can run at once; 5005 without devenv.
local debug_port = tonumber(vim.env.debug_port) or 5005
dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Attach (port " .. debug_port .. ")",
    hostName = "127.0.0.1",
    port = debug_port,
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
