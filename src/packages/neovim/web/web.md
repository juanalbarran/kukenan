# Web Edition

The `web` edition extends `base` with TypeScript/JavaScript tooling: a dedicated LSP, linting via eslint, and import management keybinds.

## Additional Plugins

| Category | Plugin |
|---|---|
| LSP | nvim-vtsls |
| Linting | nvim-lint |

## Additional Treesitter Parsers

`javascript`, `typescript`, `tsx`, `jsdoc`, `scss`, `http`

> `html` and `css` are already provided by base.

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| vtsls | TypeScript/JavaScript language server |
| typescript | TypeScript compiler (required by vtsls) |
| eslint_d | Fast eslint daemon for linting and formatting |
| prettier | General formatter (also in base) |
| vscode-js-debug | Node.js / browser debug adapter |

## LSP

| Language | Server | Config file |
|---|---|---|
| TypeScript / JavaScript | `vtsls` | `lsp-vtsls.lua` |

`vtsls` config excludes `@mui/system` from auto-import suggestions.

## Linting & Formatting

`eslint_d` runs as both linter (`lint-web.lua`) and formatter (`conform-web.lua`) for `javascript`, `javascriptreact`, `typescript`, and `typescriptreact`.

## Additional Keybinds

| Key | Action |
|---|---|
| `<leader>io` | Organize imports |
| `<leader>is` | Sort imports |
| `<leader>ir` | Remove unused imports |
| `<leader>ia` | Add missing imports |

## Possible Improvements

- **Tailwind CSS LSP** — no `tailwindcss-language-server`; useful for projects using Tailwind utility classes
- **TypeScript error translation** — `ts-error-translator` exists as a custom plugin in `src/packages/vimPlugins/` but is not wired up; it makes cryptic TS errors human-readable
- **Test runner integration** — no vitest/jest integration for running tests inline
