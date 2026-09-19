# src/packages/vimPlugins/sequoia-nvim.nix
{pkgs}:
pkgs.vimUtils.buildVimPlugin {
  name = "sequoia";
  src = pkgs.fetchFromGitHub {
    owner = "Sequoia-Theme";
    repo = "neovim";
    rev = "1c3da128a0d55aa9e9570d64f456b484ab3a5968";
    hash = "sha256-xsbc9QbifTkY97Z5GTFFhQs9/E6h0vIQZ8AFJpbjSkA=";
  };
}
