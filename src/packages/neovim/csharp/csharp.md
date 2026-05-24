# C# Edition

The `csharp` edition extends `base` with a C# development environment: OmniSharp LSP, CSharpier formatter, and `netcoredbg` ready for debugging.

## Additional Plugins

None currently active. `nvim-dap` is commented out in `_plugins.nix` pending a debugging setup.

## Additional Treesitter Parsers

`c_sharp`

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| omnisharp-roslyn | C# LSP |
| dotnet-sdk | .NET SDK |
| csharpier | C# formatter |
| netcoredbg | .NET debugger (available but not yet wired up) |

## LSP

OmniSharp is started on `FileType cs` via an autocmd in `lsp-csharp.lua`. Key details:

- **Root detection**: `.sln`, `.csproj`, `.git`
- **EditorConfig support** enabled
- **Organize imports** on format enabled
- **Roslyn analyzers** and import completion enabled
- **.NET prereleases** included in SDK lookup

## Formatting

`csharpier` is wired into `conform-nvim` via `conform-csharp.lua` for the `cs` filetype.

## Possible Improvements

- **Debugging** — `netcoredbg` is installed and `nvim-dap` is commented out in `_plugins.nix`; wiring these up would add full breakpoint and step debugging support
- **Test runner** — no integration with `dotnet test` for running xUnit/NUnit tests inline
- **Roslyn LSP** — `roslyn.nvim` offers a more modern alternative to OmniSharp with better .NET 8+ support
