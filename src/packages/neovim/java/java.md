# Java Edition

The `java` edition extends `base` with a full Java development environment: JDTLS with Lombok support, Google Java Format, and a project scaffolding plugin.

## Additional Plugins

| Category | Plugin |
|---|---|
| Project scaffolding | java-creator-nvim |

> JDTLS is started natively via `vim.lsp.start` — no nvim-jdtls plugin is used.

## Additional Treesitter Parsers

`java`, `javadoc`

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| jdtls (wrapped) | Java LSP with Lombok javaagent injected |
| google-java-format | Java formatter |
| temurin-bin | JDK (Java 21) |
| unzip, curl | Required by JDTLS for downloading sources |

## LSP

`jdtls` is started on `FileType java` via an autocmd in `lsp-java.lua`. Key details:

- **Lombok**: injected automatically via a shell wrapper that sets `-javaagent:lombok.jar`
- **Workspace**: per-project, stored in `~/.cache/nvim/jdtls-workspaces/<project-name>`
- **Root detection**: `.git`, `mvnw`, `gradlew`, `pom.xml`, `build.gradle`
- **Build config**: `updateBuildConfiguration = "automatic"` — JDTLS reloads on pom/gradle changes
- Sources downloaded automatically for both Maven and Eclipse

## Formatting

`google-java-format` is wired into `conform-nvim` via `conform-java.lua`.

## Project Scaffolding (java-creator-nvim)

Creates new Java files from templates. Configured for Java 21 with `auto_open = true`.

## Keybinds

### Global (any buffer)

| Key | Action |
|---|---|
| `<leader>jc` | Create new Java Class |
| `<leader>ji` | Create new Java Interface |
| `<leader>je` | Create new Java Enum |
| `<leader>jr` | Create new Java Record |
| `<leader>jn` | New Java file (generic) |
| `<leader>ja` | Create new Abstract class |

### Buffer-local (Java files only, requires JDTLS)

| Key | Mode | Action |
|---|---|---|
| `<leader>io` | Normal | Organize imports |
| `<leader>jv` | Visual | Extract variable |
| `<leader>jm` | Visual | Extract method |
| `<leader>jgs` | Normal | Generate getters/setters |
| `<leader>jgc` | Normal | Generate constructor |
| `<leader>jgt` | Normal | Generate toString |
| `<leader>jgh` | Normal | Generate hashCode/equals |

## Possible Improvements

- **Debugging** — no DAP setup; `java-debug` and `vscode-java-test` adapters would enable breakpoints and JUnit debugging
- **Test runner** — no inline test runner for JUnit; tests require running Maven/Gradle externally
- **Build task runner** — no keybinds for `mvn`/`gradle` tasks from within Neovim
- **nvim-jdtls** — the dedicated plugin offers additional JDTLS features (UI for extract refactors, test discovery) beyond the native `vim.lsp.start` approach
