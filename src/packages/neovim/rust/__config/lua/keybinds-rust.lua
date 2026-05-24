-- src/packages/neovim/rust/__config/lua/keybinds-rust.lua

-- Cargo tasks (run in console tmux window)
vim.keymap.set("n", "<leader>rb", function()
  vim.fn.system("tmux send-keys -t console 'cargo build' Enter")
end, { silent = true, desc = "[R]ust [B]uild" })

vim.keymap.set("n", "<leader>rr", function()
  vim.fn.system("tmux send-keys -t console 'cargo run' Enter")
end, { silent = true, desc = "[R]ust [R]un" })

vim.keymap.set("n", "<leader>rt", function()
  vim.fn.system("tmux send-keys -t console 'cargo test' Enter")
end, { silent = true, desc = "[R]ust [T]est" })

vim.keymap.set("n", "<leader>rc", function()
  vim.fn.system("tmux send-keys -t console 'cargo clean' Enter")
end, { silent = true, desc = "[R]ust [C]lean" })
