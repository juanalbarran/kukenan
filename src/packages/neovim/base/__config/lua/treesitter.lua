-- src/packages/neovim/base/__config/lua/treesitter.lua
-- nvim-treesitter (main branch) only installs parsers; parsers come from Nix,
-- so it needs no setup. Highlighting, folds and indent are started per buffer.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Fails when there is no parser for the filetype; the buffer then keeps
    -- the regex syntax
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end

    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- Only languages with an indents query; without one autoindent breaks
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.query.get(lang, "indents") then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.o.foldenable = true
-- Open files unfolded; zc/za/zM fold from there
vim.o.foldlevelstart = 99
