------------------------------------------------------------
-- Disable unused default plugins
------------------------------------------------------------
-- vim.g.did_indent_on             = 1 -- Loading indent files for file types.
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu   = 1
-- vim.g.did_load_filetypes        = 1 -- Detecting file types.
-- vim.g.did_load_ftplugin         = 1 -- Loading plugins for file types.
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_getscript          = 1
vim.g.loaded_getscriptPlugin    = 1
vim.g.loaded_gzip               = 1
vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
-- vim.g.loaded_matchparen         = 1 -- Highlighting matching parens.
vim.g.loaded_netrw              = 1
vim.g.loaded_netrwFileHandlers  = 1
vim.g.loaded_netrwPlugin        = 1
vim.g.loaded_netrwSettings      = 1
vim.g.loaded_remote_plugins     = 1
vim.g.loaded_rrhelper           = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tar                = 1
vim.g.loaded_tarPlugin          = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.loaded_vimball            = 1
vim.g.loaded_vimballPlugin      = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.skip_loading_mswin        = 1

-- Disable unused providers
vim.g.loaded_python3_provider   = 0
vim.g.loaded_ruby_provider      = 0
vim.g.loaded_node_provider      = 0
vim.g.loaded_perl_provider      = 0


------------------------------------------------------------
-- Bootstrap lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Vim script plugins
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" }, -- fuzzy finder
  { "segeljakt/vim-silicon", cmd = "Silicon" },
  { "tpope/vim-fugitive", cmd = "Git" }, -- git wrapper

  -- Lua plugins
  {
    "EdenEast/nightfox.nvim", -- color scheme
    lazy = false,
    priority = 1000,
    -- ref. https://github.com/termstandard/colors#truecolor-detection
    cond = (vim.env.COLORTERM == 'truecolor'),
  },
  {
    -- Configs for Neovim LSP
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- UI for Neovim notifications and LSP progress messages
      -- NOTE: `opts = {}` will automatically call `require("fidget").setup(opts)`
      { "j-hui/fidget.nvim", opts = {} },

      -- Settings to enable lua-language-server to support Neovim lua API
      "folke/neodev.nvim",
    }
  },
  {
    'nvimdev/lspsaga.nvim',
    event = "LspAttach",
    config = function()
      require('lspsaga').setup({
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = true },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons'      -- optional
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- build = { vim.cmd('TSUpdateSync') },
    dependencies = {
      --
      -- NOTE: Difference in behavior between nvim-treesitter-endwise and vim-endwise
      --
      -- ### nvim-treesitter-endwise
      --
      -- `end` keyword is added if I enter a class name or method name.
      --
      --   class Foo
      --            ^-- send newline
      --   end <-- added
      --
      -- ### vim-endwise
      --
      -- `end` keyword is added even if I don't enter the class name or method name.
      --
      --   class
      --        ^-- send newline
      --   end <-- added
      --
      -- ref. https://github.com/nvim-treesitter/nvim-treesitter/issues/703
      --
      'RRethy/nvim-treesitter-endwise', -- alternative to vim-endwise
      'windwp/nvim-ts-autotag', -- auto close html tag
    }
  },
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- completion source for neovim builtin LSP client
      "hrsh7th/cmp-buffer",       -- completion source for buffer words
      "hrsh7th/cmp-path",         -- completion source for path
      "hrsh7th/cmp-cmdline",      -- completion source for vim's cmdline
      "saadparwaiz1/cmp_luasnip", -- completion source for luasnip
      "L3MON4D3/LuaSnip",         -- snippet engine
      "onsails/lspkind.nvim",     -- pictograms for completion items
    }
  },
  {
    'goolord/alpha-nvim', -- start screen
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },
  {
    "nvim-lualine/lualine.nvim", -- statusline and tabline
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    }
  },
  {
    "folke/trouble.nvim", -- pretty list for showing diagnostics
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim", -- typescript integration
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig"
    }
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   config = function(_, opts) require'lsp_signature'.setup(opts) end
  -- },
  -- { "mfussenegger/nvim-lint" }, -- linter
  { "stevearc/conform.nvim" }, -- formatter
  { "lewis6991/gitsigns.nvim" }, -- display git diff signs
}

local opts = {
  ui = {
    -- Display single border on the UI window.
    border = "single",
  },
  -- Output options for headless mode
  headless = {
    -- show the output from process commands like git (default: true)
    -- note: If true, line break is unstable on output. If false, line break is guaranteed.
    process = false,
    -- show log messages
    log = true,
    -- show task start/end (default: true)
    task = false,
    -- use ansi colors
    colors = true,
  },
}

vim.g.mapleader = " "
require("lazy").setup(plugins, opts)


------------------------------------------------------------
-- Check a plugin installation
------------------------------------------------------------
-- TODO: migrate later
--
-- vim.api.nvim_exec([[
--   function! PlugIsNotInstalled(plugin_name) abort
--     if ! has_key(g:plugs, a:plugin_name)
--       return v:true
--     endif
--     if ! isdirectory(g:plugs[a:plugin_name]['dir'])
--       return v:true
--     endif
--
--     return v:false
--   endfunction
-- ]])


------------------------------------------------------------
-- ctags
------------------------------------------------------------
-- TODO: migrate later
--
-- -- Show the list when it has many candidates
-- -- Use :tjump instead of :tag
-- nnoremap <C-]> g<C-]>


------------------------------------------------------------
-- Tab jump
------------------------------------------------------------
-- jump to the target tab by specify the number (t1, t2, t3...)
for n = 1, 9 do
  vim.keymap.set('n', 't'..n, ':<C-u>tabnext' .. n .. '<CR>', { silent = true })
end

vim.keymap.set('n', 'tc', ':tablast <bar> tabnew<CR>', { silent = true })
vim.keymap.set('n', 'tx', ':tabclose<CR>', { silent = true })
vim.keymap.set('n', 'tn', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', 'tp', ':tabprevious<CR>', { silent = true })


------------------------------------------------------------
-- Common
------------------------------------------------------------
-- Since space is used as prefix in nvim-lspconfig, nothing is done with space alone.
-- ref. https://github.com/neovim/nvim-lspconfig#suggested-configuration
vim.keymap.set('n', '<Space>', '<Nop>', {})

vim.opt.number = true
vim.opt.list = true
vim.opt.wrap = false
vim.opt.fixeol = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.splitbelow = true     -- Open splited window to below
vim.opt.splitright = true     -- Open splited window to right
vim.opt.swapfile = false      -- Don't make a swap file (.swp)
vim.opt.backup = false        -- Don't make a backup file (~[file name])
vim.opt.formatoptions = "tcrqj" -- Add `r` option (automatically insert comment leader after hitting <Enter>)
vim.opt.tagcase = "match"     -- Search a tag file case-sensitively
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("I") -- Don't display intro message when starting vim
vim.opt.tabstop = 2
vim.opt.foldlevelstart = 99   -- Don't always fold
vim.opt.showtabline = 2       -- Always show tab line
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3        -- Have a global statusline at the bottom instead of one for each window
vim.opt.mouse = ""            -- Disable mouse support
vim.opt.ambiwidth = "single"  -- Display East Asian Ambiguous Width characters in 1 byte
vim.opt.updatetime = 300      -- Fire CursorHold event immediately and display diagnostic message
vim.opt.winbar = " "          -- Display the winbar in advance to display breadcrumbs.


------------------------------------------------------------
-- Set character widths
------------------------------------------------------------
vim.api.nvim_set_var('cellwidths', {
  { 0x2192, 0x2192, 2 }, -- Rightwards arrow
  { 0x2605, 0x2605, 2 }  -- Black star
})


------------------------------------------------------------
-- Autocommands
------------------------------------------------------------
vim.cmd([[
augroup init_vim_autocommands
  autocmd!

  " Delete unnecessary trailing spaces
  autocmd BufWritePre * :%s/\s\+$//ge

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif

  " Open tab pages for each argument.
  "
  " example:
  "   $ vi a.txt b.txt
  "
  "   :tabs
  "   Tab page 1
  "   >   a.txt
  "   Tab page 2
  "   #   b.txt
  "
  " NOTE: Check the number of arguments to avoid an error.
  "
  " * Do not check the number of arguments in the if statement.
  " * Open a file with Neovim and quit immediately.
  " * Confirm that autocmd sometimes fails in the following cases.
  "
  autocmd VimEnter *
        \ if len(argv()) >= 2 |
        \   tab all |
        \ endif
augroup END
]])
