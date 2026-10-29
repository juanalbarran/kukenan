-- src/packages/neovim/java/__config/lua/lsp-java.lua
local blink = require("blink.cmp")
local jdtls = require("jdtls")

local capabilities = blink.get_lsp_capabilities()

-- The jar paths never change for a given build, so resolve them once instead
-- of shelling out on every FileType java
local debug_bundles
local function get_debug_bundles()
  if not debug_bundles then
    local debug_jar = vim.fn.system("java-debug-path"):gsub("\n", "")
    local test_jars = vim.split(vim.fn.system("java-test-paths"), "\n", { trimempty = true })
    debug_bundles = { debug_jar }
    vim.list_extend(debug_bundles, test_jars)
  end
  return debug_bundles
end

-- Tell jdtls to analyse with the JDK devenv exports (JAVA_HOME) instead of the
-- one jdtls itself runs on. The name must be an execution environment such as
-- JavaSE-21 (or JavaSE-1.8), read from the JDK's release file.
local function get_runtimes()
  local java_home = vim.env.JAVA_HOME
  if not java_home then
    return {}
  end
  local release = io.open(java_home .. "/release")
  if not release then
    return {}
  end
  local version = release:read("*a"):match('JAVA_VERSION="([^"]+)"')
  release:close()
  if not version then
    return {}
  end
  local major = version:match("^1%.%d+") or version:match("^%d+")
  return { { name = "JavaSE-" .. major, path = java_home, default = true } }
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }) or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    -- The hash keeps projects with the same folder name in separate workspaces
    local workspace_dir = vim.fn.expand("~/.cache/nvim/jdtls-workspaces/")
      .. project_name
      .. "-"
      .. vim.fn.sha256(root_dir):sub(1, 8)

    jdtls.start_or_attach({
      cmd = {
        "jdtls",
        -- Keep .project/.classpath/.settings/.factorypath in the workspace
        -- instead of the repo root. jdtls reads this as a JVM property, not
        -- as a setting.
        "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
        "-data",
        workspace_dir,
      },
      root_dir = root_dir,
      capabilities = capabilities,
      settings = {
        java = {
          -- devtools.lua compiles with mvnd on save. jdtls would also write
          -- target/classes, including stubs for code with errors, which makes
          -- Spring devtools restart into code that throws at runtime
          autobuild = {
            enabled = false,
          },
          configuration = {
            updateBuildConfiguration = "automatic",
            runtimes = get_runtimes(),
          },
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          signatureHelp = {
            enabled = true,
          },
        },
      },
      init_options = {
        bundles = get_debug_bundles(),
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
      },
    })
  end,
})

-- Show the reference counts jdtls computes (referencesCodeLens). Since
-- Neovim 0.12, enabling code lens also keeps it refreshed while editing.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end
  end,
})
