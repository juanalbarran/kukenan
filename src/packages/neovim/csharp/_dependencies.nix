# src/packages/neovim/csharp/_dependencies.nix
{pkgs}:
with pkgs;
  [
    dotnet-sdk
    omnisharp-roslyn
    csharpier
  ]
  ++ lib.optionals stdenv.isLinux [
    netcoredbg
  ]
