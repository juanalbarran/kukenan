# Base Edition

The `base` edition is the foundation shared by all other editions. It provides a complete editing experience for Lua, C, Nix, CSS, and QML out of the box.

## Plugins

| Category | Plugin |
|---|---|
| Look & Feel | lualine-nvim, noice-nvim, nvim-notify, which-key-nvim, vim-sleuth |
| Colorschemes | zenbones-nvim, lush-nvim, alabaster, vague |
| File Navigation | oil-nvim, fzf-lua, neo-tree-nvim |
| Editing | nvim-autopairs, nvim-surround, grug-far-nvim |
| Snippets | luasnip, friendly-snippets |
| Icons | nvim-web-devicons, mini-icons |
| Utils | indent-blankline-nvim, nvim-colorizer-lua, render-markdown-nvim, diffview-nvim |
| Debugging | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, nvim-nio |
| Completion | blink-cmp |
| Formatting | conform-nvim |
| Syntax | nvim-treesitter |

## Treesitter Parsers

`bash`, `html`, `markdown`, `markdown_inline`, `regex`, `lua`, `luadoc`, `nix`, `json`, `yaml`, `xml`, `qmljs`, `qmldir`, `css`, `c`

## External Dependencies

| Tool | Purpose |
|---|---|
| ripgrep, fzf | Fuzzy finding |
| clang, clang-tools | C/C++ compiler and tooling |
| codelldb | C debug adapter |
| stylua | Lua formatter |
| lua-language-server | Lua LSP |
| nixd | Nix LSP |
| statix, alejandra | Nix linter and formatter |
| vscode-langservers-extracted | CSS/HTML/JSON LSPs |
| prettier | General formatter |
| qt6.qtdeclarative | QML language support |
| viu, ueberzugpp | Image preview in terminal |

## LSP Configurations

| Language | Server | Config file |
|---|---|---|
| Lua | `lua_ls` | `lsp-lua.lua` |
| C/C++ | clangd | `lsp-c.lua` |
| Nix | `nixd` | `lsp-nix.lua` |
| CSS/HTML | `vscode-langservers-extracted` | `lsp-css.lua` |
| QML | qmlls | `lsp-qml.lua` |

## Possible Improvements

- **QML formatting** — no formatter is wired up for QML in `conform.lua`; `qmlformat` from `qt6.qtdeclarative` is already a dependency and could be added
- **Git integration** — no git plugin (e.g. gitsigns for hunk signs/blame, neogit for a full UI); diffview-nvim is present but only covers diffs
- **Terminal toggle** — no quick-access terminal (e.g. toggleterm); currently requires `:term` or a split manually
- **Session management** — no session save/restore; useful when returning to a project
