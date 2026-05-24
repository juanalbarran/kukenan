# Rust Edition

The `rust` edition extends `base` with a full Rust development environment: compiler, analyzer, formatter, and Cargo.toml management.

## Additional Plugins

| Category | Plugin |
|---|---|
| LSP | rustaceanvim |
| Cargo | crates-nvim |

> `rustaceanvim` replaces the standard lspconfig approach — do not use `vim.lsp.config("rust_analyzer")`.

## Additional Treesitter Parsers

`rust`, `toml`

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| rust-analyzer | Rust LSP |
| rustc | Rust compiler |
| cargo | Build system and package manager |
| rustfmt | Rust formatter |

## LSP

`rustaceanvim` manages `rust-analyzer` directly via `vim.g.rustaceanvim`. Config in `lsp-rust.lua`:

- `checkOnSave` runs `clippy` instead of `cargo check`
- Inlay hints enabled: binding modes, closure return types, lifetime elision with parameter names

## Formatting

`rustfmt` is wired into `conform-nvim` via `conform-rust.lua` for the `rust` filetype.

## Cargo.toml (crates-nvim)

`crates-nvim` runs with LSP integration enabled, providing completion, hover info, and code actions for crate versions directly in `Cargo.toml`.

## Possible Improvements

- **Debugging** — no DAP setup; `codelldb` or `lldb-vscode` would enable breakpoints and step debugging for Rust
- **Test runner** — no inline test runner; cargo test output requires leaving the editor
- **Cargo task runner** — no keybind to run `cargo build`, `cargo run`, or `cargo test` from within Neovim
