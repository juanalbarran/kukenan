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
  aether

  # Files
  oil-nvim
  fzf-lua
  neo-tree-nvim

  # Editing
  nvim-autopairs
  nvim-surround

  # Icons
  nvim-web-devicons
  mini-icons

  # Utils
  nvim-colorizer-lua
  render-markdown-nvim
  diffview-nvim

  # Completion
  blink-cmp

  # Linting & formatting
  conform-nvim

  # Treesitter
  nvim-treesitter
]
