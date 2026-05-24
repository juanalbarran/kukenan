# src/packages/neovim/java/_plugins.nix
{
  pkgs,
  root,
}:
with pkgs.vimPlugins;
with root.packages.vimPlugins; [
  java-creator-nvim
  nvim-jdtls
]
