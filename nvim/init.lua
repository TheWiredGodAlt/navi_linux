-- NEOVIM CONFIG WITH DRACULA THEME AND FILE EXPLORER
-- December 21, 2025

-- ========== LAZY.NVIM BOOTSTRAP ==========
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"

-- ========== PLUGINS ==========
require("lazy").setup({
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        pairs = {
          ["("] = ")",
          ["["] = "]",
          ["{"] = "}",
          ['"'] = '"',
          ["'"] = "'",
          ["`"] = "`",
          ["<"] = ">",
        },
        check_ts = false,
      })
    end
  },
  {
    "dracula/vim",
    name = "dracula",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme dracula")
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        filters = {
          dotfiles = false,
        },
      })
    end
  },
})

-- ========== EDITOR SETTINGS ==========
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- ========== OPEN FILE EXPLORER ON START ==========
vim.cmd("NvimTreeToggle")

-- ========== F10 RUN PYTHON ==========
local function run_python()
    local file_name = vim.fn.expand("%:p")
    if vim.fn.filereadable(file_name) == 0 then
        print("File not found!")
        return
    end
    vim.cmd("write")
    vim.cmd("below split | term python3 " .. vim.fn.shellescape(file_name))
end

-- ========== F10 RUN C ==========
local function run_c()
    local file_name = vim.fn.expand("%:p")
    local output_file = vim.fn.expand("%:p:r")
    if vim.fn.filereadable(file_name) == 0 then
        print("File not found!")
        return
    end
    vim.cmd("write")
    local cmd = "below split | term gcc " .. vim.fn.shellescape(file_name) .. " -o " .. vim.fn.shellescape(output_file) .. " && " .. vim.fn.shellescape(output_file)
    vim.cmd(cmd)
end

-- ========== F10 KEYBINDING ==========
vim.keymap.set('n', '<F10>', function()
    local file_type = vim.fn.expand("%:e")
    if file_type == "py" then
        run_python()
    elseif file_type == "c" then
        run_c()
    else
        print("File type not supported: " .. file_type)
    end
end, { noremap = true, silent = false })

-- ========== F5 EXIT TERMINAL ==========
vim.keymap.set('t', '<F5>', [[<C-\><C-n>]], { noremap = true })

-- ========== CTRL+S SAVE ==========
vim.keymap.set('n', '<C-s>', ':write<CR>', { noremap = true, silent = true })

-- ========== CTRL+N TOGGLE FILE EXPLORER ==========
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
--=========== Nvim now have the same config as the terminal=============
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
