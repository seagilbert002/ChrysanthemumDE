------ GENERAL SETTINGS -----
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"

----- PLUGIN MANAGER -----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- UI & Aesthetics
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  { "vim-airline/vim-airline" },
  { "nvim-tree/nvim-web-devicons" }, -- Modern alternative to vim-devicons

  -- Fuzzy Finder (Telescope)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      -- The specific mapping you requested
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      -- Recommended: find files mapping
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    end
  },

  -- nvim-tree (The recommended replacement for NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false }, -- Shows hidden files like your old config
      })
      -- Mappings to match your old leader nt/nf style
      vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>')
      vim.keymap.set('n', '<leader>nf', ':NvimTreeFocus<CR>')
    end,
  },

  -- Navigation & Utilities
  {
    "vimwiki/vimwiki",
    init = function()
      -- This 'init' function runs BEFORE the plugin loads
      vim.g.vimwiki_list = {
        {
          path = '/home/kalli/Documents/vimwiki',
          syntax = 'markdown',
          ext = '.md',
        },
      }
      -- Ensure it doesn't hijack every .md file on your system
      vim.g.vimwiki_global_ext = 0
    end,
  },
  { "sheerun/vim-polyglot" },

  -- LSP & Autocomplete (The Modern Way)
  { "neovim/nvim-lspconfig" },             -- Required: Native LSP configs
  { "williamboman/mason.nvim" },           -- Replaces vim-lsp-settings (UI for installers)
  { "williamboman/mason-lspconfig.nvim" }, -- Bridges mason and lspconfig
  { "hrsh7th/nvim-cmp" },                  -- Replaces asyncomplete
  { "hrsh7th/cmp-nvim-lsp" },              -- LSP source for nvim-cmp
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
})

-- ------- COLORSCHEME -------
vim.g.everforest_background = 'medium'
vim.g.everforest_better_performance = 1
vim.cmd([[colorscheme everforest]])
-- Transparent background as requested in your vimrc
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- nvim-tree transparency
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- ------- LSP & AUTOCOMPLETE SETUP -------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "gopls" }, -- Automatically installs gopls
    automatic_installation = true,
})
vim.keymap.set('n', '<leader>ls', ':Mason<CR>', { desc = 'LSP Storage/Install' })

-- Modern way for Neovim 0.11+
vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.work', 'go.mod', '.git' },
  })
vim.lsp.enable('gopls')

-- Basic Autocomplete keybinds
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- ------- VIMWIKI -------
vim.g.vimwiki_list = {{
  path = '/home/kalli/Documents/vimwiki',
  syntax = 'markdown',
  ext = '.md'
}}
vim.keymap.set('n', '<leader>w<leader>n', ':VimwikiMakeTomorrowDiaryNote<CR>')
vim.keymap.set('n', '<leader>dp', ':VimwikiDiaryGenerateLinks<CR>')
