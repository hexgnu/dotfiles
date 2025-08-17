-- Set general options
vim.o.syntax = "on"  -- Enable syntax highlighting
vim.cmd('filetype plugin indent on')

vim.o.termguicolors = true  -- Enable true color support
vim.o.laststatus = 2  -- Always display status line
vim.o.ruler = true  -- Show cursor position
vim.o.number = true  -- Show line numbers
-- 
vim.o.expandtab = true  -- Convert tabs to spaces
vim.o.textwidth = 120  -- Line length for wrapping
vim.o.shiftwidth = 4  -- Number of spaces for indentation
vim.o.softtabstop = 4  -- Soft tabstop for editing
vim.o.tabstop = 4  -- Number of spaces per tab
vim.o.autoindent = true  -- Automatically indent new lines
vim.o.wildignore = vim.o.wildignore .. ',*/tmp/*,*.so,*.swp,*.zip,*.log,*.aux,*.pdf'  -- Ignore files

-- Set the CtrlP user command for git-based file search
vim.g.ctrlp_user_command = {'.git', 'cd %s && git ls-files -co --exclude-standard'}

vim.o.background = 'dark'
vim.cmd("colorscheme elflord")

-- Add this at the top of your init.lua
if vim.uv == nil then
  vim.uv = vim.loop
end

-- Set runtime path for CtrlP plugin
-- vim.o.runtimepath = vim.o.runtimepath .. ',~/.config/nvim/bundle/ctrlp.vim'

-- Set up Packer for plugin management
local packer = require('packer')

packer.startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  use 'glepnir/lspsaga.nvim'

  use {
      'nvim-treesitter/nvim-treesitter',
      tag = 'v0.9.3'
  }

  use 'tpope/vim-fugitive'
    
  use {
      'neovim/nvim-lspconfig',
      tag = 'v1.8.0' -- or whatever tag you want
  }

    -- Optionally, install nvim-cmp for autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  
  -- You can also install mason.nvim for easier LSP server management
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- CtrlP plugin
  use 'ctrlpvim/ctrlp.vim'
end)

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "lua",
    "markdown",
    "markdown_inline",
    -- add others here if needed
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
} 

local function dir_exists(path)
  -- Use luv.fs_stat instead of shelling out
  return vim.uv.fs_stat(path) ~= nil
end

-- Function to find the Git root directory
local function get_git_root()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel 2>/dev/null')
  if #git_root > 0 then
    return git_root[1]
  else
    return nil
  end
end

-- Function to find the .venv or virtualenv path
local function get_python_venv_path()
  -- Get the current working directory
  local git_root = get_git_root()

  if git_root then
      -- Check for .venv directory in the repo
      local venv_path = git_root .. "/.venv/bin/python"


      -- If .venv exists, return the path to its Python interpreter
      if dir_exists(git_root .. "/.venv") then
        return venv_path
      else
        -- If .venv doesn't exist, return the default system Python (or another virtualenv location)
        return vim.fn.exepath("/home/hexgnu/.pyenv/shims/python3")
      end
  else
      return vim.fn.exepath("/home/hexgnu/.pyenv/shims/python3")
  end
end


local lspconfig = require('lspconfig')
lspconfig.cypher_ls.setup({
    default_config = {
        cmd = {'cypher-language-server', '--stdio'},
        filetypes = {'cypher'},
        root_dir = function(fname)
            return vim.fn.getcwd()
        end,
        settings = {}
    }
})

-- Pyright configuration
lspconfig.pyright.setup({
  settings = {
    python = {
      pythonPath = get_python_venv_path(),
      analysis = {
        typeCheckingMode = "basic",  -- Options: 'off', 'basic', 'strict'
        diagnosticMode = "workspace", -- You can change this to 'openFilesOnly'

      }
    }
  },
    -- Configure diagnostics to be shown in a floating window
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,   -- Show virtual text inline
      signs = true,          -- Show signs in the sign column
      update_in_insert = false, -- Do not update diagnostics in insert mode
      float = {
        border = 'rounded',  -- Change border style (e.g., 'single', 'double', 'rounded')
        source = 'always',   -- Show the source (e.g., Pyright)
        header = '',         -- Hide header (optional)
        prefix = '',         -- Hide prefix (optional)
      },
    }),
  },

  -- Additional setup for keybindings and other functionality
  on_attach = function(client, bufnr)
    -- Keybinding to show diagnostics in a floating window using new API
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gl', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  end,
})

-- Optional: Setup for nvim-cmp (for autocompletion)
local cmp = require'cmp'
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- Optional: Enable mason.nvim for LSP server management
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright' },
  automatic_installation = true,
})

-- Additional settings for Neovim (optional)
vim.o.completeopt = "menuone,noselect"