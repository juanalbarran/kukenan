# src/packages/vimPlugins/alabaster.nix
{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "alabaster";
  src = pkgs.fetchFromGitHub {
    owner = "p00f";
    repo = "alabaster.nvim";
    rev = "f7d0ed5d6d0dd449b39acd3610a41b55bb693648";
    hash = "sha256-rLYA4WI5PsqH5qzOZaCCBpehdwTHqQqokUJEcexzWsE=";
  };
  # The C# grammar in nixpkgs has no record_struct_declaration node (record
  # structs parse as record_declaration, already in the query); the unknown
  # node breaks the whole c_sharp highlights query
  postPatch = ''
    sed -i '/(record_struct_declaration/,+1d' after/queries/c_sharp/highlights.scm
  '';
}
