-- src/packages/neovim/rust/__config/lua/dap-rust.lua
local dap = require("dap")

-- codelldb is already configured in base; just add Rust configurations
dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
