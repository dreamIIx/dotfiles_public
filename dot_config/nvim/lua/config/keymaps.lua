-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local lazyDel = vim.keymap.del

lazyDel("n", "<C-Up>")
lazyDel("n", "<C-Down>")
lazyDel("n", "<C-Left>")
lazyDel("n", "<C-Right>")

vim.api.nvim_create_user_command('RangeInfo', function()
  local path = vim.fn.expand('%:p'):sub(#vim.fn.getcwd() + 2)
  local s = vim.fn.getpos("'<")  -- [buf, line, col, off]
  local e = vim.fn.getpos("'>")
  local sl, sc = s[2], s[3]
  local el, ec = e[2], e[3]
  -- v:maxcol sentinel → actual end of line
  if ec >= 2147483647 then
    ec = #vim.fn.getline(el)
  end
  if sc >= 2147483647 then
    sc = 1  -- for linewise start, column = 1
  end
  local str = string.format("@%s:L%d:C%d,L%d:C%d", path, sl, sc, el, ec)
  vim.fn.setreg('+', str)
  print("Copied: " .. str)
end, { range = true })
vim.keymap.set('v', 'gy', ":RangeInfo\n", { desc = "Copy file:line:col to clipboard" })
