# src/packages/vimPlugins/luna-nvim.nix
{pkgs}:
pkgs.vimUtils.buildVimPlugin {
  name = "luna.nvim";
  src = pkgs.fetchFromGitHub {
    owner = "WTFox";
    repo = "luna.nvim";
    rev = "727c19334528e1b8939f518d1ea43c4e62d98f91";
    hash = "sha256-3c/UhbK9UYvcpYRQuhwPXzOk1G1tpBnx7rUWoq4LPFE=";
  };
}
