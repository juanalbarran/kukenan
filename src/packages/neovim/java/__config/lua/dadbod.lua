-- src/packages/neovim/java/__config/lua/dadbod.lua
-- Register the project's database from devenv's env vars so :DBUI lists it.
-- Requires Neovim to be launched from inside devenv shell (psql on PATH).
local env = vim.env

if env.database_name and env.database_username then
  vim.g.dbs = {
    {
      name = env.database_name,
      url = string.format(
        "postgresql://%s:%s@%s:%s/%s",
        env.database_username,
        env.database_password or "",
        env.database_host or "127.0.0.1",
        env.database_port or "5432",
        env.database_name
      ),
    },
  }
end

vim.g.db_ui_use_nerd_fonts = 1
