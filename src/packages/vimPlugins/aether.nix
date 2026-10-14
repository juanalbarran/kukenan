# src/packages/vimPlugins/aether.nix
{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "aether";
  src = pkgs.fetchFromGitHub {
    owner = "omacom";
    repo = "aether.nvim";
    # branch v3
    rev = "7b64e5dceb6129470e7cf6fe0680b269eeab8c4c";
    hash = "sha256-HIEF3pDZKHEZUESVCMxW8h0kdmsAQHokS6TidT1hm1w=";
  };
}
