# src/packages/neovim/base/_plugins.nix
{
  pkgs,
  root,
}:
with pkgs.vimPlugins;
with root.packages.vimPlugins; [
  # Look & Feel
  lualine-nvim
  noice-nvim
  nvim-notify
  which-key-nvim
  vim-sleuth

  # Colorsheme
  zenbones-nvim
  lush-nvim
  alabaster
  vague

  # Files
  oil-nvim
  fzf-lua
  neo-tree-nvim

  # Editing
  nvim-autopairs
  nvim-surround
  grug-far-nvim

  # Snippets
  luasnip
  friendly-snippets

  # Icons
  nvim-web-devicons
  mini-icons

  # Utils
  indent-blankline-nvim
  nvim-colorizer-lua
  render-markdown-nvim
  diffview-nvim

  # Debugging
  nvim-dap
  nvim-dap-ui
  nvim-dap-virtual-text
  nvim-nio

  # Completion
  blink-cmp

  # Linting & formatting
  conform-nvim

  # Treesitter
  nvim-treesitter
]
