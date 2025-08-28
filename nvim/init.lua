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

-- Highlight the entire line for diagnostics
vim.cmd [[
  highlight DiagnosticLineError guibg=#51202A guifg=NONE
  highlight DiagnosticLineWarn  guibg=#51412A guifg=NONE
  highlight DiagnosticLineInfo  guibg=#1E535D guifg=NONE
  highlight DiagnosticLineHint  guibg=#1E205D guifg=NONE
]]

local function find_python_host()
  local cwd = vim.fn.getcwd()
  local venv_python = cwd .. "/.venv/bin/python"
  if vim.uv.fs_stat(venv_python) then
    return venv_python
  else
    -- fallback to pyenv shim
    return vim.fn.exepath("python3")
  end
end

vim.g.python3_host_prog = find_python_host()
-- Apply the highlights automatically
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    local diagnostics = vim.diagnostic.get(0)
    for _, d in ipairs(diagnostics) do
      local hl
      if d.severity == vim.diagnostic.severity.ERROR then
        hl = "DiagnosticLineError"
      elseif d.severity == vim.diagnostic.severity.WARN then
        hl = "DiagnosticLineWarn"
      elseif d.severity == vim.diagnostic.severity.INFO then
        hl = "DiagnosticLineInfo"
      elseif d.severity == vim.diagnostic.severity.HINT then
        hl = "DiagnosticLineHint"
      end
      if hl then
        vim.api.nvim_buf_add_highlight(0, -1, hl, d.lnum, 0, -1)
      end
    end
  end,
})

-- Set runtime path for CtrlP plugin
-- vim.o.runtimepath = vim.o.runtimepath .. ',~/.config/nvim/bundle/ctrlp.vim'

-- Set up Packer for plugin management
local packer = require('packer')

packer.startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  use 'klepp0/nvim-baml-syntax'

  use 'glepnir/lspsaga.nvim'

  use 'nvim-treesitter/nvim-treesitter'

  use 'tpope/vim-fugitive'
    
  use 'neovim/nvim-lspconfig'

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

require('mason').setup()

local lspconfig = require('lspconfig')

-- Cypher LSP
lspconfig.cypher_ls.setup({
  cmd = {'cypher-language-server', '--stdio'},
  filetypes = {'cypher'},
  root_dir = function()
    return vim.fn.getcwd()
  end,
  settings = {}
})

-- -- Function to determine the Ruff command based on environment
-- local function get_ruff_cmd()
--   local config_path = vim.fn.expand("~/.config/nvim/ruff.toml")
--   local base_args = {
--     "server",
--     "--preview", -- Enable preview features
--     "--config", config_path, -- Force use of our config (overrides project config)
--   }
--   
--   local git_root = get_git_root()
--   if git_root then
--     local uv_bin = git_root .. "/.venv/bin/uv"
--     if vim.uv.fs_stat(uv_bin) then
--       -- Use uv run to execute ruff within the virtual environment
--       local cmd = { uv_bin, "run", "ruff" }
--       vim.list_extend(cmd, base_args)
--       return cmd
--     end
--     
--     -- Check if ruff exists in the venv
--     local venv_ruff = git_root .. "/.venv/bin/ruff"
--     if vim.uv.fs_stat(venv_ruff) then
--       local cmd = { venv_ruff }
--       vim.list_extend(cmd, base_args)
--       return cmd
--     end
--   end
--   
--   -- Fallback to system ruff
--   local cmd = { "ruff" }
--   vim.list_extend(cmd, base_args)
--   return cmd
-- end

-- Ruff for Python linting and formatting (using built-in LSP)
lspconfig.ruff.setup({
  -- cmd = get_ruff_cmd(),
  settings = {
    -- Use global config file that overrides project settings  
    configuration = vim.fn.expand("~/.config/nvim/ruff.toml"),
    lineLength = 120,
    fixAll = true,
    lint = {
        enable=true,
        run = 'onType',
    },
    organizeImports = true,
    configurationPreference = 'editorFirst',
    format = {
        enable = true
    }
  },
  on_attach = function(client, bufnr)
    -- Enable formatting
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true

    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- Keymap: format with Ruff
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    -- run ruff fixAll
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.fixAll.ruff" } },
    })
    -- then format with Ruff's formatter (optional)
    vim.lsp.buf.format({
      async = false,
      filter = function(client) return client.name == "ruff" end,
    })
  end,
})

vim.keymap.set("n", "<leader>rf", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { "source.fixAll.ruff" } },
  })
end, { noremap = true, silent = true, buffer = bufnr })


-- Pyright LSP
-- NOTE: keep your diagnostics handler + gl mapping intact
lspconfig.pyright.setup({
  root_dir = get_git_root(),
  on_new_config = function(config, root_dir)
    local python = get_python_venv_path()
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = python

    -- (Optional) also set VIRTUAL_ENV/PATH so subprocesses behave
    local venv_dir = root_dir .. "/.venv"
    if vim.uv.fs_stat(venv_dir) then
      config.cmd_env = {
        VIRTUAL_ENV = venv_dir,
        PATH = venv_dir .. "/bin:" .. vim.env.PATH,
      }
    end
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",   -- 'off', 'basic', 'strict'
        diagnosticMode = "workspace", -- or 'openFilesOnly'
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      }
    }
  },

  -- keep your diagnostics float behavior
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }
    ),
  },

  on_attach = function(client, bufnr)
    -- Disable pyright's formatting in favor of ruff
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    
    local opts = { noremap = true, silent = true }
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
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

-- Jump to next diagnostic
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

-- Jump to previous diagnostic
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev()
end, { desc = "Prev diagnostic" })

-- Jump to next ERROR only
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

-- Jump to previous ERROR only
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })

-- Additional settings for Neovim (optional)
vim.o.completeopt = "menuone,noselect"
