-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.smartindent = true     -- Habilita indentação inteligente
vim.opt.autoindent = true      -- Indentação automática ao pressionar Enter
vim.opt.tabstop = 2            -- Defina o tamanho do tab
vim.opt.shiftwidth = 2         -- Número de espaços para cada indentação
vim.opt.expandtab = true       -- Use espaços ao invés de tabs
vim.opt.smarttab = true        -- Torna o tab inteligente, ajustando o recuo automaticamente
vim.opt.copyindent = true      -- Copiar indentação da linha anterior
-- vim.o.background = 'light'
vim.o.scrolloff = 5
-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --
-- Leader key
vim.g.mapleader = ' '
-- Shotcuts
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggvg<cr>', { desc = 'select all file' })
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^', { desc = 'go to the first character of the line'})
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_', { desc = 'go to the last character of the line'})
vim.keymap.set('n', 'o', ":call append(line('.'), '') | normal! j<CR>", { noremap = true, silent = true })
vim.keymap.set('n', 'O', ":call append(line('.')-1, '') | normal! k<CR>", { noremap = true, silent = true })
-- Clipboard interaction
vim.keymap.set({'n', 'x'}, 'y', '"+y')
-- vim.keymap.set({'n', 'x'}, 'gp', '"+p')
-- Paste text
vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without overwriting registers' })
vim.keymap.set('x', 'P', '"_dP', { desc = 'Paste above without overwriting registers' })
-- Delete text
vim.keymap.set({'s'}, 'x', '"+x')
vim.keymap.set({'n'}, 'x', '"_x')
vim.keymap.set({'n'}, 'X', '"_X')
vim.keymap.set({'n', 'x'}, 'd', '"_d')
vim.keymap.set({'n', 'x'}, 'D', '"_D')
-- Tab
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>', {desc = 'Delete current buffer'})
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>', {desc = 'Switch to the last active buffer'})
-- Compiladores
vim.api.nvim_set_keymap('n', '<leader>cj', ':!javac % && java %:r<CR>', { noremap = true, desc = 'Compile and run Java code' })
-- Folds
vim.o.foldmethod = 'expr'      -- Usa expressão para dobrar
vim.o.foldexpr = 'nvim_treesitter#foldexpr()' -- Expressão do Treesitter
vim.o.foldenable = true        -- Habilita as dobras
vim.o.foldlevel = 99           -- Define o nível inicial das dobras
-- Change
vim.api.nvim_set_keymap('v', 'c', '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'C', '"_C', { noremap = true, silent = true })
-- Navegation
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-b>', '<C-Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-w>', '<C-Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-L>', '<End>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-H>', '<Home>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S>', '<Esc>:w<CR>a', { noremap = true, silent = true })

-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

local user_cmds_group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

-- Autocmd - See for learn ':help autocmd-intro'
vim.api.nvim_create_autocmd('TextYankPost', {
  group = user_cmds_group,
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 500})
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'man'},
  group = user_cmds_group,
  desc = 'Use q to close the window',
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- Lazyvim installation
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Plugins list
require('lazy').setup({
  spec = {
		{'folke/tokyonight.nvim'}, -- theme
		{'kyazdani42/nvim-web-devicons'}, -- icons
		{'folke/which-key.nvim'},
		{'nvim-treesitter/nvim-treesitter'},
		{'nvim-treesitter/nvim-treesitter-textobjects'},
		{'numToStr/Comment.nvim'},
		-- {'wellle/targets.vim'},
		{'windwp/nvim-autopairs', event = 'InsertEnter', config = true},
		{'nvim-telescope/telescope.nvim', branch = '0.1.x', build = false},
		{'nvim-lualine/lualine.nvim'},
		{'natecraddock/telescope-zf-native.nvim', build = false},
		{'echasnovski/mini.nvim', branch = 'stable'},
		{'williamboman/mason.nvim'},
		{'williamboman/mason-lspconfig.nvim'},
		{'neovim/nvim-lspconfig'},
		{'hrsh7th/nvim-cmp'},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/cmp-buffer'},
		{'hrsh7th/cmp-path'},
		{'hrsh7th/cmp-cmdline'},
		{
			'L3MON4D3/LuaSnip', -- snippt
			dependencies = { 'rafamadriz/friendly-snippets' } -- snippt
		},
		{'saadparwaiz1/cmp_luasnip'}, -- snippt
		{'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}},
    {'vidocqh/auto-indent.nvim', opts = {}},
		{
			'nvim-neo-tree/neo-tree.nvim', branch = 'v3.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
				'MunifTanjim/nui.nvim',
				-- '3rd/image.nvim', -- Optional image support in preview window: See `--[[ # Preview Mode ]]` for more information
				{ 's1n7ax/nvim-window-picker', version = '2.*' },
			}
		},
		{'akinsho/toggleterm.nvim', version = '*'},
		{
		  'iamcco/markdown-preview.nvim',
		  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		  build = 'cd app && pnpm install',
		  init = function()
		    vim.g.mkdp_filetypes = { 'markdown' }
		  end,
		  ft = { 'markdown' },
		},
		{'roobert/tailwindcss-colorizer-cmp.nvim'},
		{
	    'NvChad/nvim-colorizer.lua',
	    event = 'BufReadPre',
	    opts = { -- set to setup table
			},
		},
		{'themaxmarchuk/tailwindcss-colors.nvim'},
		{'windwp/nvim-ts-autotag'},
		{
			'kylechui/nvim-surround',
			version = '*', -- Use for stability; omit to use `main` branch for the latest features
			event = 'VeryLazy',
			config = function()
				require('nvim-surround').setup({
					-- Configuration here, or leave empty to use defaults
				})
			end
		}
	},
})
-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --
--==========
-- Colorsheme
--==========
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')
--==========
-- Netrw
--==========
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 20
-- vim.g.netrw_keepdir = 0
-- vim.keymap.set('n', '<leader>E', '<cmd>Lexplore<cr>', {desc = 'Toggle file explorer', noremap = true, silent = true})
-- vim.keymap.set('n', '<leader>e', '<cmd>Explore<cr>', {desc = 'Open file explorer in current buffer', noremap = true, silent = true})
--==========
-- lualine.nvim (statusline)
--==========
vim.opt.showmode = false
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
		disabled_filetypes = {
      statusline = {'NvimTree'}
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      { 'filename', path = 1 }, -- Mostra o caminho relativo ao projeto
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
})
--==========
-- auto-indent 
--==========
require('auto-indent').setup({
  lightmode = true,        -- Lightmode assumes tabstop and indentexpr not change within buffer's lifetime
  ignore_filetype = {},    -- Disable plugin for specific filetypes, e.g. ignore_filetype = { 'javascript' }
  indentexpr = function(lnum)
    return require("nvim-treesitter.indent").get_indent(lnum)
  end
})
--==========
-- nvim-ts-autotag
--==========
require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the 'opts' global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ['html'] = {
      enable_close = false
    }
  }
})
--==========
-- themaxmarchuk/tailwindcss-colors.nvim
--==========
require('tailwindcss-colors').setup({
	colors = {
    dark = '#000000',  -- dark text color
    light = '#FFFFFF', -- light text color
  },
  commands = true -- should add commands
})
--==========
-- See :help which-key.nvim-which-key-setup
--==========
require('which-key').setup({
  icons = { mappings = false, },
})

require('which-key').add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
  {'<leader>e', group = 'Explorer'},
  {'<leader>c', group = 'Compilers'},
})
--==========
-- See :help nvim-treesitter-modules | See also :help nvim-treesitter-textobjects-modules
--==========
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,            -- Habilita o destaque de sintaxe
    additional_vim_regex_highlighting = false, -- Usa apenas Treesitter
  },
  indent = {
    enable = true,
  },
	incremental_selection = {
		enable = true,
	},
	auto_install = true,
	textobjects = {
    select = {
      enable = true,
      lookahead = true,
			prev_selection = ',',
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
				['aa'] = '@attribute.outer',
        ['ia'] = '@attribute.inner',
			},
    },
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				[']m'] = '@function.outer',
				[']t'] = '@parameter.outer',
				[']it'] = '@parameter.inner',
				[']a'] = '@attribute.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']T'] = '@parameter.outer',
				[']iT'] = '@parameter.inner',
				[']A'] = '@attribute.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[t'] = '@parameter.outer',
				['[it'] = '@parameter.inner',
				['[a'] = '@attribute.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[T'] = '@parameter.outer',
				['[iT'] = '@parameter.inner',
				['[A'] = '@attribute.outer',
			},
		},
  },
  ensure_installed = {'lua', 'vim', 'vimdoc', 'json', 'markdown', 'markdown_inline', 'javascript', 'typescript', 'tsx', 'css', 'go', 'c', 'bash', 'java', 'html' },
})
--==========
-- See :help telescope.builtin
--==========
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {desc = 'Buffer local search'})
--==========
-- telescope-zf-native
--==========
require('telescope').load_extension('zf-native')
--==========
-- Mini
--==========
-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({n_lines = 500})
-- See :help MiniBufremove.config
require('mini.bufremove').setup({})
-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})
-- See :help MiniNotify.make_notify()
vim.notify = require('mini.notify').make_notify({})
-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})
--==========
-- LuaSnip
--==========
require('luasnip.loaders.from_vscode').lazy_load()
--==========
-- See :h tailwindcss-colorizer-cmp
--==========
require('tailwindcss-colorizer-cmp').setup({
	color_square_width = 2,
})
--==========
-- Cmp
--==========
local cmp = require('cmp')
-- See :help cmp-config
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
		{ name = 'path' },
    { name = 'luasnip' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
	formatting = {
		format = require('tailwindcss-colorizer-cmp').formatter
	}
})
--==========
-- See :h mason-quickstart
--==========
require('mason').setup()
--==========
-- See :h mason-lspconfig-quickstart
--==========
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'ts_ls',  'marksman', 'pyright', 'jdtls', 'gopls', 'tailwindcss' },
}
--==========
-- Lspconfig
--==========
local lspconfig = require('lspconfig')
-- Adds nvim-cmp's capabilities settings to
-- lspconfig's default config
lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})
-- List of compatible language servers is here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
require('lspconfig').lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },         -- Reconhece `vim` como uma global
			},
		},
	},
}
require('lspconfig').ts_ls.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').marksman.setup{}
require('lspconfig').jdtls.setup{}
require('lspconfig').gopls.setup{}
require('lspconfig').tailwindcss.setup({
  on_attach = function(_, bufnr)
		require('tailwindcss-colors').buf_attach(bufnr)
	end,
})
--==========
-- Indent Blankline - see :help ibl.config
--==========
require('ibl').setup({
  enabled = true,
  scope = {
    enabled = false,
  },
  indent = {
    char = '▏',
  },
})
--==========
-- See :help comment-nvim
--==========
require('Comment').setup()
--==========
-- See :help neo-tree
--==========
-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define('DiagnosticSignError', {text = ' ', texthl = 'DiagnosticSignError'})
vim.fn.sign_define('DiagnosticSignWarn', {text = ' ', texthl = 'DiagnosticSignWarn'})
vim.fn.sign_define('DiagnosticSignInfo', {text = ' ', texthl = 'DiagnosticSignInfo'})
vim.fn.sign_define('DiagnosticSignHint', {text = '󰌵', texthl = 'DiagnosticSignHint'})
require('neo-tree').setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false, -- Mostra arquivos ocultos
      hide_gitignored = false, -- Mostra arquivos ignorados pelo Git
    },
  },
})
-- keymaps
vim.keymap.set('n', '<leader>ee', '<cmd>Neotree toggle<cr>', { desc = 'Toggle explorer'})
vim.keymap.set('n', '<leader>en', '<cmd>Neotree focus<cr>', { desc = 'Focus explorer'})
vim.keymap.set('n', '<leader>eB', '<cmd>Neotree buffers<cr>', { desc = 'Show buffers'})
-- Positions
vim.keymap.set('n', '<leader>et', '<cmd>Neotree top<cr>', { desc = 'Top'})
vim.keymap.set('n', '<leader>el', '<cmd>Neotree left<cr>', { desc = 'Left'})
vim.keymap.set('n', '<leader>eb', '<cmd>Neotree bottom<cr>', { desc = 'Bottom'})
vim.keymap.set('n', '<leader>er', '<cmd>Neotree right<cr>', { desc = 'Right'})
vim.keymap.set('n', '<leader>ef', '<cmd>Neotree float<cr>', { desc = 'Float'})
--==========
-- Windows Picker
--==========
require('window-picker').setup({
	filter_rules = {
		include_current_win = false,
		autoselect_one = true,
		-- filter using buffer options
		bo = {
			-- if the file type is one of following, the window will be ignored
			filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
			-- if the buffer type is one of following, the window will be ignored
			buftype = { 'terminal', 'quickfix' },
		},
	},
})
--==========
-- Toggleterm
--==========
require('toggleterm').setup({
	open_mapping = [[<c-t>]],
})
vim.keymap.set({ 't', 'n' }, '<C-a>', [[<Cmd>ToggleTermToggleAll<CR>]])
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')




