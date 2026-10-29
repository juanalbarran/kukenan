-- src/packages/neovim/java/__config/lua/treesitter-java.lua
-- Neovim names .properties files "jproperties"; the parser is "properties"
vim.treesitter.language.register("properties", "jproperties")
