-- Install packer if not installed already
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- Packages
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'preservim/nerdtree'
    use 'tpope/vim-commentary'
    use {
        'nvim-telescope/telescope.nvim', 
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
    }
    use 'tomasiser/vim-code-dark'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'Townk/vim-autoclose'
end)

-- Leader mappings
vim.g.mapleader = " "

-- Normal mode mappings
vim.keymap.set('n', '<Tab>', ':NERDTreeToggle<CR>', {silent=true})
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<Leader>w', ':bd<CR>')
vim.keymap.set('n', '<Leader>d', '<C-$>d0x')

-- Insert mode mappings
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>')
vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#next(1) : \"\\<S-Tab>\"', {noremap=true, expr=true})

-- Options
local set = vim.opt
set.expandtab = true
set.autoindent = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.relativenumber = true
set.number = true

-- Config
vim.g.coc_global_extensions = {'coc-pyright'}

-- Commands
vim.cmd('colorscheme codedark')

