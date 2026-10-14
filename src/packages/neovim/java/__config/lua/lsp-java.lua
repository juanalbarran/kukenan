-- src/packages/neovim/java/__config/lua/lsp-java.lua
local blink = require("blink.cmp")
local jdtls = require("jdtls")

local capabilities = blink.get_lsp_capabilities()

local function get_debug_bundles()
  local debug_jar = vim.fn.system("java-debug-path"):gsub("\n", "")
  local test_jars = vim.split(vim.fn.system("java-test-paths"), "\n", { trimempty = true })
  local bundles = { debug_jar }
  vim.list_extend(bundles, test_jars)
  return bundles
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }) or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = vim.fn.expand("~/.cache/nvim/jdtls-workspaces/") .. project_name

    jdtls.start_or_attach({
      cmd = { "jdtls", "-data", workspace_dir },
      root_dir = root_dir,
      capabilities = capabilities,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "automatic",
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
