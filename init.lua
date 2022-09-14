-- Install packer if not installed already
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then

  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- Packages
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'preservim/nerdtree'
    use 'tpope/vim-commentary'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
    }
    use 'tomasiser/vim-code-dark'
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
vim.keymap.set('n', '<C-d>', '<C-d>zz', {noremap=true})
vim.keymap.set('n', '<C-u>', '<C-u>zz', {noremap=true})

-- Insert mode mappings
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>')

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

-- Treesitter config
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "c", "cpp" },

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

-- nvim-lsp config
local lsp_defaults = {
  flags = {
    debounce_text_changes = 500,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lsp_config = require('lspconfig')
lsp_config.util.default_config = vim.tbl_deep_extend(
  'force',
  lsp_config.util.default_config,
  lsp_defaults
)

-- For python
lsp_config.pyright.setup({
    on_attach = function(client, bufnum)
        lsp_config.util.default_config.on_attach(client, bufnum)
    end
})

-- For lua
lsp_config.sumneko_lua.setup({
    single_file_support = true,
    on_attach = function(client, bufnum)
        lsp_config.util.default_config.on_attach(client, bufnum)
    end
})

-- For C/C++
lsp_config.clangd.setup({
    on_attach = function(client, bufnum)
        lsp_config.util.default_config.on_attach(client, bufnum)
    end
})

-- For rust
lsp_config.rust_analyzer.setup({
    on_attach = function(client, bufnum)
        lsp_config.util.default_config.on_attach(client, bufnum)
    end
})

-- Autocompletion
local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' }
    },
    mapping = {
        ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
        ["<Tab>"] = cmp.mapping(
            function (fallback)
                if cmp.visible() then
                    cmp.confirm({select=true})
                else
                    fallback()
                end
            end,
            {'i', 's'}
        )
    }
})

-- LSP attach
vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- Startup commands
vim.cmd('colorscheme codedark')

-- Brace autoexpansion
function IsSurroundedByBraces()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return (col ~= 0 and vim.api.nvim_get_current_line():sub(col, col+1):match("{}"))
end

vim.keymap.set("i", "<CR>", function()
    return IsSurroundedByBraces() and "<CR><CR><Esc>k<S-s>" or "<CR>"
end, {expr=true, noremap=true})

