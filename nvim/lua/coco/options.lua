vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1200
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

local extra_paths = {
  vim.fn.stdpath("data") .. "/mason/bin",
  "/opt/homebrew/bin",
  "/usr/local/bin",
}

for _, path in ipairs(extra_paths) do
  if vim.uv.fs_stat(path) and not vim.env.PATH:find(path, 1, true) then
    vim.env.PATH = path .. ":" .. vim.env.PATH
  end
end
