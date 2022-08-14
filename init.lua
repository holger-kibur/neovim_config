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
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
end)

-- Leader mappings
vim.g.mapleader = " "

-- Normal mode mappings
vim.keymap.set('n', '<Tab>', ':NERDTreeToggle<CR>', {silent=true})
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<Leader>tj', '<C-w><S-j>:resize 10<CR>')
vim.keymap.set('n', '<Leader>tl', '<C-w><S-l>:resize 80<CR>')
vim.keymap.set('n', '<Leader>sf', ':Telescope find_files<CR>', {silent=true})
vim.keymap.set('n', '<C-j>', 'm`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>', {silent=true})
vim.keymap.set('n', '<C-k>', 'm`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>', {silent=true})
vim.keymap.set('n', '<A-j>', ':set paste<CR>m`o<Esc>``:set nopaste<CR>', {silent=true})
vim.keymap.set('n', '<A-k>', ':set paste<CR>m`O<Esc>``:set nopaste<CR>', {silent=true})

-- Insert mode mappings
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>')
vim.keymap.set('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : \"\\<Tab>\"', {noremap=true, expr=true})
vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#_select_confirm() : \"\\<Tab>\"', {noremap=true, expr=true})

-- Options
local set = vim.opt
set.expandtab = true
set.autoindent = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.relativenumber = true
set.number = true
set.scrolloff = 15

-- Config
vim.g.coc_global_extensions = {'coc-pyright'}

require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

local function with_tcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
    
-- Startup commands
vim.cmd('colorscheme codedark')

-- Create small terminal at the bottom
vim.cmd(with_tcodes(
    "normal <C-w>s<C-w><S-j>"
))
vim.cmd("terminal")
vim.cmd('resize 10')
vim.cmd(with_tcodes(
   "normal <C-w><C-w>" 
))
