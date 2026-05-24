# Java Edition

The `java` edition extends `base` with a full Java development environment: JDTLS with Lombok support, Google Java Format, and a project scaffolding plugin.

## Additional Plugins

| Category | Plugin |
|---|---|
| Project scaffolding | java-creator-nvim |

> JDTLS is managed via `nvim-jdtls` (`jdtls.start_or_attach`) — not native `vim.lsp.start`.

## Additional Treesitter Parsers

`java`, `javadoc`

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| jdtls (wrapped) | Java LSP with Lombok javaagent injected |
| java-debug-path | Shell script — outputs the java-debug plugin jar path |
| java-test-paths | Shell script — outputs all vscode-java-test jar paths |
| google-java-format | Java formatter |
| temurin-bin | JDK (Java 21) |
| unzip, curl | Required by JDTLS for downloading sources |

## LSP

`jdtls` is started on `FileType java` via `jdtls.start_or_attach()` in `lsp-java.lua`. Key details:

- **Plugin**: `nvim-jdtls` — provides `start_or_attach`, `extendedClientCapabilities`, refactor UI, and test runner integration
- **Lombok**: injected automatically via a shell wrapper that sets `-javaagent:lombok.jar`
- **Workspace**: per-project, stored in `~/.cache/nvim/jdtls-workspaces/<project-name>`
- **Root detection**: `.git`, `mvnw`, `gradlew`, `pom.xml`, `build.gradle`
- **Build config**: `updateBuildConfiguration = "automatic"` — JDTLS reloads on pom/gradle changes
- Sources downloaded automatically for both Maven and Eclipse
- `extendedClientCapabilities` passed via `init_options` — enables nvim-jdtls-specific features

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
| `<leader>jtc` | Normal | Run test class |
| `<leader>jtm` | Normal | Run nearest test method |
| `<leader>jmt` | Normal | `mvn test` (output in console tmux window) |
| `<leader>jmc` | Normal | `mvn clean` (output in console tmux window) |
| `<leader>jmb` | Normal | `mvn install` (output in console tmux window) |
| `<leader>jmp` | Normal | `mvn package` (output in console tmux window) |

## Debugging

`dap-java.lua` registers the `java` adapter by calling `workspace/executeCommand → vscode.java.startDebugSession` on the running JDTLS client, which returns a port that nvim-dap connects to. JDTLS loads the debug bundles at startup via `init_options.bundles` in `lsp-java.lua` — the jar paths are resolved at runtime by calling the `java-debug-path` and `java-test-paths` helper scripts.

> JDTLS must be attached to the buffer before launching a debug session (`<leader>dc`). The `projectName` defaults to the current working directory name, which matches the `<artifactId>` in both `fitness-server` and `authentication-service`.

**Two DAP configurations are available:**

- **Attach (port 5005)** — recommended for Spring Boot + devenv. Start the app in the server tmux window with the debug agent, then attach from Neovim:
  ```
  mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
  ```
- **Launch** — starts the app directly via JDTLS. Only useful for simple Java apps without devenv dependencies (no DB, no env vars).

All DAP keybinds (`<leader>d*`) are inherited from base.

## Spring Boot Devtools (devtools.lua)

On every `BufWritePost` for `*.java` files, `mvn compile -q` runs in the background from the project root. When compilation succeeds, Spring Boot devtools detects the new `.class` files and restarts the app (~200-500ms). Notifications appear via noice/nvim-notify.

> Only works when Neovim is launched from inside `devenv shell` — `mvn` must be on PATH. Both `fitness-server` and `authentication-service` satisfy this via `.tmux-init.conf`.

## Possible Improvements

- No current improvements identified.
