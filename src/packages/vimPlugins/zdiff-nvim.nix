# src/packages/vimPlugins/zdiff-nvim.nix
{pkgs}:
pkgs.vimUtils.buildVimPlugin {
  name = "zdiff.nvim";
  src = pkgs.fetchFromGitHub {
    owner = "martindur";
    repo = "zdiff.nvim";
    rev = "6e2a105d7cc138b25e2907589ad2c5251e608424";
    hash = "sha256-yyBXh/3Hd+xhSTgLD3jg8ElLyrXlGVuNpBLY+DEj6YQ=";
  };
}
