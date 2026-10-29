# src/packages/neovim/java/treesitterPlugins.nix
{}: treesitterPlugins:
with treesitterPlugins; [
  java
  javadoc
  # application.properties and Liquibase/SQL files; xml and yaml are in base
  properties
  sql
]
