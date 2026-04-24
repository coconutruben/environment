vim.g.mapleader = " "
vim.g.maplocalleader = " "

local source = debug.getinfo(1, "S").source:sub(2)
local real_source = vim.uv.fs_realpath(source) or source
local config_root = vim.fn.fnamemodify(real_source, ":p:h")
vim.opt.runtimepath:prepend(config_root)

vim.cmd("source ~/environment/.vimrc")

require("coco.options")
require("coco.keymaps")
require("coco.lazy")
