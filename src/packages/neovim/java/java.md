# Java Edition

The `java` edition extends `base` with a full Java development environment: JDTLS with Lombok support, Google Java Format, a project scaffolding plugin, a test runner (neotest), a database UI (dadbod) and the Spring Boot language server.

## Additional Plugins

| Category | Plugin |
|---|---|
| Project scaffolding | java-creator-nvim |
| Spring Boot | spring-boot-nvim |
| Testing | neotest, neotest-java |
| Database | vim-dadbod, vim-dadbod-ui |

> JDTLS is managed via `nvim-jdtls` (`jdtls.start_or_attach`) — not native `vim.lsp.start`.

## Additional Treesitter Parsers

`java`, `javadoc`, `properties`, `sql` (`xml` and `yaml` come from base). `treesitter-java.lua` maps Neovim's `jproperties` filetype to the `properties` parser.

## Additional External Dependencies

| Tool | Purpose |
|---|---|
| jdtls (wrapped) | Java LSP with Lombok javaagent injected, heap capped at 2 GB |
| java-debug-path | Shell script — outputs the java-debug plugin jar path |
| java-test-paths | Shell script — outputs all vscode-java-test jar paths |
| google-java-format | Java formatter |
| mvnd | Maven Daemon — fast compile-on-save and `<leader>jm*` tasks |
| junit-console-path | Shell script — outputs the Nix-pinned JUnit console jar (6.0.3) for neotest-java |
| spring-boot-path | Shell script — outputs the unpacked vscode-spring-boot 2.4.1 extension (`language-server/`, `jars/`) |
| spring-boot-ls | Starts the Spring Boot LS on OpenJDK 21 with a 1 GB heap cap |
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
| `<leader>jR` | Restart the app in the `server` tmux window |
| `<leader>jb` | Spring beans (fzf-lua, Spring Boot LS `@+` symbols) |
| `<leader>jw` | Web endpoints / request mappings (fzf-lua, `@/` symbols) |
| `<leader>jq` | Toggle the database UI (dadbod-ui) |

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
| `<leader>jtc` | Normal | Run tests in file (neotest) |
| `<leader>jtm` | Normal | Run nearest test (neotest) |
| `<leader>jtd` | Normal | Debug nearest test (neotest + DAP) |
| `<leader>jts` | Normal | Toggle test summary tree |
| `<leader>jto` | Normal | Toggle test output panel |
| `<leader>jmt` | Normal | `mvnd test` (output in console tmux window) |
| `<leader>jmc` | Normal | `mvnd clean` (output in console tmux window) |
| `<leader>jmb` | Normal | `mvnd install` (output in console tmux window) |
| `<leader>jmp` | Normal | `mvnd package` (output in console tmux window) |

## Debugging

`dap-java.lua` registers the `java` adapter by calling `workspace/executeCommand → vscode.java.startDebugSession` on the running JDTLS client, which returns a port that nvim-dap connects to. JDTLS loads the debug bundles at startup via `init_options.bundles` in `lsp-java.lua` — the jar paths are resolved at runtime by calling the `java-debug-path` and `java-test-paths` helper scripts.

> JDTLS must be attached to the buffer before launching a debug session (`<leader>dc`). The `projectName` defaults to the current working directory name, which matches the `<artifactId>` in both `fitness-server` and `authentication-service`.

**Two DAP configurations are available:**

- **Attach (port `$debug_port`)** — recommended for Spring Boot + devenv. The port is read from the `debug_port` env var that the project's `devenv.nix` sets (5005 when unset), so each project can use its own. The server tmux window runs the devenv `server` script, which starts the app with the debug agent on that port:
  ```
  mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xmx512m -XX:TieredStopAtLevel=1 -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=$debug_port"
  ```
- **Launch** — starts the app directly via JDTLS (one config per discovered `main` class). The program inherits Neovim's environment, so when Neovim was started inside `devenv shell` it gets every devenv variable (`database_*`, …). Postgres still has to be running (`devenv up`).

All DAP keybinds (`<leader>d*`) are inherited from base.

## Spring Boot Language Server (spring-boot.lua)

`spring-boot-nvim` runs the Spring Boot LS from VS Code's `vscode-spring-boot` extension:

- **`application.yml` / `application.properties`**: completion (e.g. `spring.datasource.hikari.*`) and hover docs.
- **Java**: bean (`@+`) and request-mapping (`@/`) symbols via workspace symbols, `<leader>jb` / `<leader>jw`.
- Upstream also lists validation, navigation from a property to its `@ConfigurationProperties` class, Spring annotation completion and code actions (not verified here yet).
- **Packaging**: the extension isn't in nixpkgs, so `_dependencies.nix` fetches the stable `2.4.1` `.vsix` from Open VSX (pinned hash) and unpacks the language server and the jdtls extension jars. Nothing comes from mason or `~/.vscode`.
- **jdtls side**: its 5 extension jars are added to jdtls' `bundles` in `lsp-java.lua`. The Spring Boot LS gets the project classpath from jdtls, so property completion/hover only works once jdtls is running (open a Java file first).
- **Memory**: one more JVM per project. Started through the `spring-boot-ls` wrapper with `-Xmx1G` and the same GC flags as jdtls; measured ~350 MB RSS on authentication-service (jdtls ~1.1 GB at the same time).
- **Port**: the LS embeds an MCP server (`server.port=0` in its jar, i.e. a random port). The projects' devenv exports `SERVER_PORT` for the app, which Spring would apply to the LS too and bind it to the app's port (8080), so the wrapper passes `-Dserver.port=0`, which wins over the env var.
- **GC**: spring-boot.nvim's default command uses ZGC; measured 687 MB RSS against ~350-380 MB with the wrapper's ParallelGC flags (#29).
- Starts on `java`, `application*.yml` and `application*.properties` buffers only.

## Testing (neotest.lua)

`neotest` with the `neotest-java` adapter: a test tree (`<leader>jts`), pass/fail signs in the gutter, an output panel (`<leader>jto`), and debugging a test through DAP (`<leader>jtd`).

- neotest-java asks jdtls for the classpath and the JDK (devenv's, via `java.configuration.runtimes`), and runs a jdtls build before each run.
- The JUnit console jar is fetched by Nix (`_dependencies.nix`, version and sha256 as pinned by neotest-java 0.37.1), so nothing is downloaded at runtime. Update notifications are off.
- On the very first run in a fresh workspace, wait for jdtls to finish importing the project, otherwise the build is empty and no tests are found.
- Harmless log noise: neotest's helper subprocess can't find `nvim-treesitter` (it runs the unwrapped Nix `nvim`), so neotest falls back to parsing in the main process.

## Database (dadbod.lua)

`vim-dadbod` + `vim-dadbod-ui`. If Neovim was started inside `devenv shell`, the project database is registered from devenv's env vars (`database_name`, `database_username`, `database_password`, `database_host`, `database_port`) as `postgresql://user:password@host:port/name`, so `<leader>jq` lists it straight away. Needs `psql` on PATH, which devenv's `services.postgres` provides.

## tmux Integration

`<leader>jm*` and `<leader>jR` target windows in **this Neovim's own tmux session** (resolved from `$TMUX_PANE`), so two Java sessions don't send commands to each other.

- `<leader>jR` sends `C-c` to the `server` window, waits until the app is gone (the window's shell has no child processes left), then reruns the last command there (`Up` + `Enter`), i.e. the `devenv shell server` started by `.tmux-init.conf` (the project's devenv script that runs `mvn spring-boot:run …`).

### What the projects provide

The Java projects (template: `project-config-files/java/springboot`) are set up to match this edition:

- `devenv.yaml` pins nixpkgs to kukenan's rev and `devenv.nix` uses `pkgs.jdk21` with `maven.enable` and `lsp.enable = false`, so the project's JDK and Maven run on the same OpenJDK store path as jdtls and the Spring Boot LS (one JDK on disk). Bump the pin together with kukenan's `flake.lock`, then run `devenv update` in each project.
- Each project has its own `database_port`, `SERVER_PORT` and `debug_port` (authentication-service 5432/8080/5005, fitness-server 5433/8081/5006), so two can run at once; `dap-java.lua` and `dadbod.lua` read them from the env.
- `.tmux-init.conf` windows: editor (`devenv shell nvim-java`), console, server (`devenv shell server`), database (`devenv shell db`), services (`devenv up`). The `server` and `db` scripts wait for Postgres with `pg_isready` instead of sleeping.

## Spring Boot Devtools (devtools.lua)

On every `BufWritePost` for `*.java` files in a Maven project (`pom.xml` root), `mvnd test-compile -q` runs in the background. When compilation succeeds, Spring Boot devtools detects the new `.class` files and restarts the app (~200-500ms). Notifications appear via noice/nvim-notify.

- **Why mvnd**: the Maven Daemon keeps one warm JVM (~300 MB, shared by all projects, stops itself after 3h idle), so a save compiles in ~1s instead of ~3-5s plus a new ~365 MB JVM per save with plain `mvn`.
- **jdtls auto-build is off** (`java.autobuild.enabled = false` in `lsp-java.lua`): jdtls writes classes even for code with errors (as `Unresolved compilation problem` stubs), so devtools would restart into code that throws at runtime. `mvnd` writes nothing when compilation fails. Diagnostics for open buffers still work.
- **Why `test-compile`**: with auto-build off, nothing else updates `target/test-classes`, and `<leader>jtc`/`<leader>jtm` run whatever is compiled there.
- `mvnd` ships with this edition; it uses `JAVA_HOME` from devenv. If `mvnd` is missing or there's no `pom.xml`, the save is silently skipped.
- The `<leader>jm*` keymaps send `mvnd`'s absolute path to the console window, because the devenv shell there doesn't have it on PATH.

## Possible Improvements

- No current improvements identified.
