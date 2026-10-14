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

## Debugging

Uses the `codelldb` adapter already configured in base. `dap-rust.lua` adds `dap.configurations.rust` with the default executable path pointing at `target/debug/`. All DAP keybinds (`<leader>d*`) are inherited from base.

## Keybinds

### Cargo Tasks (output in console tmux window)

| Key | Action |
|---|---|
| `<leader>rb` | `cargo build` |
| `<leader>rr` | `cargo run` |
| `<leader>rt` | `cargo test` |
| `<leader>rc` | `cargo clean` |

## Possible Improvements

- **Inline test runner** — `cargo test` output goes to the console window; no inline pass/fail indicators in the editor
