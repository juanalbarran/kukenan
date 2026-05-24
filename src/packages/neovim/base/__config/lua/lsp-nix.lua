-- src/packages/neovim/base/__config/lua/lsp-nix.lua
local blink = require("blink.cmp")

local capabilities = blink.get_lsp_capabilities()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.lsp.start({
      name = "nixd",
      cmd = { "nixd" },
      capabilities = capabilities,
    })
  end,
})
