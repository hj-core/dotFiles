-- ========================================================================== --
-- 1. BOOTSTRAP LAZY.NVIM (Automated Package Manager Installation)            --
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 2. GLOBAL LEADER SETUP (Must be set BEFORE loading lazy.nvim)               --
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>p", function()
	require("conform").format({
		lsp_format = "fallback",
		async = true,
	})
end, { desc = "Format current file" })

-- ========================================================================== --
-- 3. PLUGIN CONFIGURATION                                                    --
-- ========================================================================== --
require("lazy").setup({
	-- Colorscheme (High priority so it loads first)
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Status Line (Lualine)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	-- Git signs in the gutter margin
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	-- MODERN Syntax Highlighting & Experimental Indentation
	{
		"romus204/tree-sitter-manager.nvim",
		cmd = { "TSManager" }, -- Lazy load until you call the manager UI
		config = function()
			require("tree-sitter-manager").setup({
				-- Automatically download and install missing parsers when you open a file
				auto_install = true,

				-- Optional: Opt-out specific languages from auto-installing
				-- noauto_install = { "yaml" },

				-- Optional: Fallback to standard regex highlighting for specific languages
				-- nohighlight = { "zsh" },
			})
		end,
	},

	-- Diagnostics & Quickfix (Trouble)
	{
		"folke/trouble.nvim",
		version = "*",
		opts = {},
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Items (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		},
	},

	-- Fuzzy Finder (Telescope)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
		},
	},

	-- Formatter (conform.nvim & mason.nvim)
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	-- File Explorer (Oil.nvim)
	{
		"stevearc/oil.nvim",
		version = "*",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
	},

	-- Motion and Navigation (Flash)
	{
		"folke/flash.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	-- Code Surroundings (nvim-surround)
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "markdownlint" },
	},
	-- If no formatter is found above, conform will use the attached LSP
	default_format_opts = {
		lsp_format = "fallback", -- or true, or "always"
	},
})

require("mason").setup({
	firewall = {
		enabled = true,
	},
})

-- ========================================================================== --
-- 4. GLOBAL OPTIONS & THEME ACTIVATION                                       --
-- ========================================================================== --
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative numbers for easy jumping
vim.opt.termguicolors = true -- True color support for terminal themes
vim.opt.cursorline = true -- Highlight the line where the cursor currently sits
vim.opt.scrolloff = 8 -- Keeps 8 lines visible above/below the cursor when scrolling
vim.opt.sidescrolloff = 8 -- Keeps 8 columns visible left/right of the cursor
vim.opt.signcolumn = "yes" -- ALWAYS show the sign column (prevents text layout shifting)
vim.opt.splitright = true -- Open horizontal splits to the right
vim.opt.splitbelow = true -- Open vertical splits below
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 4 -- Insert 4 spaces for a tab
vim.opt.shiftwidth = 4 -- Change the number of spaces inserted for indentation
vim.opt.smartindent = true -- Makes indenting smart based on code syntax
vim.opt.ignorecase = true -- Ignore case when typing search patterns
vim.opt.smartcase = true -- ...unless the search pattern contains an uppercase letter
vim.opt.undofile = true -- Save undo history to a file (Persistent Undo)
vim.opt.updatetime = 250 -- Decrease response time (Defaults to a sluggish 4000ms)
vim.opt.clipboard = "unnamedplus" -- Syncs Neovim clipboard with your system clipboard

-- Activate the Catppuccin flavor
vim.cmd.colorscheme("catppuccin-mocha")
