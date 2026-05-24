# Keybinds

Leader key: `<Space>`

---

## Base Edition

### File Navigation

| Key | Action |
|---|---|
| `-` | Open Oil file explorer (current directory) |
| `<leader>e` | Toggle Neo-tree file tree |
| `<leader>ff` | Find files (fzf-lua) |
| `<leader>fb` | Find open buffers |
| `<leader>fr` | Resume previous fzf-lua search |
| `<leader>fw` | Find word under cursor (grep) |
| `<leader>fg` | Grep across project |
| `<leader>fk` | Find keymaps |

### Buffers & Windows

| Key | Action |
|---|---|
| `<leader>bd` | Delete current buffer |
| `<leader>bda` | Delete all buffers |
| `<leader>vs` | Vertical split |
| `<leader>hs` | Horizontal split |
| `<C-l>` | Move to right window |
| `<C-h>` | Move to left window |

### Editing & UI

| Key | Action |
|---|---|
| `<Esc>` | Clear search highlight |
| `<leader>cs` | Pick colorscheme |
| `<leader>ct` | Toggle colorizer |
| `<leader>sr` | Search & replace (grug-far) |

### Surround (nvim-surround)

| Key | Mode | Action |
|---|---|---|
| `ys{motion}{char}` | Normal | Add surround |
| `ds{char}` | Normal | Delete surround |
| `cs{old}{new}` | Normal | Change surround |
| `S{char}` | Visual | Surround selection |
| `gS{char}` | Visual | Surround selection on new lines |

### Snippets (blink-cmp + luasnip)

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | Insert | Jump to next snippet node |
| `<S-Tab>` | Insert | Jump to previous snippet node |

### Diagnostics

| Key | Action |
|---|---|
| `<leader>q` | Open diagnostic float |

### Debugging (nvim-dap)

| Key | Mode | Action |
|---|---|---|
| `<leader>dc` | Normal | Continue / Start |
| `<leader>do` | Normal | Step over |
| `<leader>di` | Normal | Step into |
| `<leader>dx` | Normal | Step out |
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>dB` | Normal | Conditional breakpoint |
| `<leader>du` | Normal | Toggle DAP UI |
| `<leader>dr` | Normal | Open REPL |
| `<leader>dl` | Normal | Run last |
| `<leader>dq` | Normal | Terminate session |

### LSP (active when a language server is attached)

| Key | Mode | Action |
|---|---|---|
| `gd` | Normal | Go to definition |
| `gtd` | Normal | Go to type definition |
| `gD` | Normal | Go to declaration |
| `gr` | Normal | Go to references |
| `gi` | Normal | Go to implementations |
| `gs` | Normal | Document symbols |
| `K` | Normal | Hover documentation |
| `<leader>ca` | Normal | Code actions |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>sh` | Normal | Signature help |
| `<C-k>` | Insert | Signature help |
| `<leader>th` | Normal | Toggle inlay hints |

---

## Web Edition

| Key | Mode | Action |
|---|---|---|
| `<leader>io` | Normal | Organize imports |
| `<leader>is` | Normal | Sort imports |
| `<leader>ir` | Normal | Remove unused imports |
| `<leader>ia` | Normal | Add missing imports |

---

## Java Edition

### Global (any buffer)

| Key | Mode | Action |
|---|---|---|
| `<leader>jc` | Normal | Create new Java Class |
| `<leader>ji` | Normal | Create new Java Interface |
| `<leader>je` | Normal | Create new Java Enum |
| `<leader>jr` | Normal | Create new Java Record |
| `<leader>jn` | Normal | New Java file (generic) |
| `<leader>ja` | Normal | Create new Abstract class |

### Buffer-local (Java files only, requires JDTLS)

| Key | Mode | Action |
|---|---|---|
| `<leader>io` | Normal | Organize imports |
| `<leader>jv` | Visual | Extract variable (with UI prompt) |
| `<leader>jm` | Visual | Extract method (with UI prompt) |
| `<leader>jgs` | Normal | Generate getters/setters |
| `<leader>jgc` | Normal | Generate constructor |
| `<leader>jgt` | Normal | Generate toString |
| `<leader>jgh` | Normal | Generate hashCode/equals |
| `<leader>jtc` | Normal | Run test class |
| `<leader>jtm` | Normal | Run nearest test method |
| `<leader>jmt` | Normal | `mvn test` (output in console tmux window) |
| `<leader>jmc` | Normal | `mvn clean` (output in console tmux window) |
| `<leader>jmb` | Normal | `mvn install` (output in console tmux window) |
| `<leader>jmp` | Normal | `mvn package` (output in console tmux window) |

---

## Rust Edition

### Cargo Tasks (output in console tmux window)

| Key | Action |
|---|---|
| `<leader>rb` | `cargo build` |
| `<leader>rr` | `cargo run` |
| `<leader>rt` | `cargo test` |
| `<leader>rc` | `cargo clean` |

## C# Edition

No edition-specific keybinds. Uses base LSP keybinds.

