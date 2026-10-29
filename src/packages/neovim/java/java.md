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
| jdtls (wrapped) | Java LSP with Lombok javaagent injected, heap capped at 2 GB |
| java-debug-path | Shell script — outputs the java-debug plugin jar path |
| java-test-paths | Shell script — outputs all vscode-java-test jar paths |
| google-java-format | Java formatter |
| mvnd | Maven Daemon — fast compile-on-save and `<leader>jm*` tasks |
| unzip, curl | Required by JDTLS for downloading sources |

## LSP

`jdtls` is started on `FileType java` via `jdtls.start_or_attach()` in `lsp-java.lua`. Key details:

- **Plugin**: `nvim-jdtls` — provides `start_or_attach`, `extendedClientCapabilities`, refactor UI, and test runner integration
- **Lombok**: injected via a shell wrapper that passes `--jvm-arg=-javaagent:lombok.jar` (the nixpkgs launcher ignores `JDTLS_JVM_ARGS`)
- **Memory**: the same wrapper adds `-Xmx2G` plus vscode-java's GC flags (`UseParallelGC`, `GCTimeRatio=4`, `AdaptiveSizePolicyWeight=90`) so jdtls stays under 2 GB and returns unused heap to the OS
- **Workspace**: per-project, stored in `~/.cache/nvim/jdtls-workspaces/<project-name>-<hash>` (first 8 chars of the root path's sha256, so two projects with the same folder name don't share an index)
- **Project JDK**: `java.configuration.runtimes` is built from `$JAVA_HOME` (devenv), named from its `release` file (e.g. `JavaSE-21`), so analysis uses the project's JDK, not the OpenJDK jdtls runs on. Empty when `JAVA_HOME` isn't set
- **Metadata files**: `.project`, `.classpath`, `.settings`, `.factorypath` live in the workspace, not the repo root. jdtls reads this as a JVM property, so it's passed as `--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false` in `cmd`
- **Code lens**: reference counts (`referencesCodeLens`) are shown via `vim.lsp.codelens.enable()` on `LspAttach`; Neovim 0.12 keeps them refreshed
- **Debug bundles**: the `java-debug-path`/`java-test-paths` lookups run once per session, not on every Java buffer
- **Root detection**: `.git`, `mvnw`, `gradlew`, `pom.xml`, `build.gradle`
- **Build config**: `updateBuildConfiguration = "automatic"` — JDTLS reloads on pom/gradle changes
- **Auto-build off**: jdtls doesn't write `target/classes`; `mvnd` does on save (see Spring Boot Devtools)
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
| `<leader>jmt` | Normal | `mvnd test` (output in console tmux window) |
| `<leader>jmc` | Normal | `mvnd clean` (output in console tmux window) |
| `<leader>jmb` | Normal | `mvnd install` (output in console tmux window) |
| `<leader>jmp` | Normal | `mvnd package` (output in console tmux window) |

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

On every `BufWritePost` for `*.java` files in a Maven project (`pom.xml` root), `mvnd test-compile -q` runs in the background. When compilation succeeds, Spring Boot devtools detects the new `.class` files and restarts the app (~200-500ms). Notifications appear via noice/nvim-notify.

- **Why mvnd**: the Maven Daemon keeps one warm JVM (~300 MB, shared by all projects, stops itself after 3h idle), so a save compiles in ~1s instead of ~3-5s plus a new ~365 MB JVM per save with plain `mvn`.
- **jdtls auto-build is off** (`java.autobuild.enabled = false` in `lsp-java.lua`): jdtls writes classes even for code with errors (as `Unresolved compilation problem` stubs), so devtools would restart into code that throws at runtime. `mvnd` writes nothing when compilation fails. Diagnostics for open buffers still work.
- **Why `test-compile`**: with auto-build off, nothing else updates `target/test-classes`, and `<leader>jtc`/`<leader>jtm` run whatever is compiled there.
- `mvnd` ships with this edition; it uses `JAVA_HOME` from devenv. If `mvnd` is missing or there's no `pom.xml`, the save is silently skipped.
- The `<leader>jm*` keymaps send `mvnd`'s absolute path to the console window, because the devenv shell there doesn't have it on PATH.

## Possible Improvements

- No current improvements identified.
