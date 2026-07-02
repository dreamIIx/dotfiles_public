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

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.json" },
    -- import/override with your plugins
    { import = "plugins" },
    { "Mofiqul/vscode.nvim" },
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    {
        "saghen/blink.cmp",
        keymap = {
            preset = "default",
            ["<CR>"] = {},
        },
    },
    {
      "kdheepak/lazygit.nvim",
      -- optional for floating window border decoration
      requires = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
        "mg979/vim-visual-multi"
	},
	{
		'rmagatti/auto-session',
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
			-- log_level = 'debug',
		}
	},
	{
		'mikesmithgh/kitty-scrollback.nvim',
		enabled = true,
		lazy = true,
		cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
		event = { 'User KittyScrollbackLaunch' },
		-- version = '*', -- latest stable version, may have breaking changes if major version changed
		-- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
		config = function()
			require('kitty-scrollback').setup()
		end,
	},
  {
    'HiPhish/rainbow-delimiters.nvim'
  }
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

local M = {}

M.sudo_exec = function(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    M.warn("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    M.err(out)
    return false
  end
  if print_output then
    print("\r\n", out)
  end
  return true
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand("%")
  end
  if not filepath or #filepath == 0 then
    M.err("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = true })
  if M.sudo_exec(cmd) then
    -- refreshes the buffer and prints the "written" message
    vim.cmd.checktime()
    -- exit command mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  end
  vim.fn.delete(tmpfile)
end

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { silent = true, buffer = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("c", "w!!", M.sudo_write, { silent = true })

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- require("lspconfig").clangd.setup({
--   init_options = {
--     fallbackFlags = { "--std=c++2b" },
--   },
-- })

require("clangd_extensions").setup({
    ast = {
        -- These are unicode, should be available in any font
        -- role_icons = {
        --     type = "🄣",
        --     declaration = "🄓",
        --     expression = "🄔",
        --     statement = ";",
        --     specifier = "🄢",
        --     ["template argument"] = "🆃",
        -- },
        -- kind_icons = {
        --     Compound = "🄲",
        --     Recovery = "🅁",
        --     TranslationUnit = "🅄",
        --     PackExpansion = "🄿",
        --     TemplateTypeParm = "🅃",
        --     TemplateTemplateParm = "🅃",
        --     TemplateParamObject = "🅃",
        -- },
        role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
        },

        kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
        },

        highlights = {
            detail = "Comment",
        },
    },
    memory_usage = {
        border = "none",
    },
    symbol_info = {
        border = "none",
    },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.b.autoformat = false
  end,
})

-- require("telescope").setup({
--   defaults = {
--     -- configure to use ripgrep
--     vimgrep_arguments = {
--       "rg",
--       "--follow", -- Follow symbolic links
--       "--hidden", -- Search for hidden files
--       "--no-heading", -- Don't group matches by each file
--       "--with-filename", -- Print the file path with the matched lines
--       "--line-number", -- Show line numbers
--       "--column", -- Show column numbers
--       "--smart-case", -- Smart case search
--
--       -- Exclude some patterns from search
--       "--glob=!**/.git/*",
--       "--glob=!**/.idea/*",
--       "--glob=!**/.vscode/*",
--       "--glob=!**/build/*",
--       "--glob=!**/dist/*",
--       "--glob=!**/yarn.lock",
--       "--glob=!**/package-lock.json",
--     },
--   },
--   pickers = {
--     find_files = {
--       hidden = true,
--       -- needed to exclude some files & dirs from general search
--       -- when not included or specified in .gitignore
--       find_command = {
--         "rg",
--         "--files",
--         "--hidden",
--         "--glob=!**/.git/*",
--         "--glob=!**/.idea/*",
--         "--glob=!**/.vscode/*",
--         "--glob=!**/build/*",
--         "--glob=!**/dist/*",
--         "--glob=!**/yarn.lock",
--         "--glob=!**/package-lock.json",
--       },
--     },
--   },
-- })

require('neo-tree').setup {
	filesystem = {
		filtered_items = {
			visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
			hide_dotfiles = false,
			hide_gitignored = true,
		},
	}
}
-- require("neo-tree").setup({
--   close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
--   popup_border_style = "rounded",
--   enable_git_status = true,
--   enable_diagnostics = true,
--   open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
--   sort_case_insensitive = false, -- used when sorting files and directories in the tree
--   sort_function = nil, -- use a custom function for sorting files and directories in the tree
--   -- sort_function = function (a,b)
--   --       if a.type == b.type then
--   --           return a.path > b.path
--   --       else
--   --           return a.type > b.type
--   --       end
--   --   end , -- this sorts files and directories descendantly
--   default_component_configs = {
--     container = {
--       enable_character_fade = true,
--     },
--     indent = {
--       indent_size = 2,
--       padding = 1, -- extra padding on left hand side
--       -- indent guides
--       with_markers = true,
--       indent_marker = "│",
--       last_indent_marker = "└",
--       highlight = "NeoTreeIndentMarker",
--       -- expander config, needed for nesting files
--       with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
--       expander_collapsed = "",
--       expander_expanded = "",
--       expander_highlight = "NeoTreeExpander",
--     },
--     icon = {
--       folder_closed = "",
--       folder_open = "",
--       folder_empty = "󰜌",
--       provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
--         if node.type == "file" or node.type == "terminal" then
--           local success, web_devicons = pcall(require, "nvim-web-devicons")
--           local name = node.type == "terminal" and "terminal" or node.name
--           if success then
--             local devicon, hl = web_devicons.get_icon(name)
--             icon.text = devicon or icon.text
--             icon.highlight = hl or icon.highlight
--           end
--         end
--       end,
--       -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
--       -- then these will never be used.
--       default = "*",
--       highlight = "NeoTreeFileIcon",
--     },
--     modified = {
--       symbol = "[+]",
--       highlight = "NeoTreeModified",
--     },
--     name = {
--       trailing_slash = false,
--       use_git_status_colors = true,
--       highlight = "NeoTreeFileName",
--     },
--     git_status = {
--       symbols = {
--         -- Change type
--         added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
--         modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
--         deleted = "✖", -- this can only be used in the git_status source
--         renamed = "󰁕", -- this can only be used in the git_status source
--         -- Status type
--         untracked = "",
--         ignored = "",
--         unstaged = "󰄱",
--         staged = "",
--         conflict = "",
--       },
--     },
--     -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
--     file_size = {
--       enabled = true,
--       required_width = 64, -- min width of window required to show this column
--     },
--     type = {
--       enabled = true,
--       required_width = 122, -- min width of window required to show this column
--     },
--     last_modified = {
--       enabled = true,
--       required_width = 88, -- min width of window required to show this column
--     },
--     created = {
--       enabled = true,
--       required_width = 110, -- min width of window required to show this column
--     },
--     symlink_target = {
--       enabled = false,
--     },
--   },
--   -- A list of functions, each representing a global custom command
--   -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
--   -- see `:h neo-tree-custom-commands-global`
--   commands = {},
--   window = {
--     position = "left",
--     width = 40,
--     mapping_options = {
--       noremap = true,
--       nowait = true,
--     },
--     mappings = {
--       ["<space>"] = {
--         "toggle_node",
--         nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
--       },
--       ["<2-LeftMouse>"] = "open",
--       ["<cr>"] = "open",
--       ["<esc>"] = "cancel", -- close preview or floating neo-tree window
--       ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
--       -- Read `# Preview Mode` for more information
--       ["l"] = "focus_preview",
--       ["S"] = "open_split",
--       ["s"] = "open_vsplit",
--       -- ["S"] = "split_with_window_picker",
--       -- ["s"] = "vsplit_with_window_picker",
--       ["t"] = "open_tabnew",
--       -- ["<cr>"] = "open_drop",
--       -- ["t"] = "open_tab_drop",
--       ["w"] = "open_with_window_picker",
--       --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
--       ["C"] = "close_node",
--       -- ['C'] = 'close_all_subnodes',
--       ["z"] = "close_all_nodes",
--       --["Z"] = "expand_all_nodes",
--       ["a"] = {
--         "add",
--         -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
--         -- some commands may take optional config options, see `:h neo-tree-mappings` for details
--         config = {
--           show_path = "none", -- "none", "relative", "absolute"
--         },
--       },
--       ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
--       ["d"] = "delete",
--       ["r"] = "rename",
--       ["y"] = "copy_to_clipboard",
--       ["x"] = "cut_to_clipboard",
--       ["p"] = "paste_from_clipboard",
--       ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
--       -- ["c"] = {
--       --  "copy",
--       --  config = {
--       --    show_path = "none" -- "none", "relative", "absolute"
--       --  }
--       --}
--       ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
--       ["q"] = "close_window",
--       ["R"] = "refresh",
--       ["?"] = "show_help",
--       ["<"] = "prev_source",
--       [">"] = "next_source",
--       ["i"] = "show_file_details",
--     },
--   },
--   nesting_rules = {},
--   filesystem = {
--     filtered_items = {
--       visible = false, -- when true, they will just be displayed differently than normal items
--       hide_dotfiles = false,
--       hide_gitignored = false,
--       hide_hidden = false, -- only works on Windows for hidden files/directories
--       hide_by_name = {
--         --"node_modules"
--       },
--       hide_by_pattern = { -- uses glob style patterns
--         --"*.meta",
--         --"*/src/*/tsconfig.json",
--       },
--       always_show = { -- remains visible even if other settings would normally hide it
--         --".gitignored",
--       },
--       always_show_by_pattern = { -- uses glob style patterns
--         --".env*",
--       },
--       never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
--         --".DS_Store",
--         --"thumbs.db"
--       },
--       never_show_by_pattern = { -- uses glob style patterns
--         --".null-ls_*",
--       },
--     },
--     follow_current_file = {
--       enabled = false, -- This will find and focus the file in the active buffer every time
--       --               -- the current file is changed while the tree is open.
--       leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
--     },
--     group_empty_dirs = false, -- when true, empty folders will be grouped together
--     hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
--     -- in whatever position is specified in window.position
--     -- "open_current",  -- netrw disabled, opening a directory opens within the
--     -- window like netrw would, regardless of window.position
--     -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
--     use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
--     -- instead of relying on nvim autocmd events.
--     window = {
--       mappings = {
--         ["<bs>"] = "navigate_up",
--         ["."] = "set_root",
--         ["H"] = "toggle_hidden",
--         ["/"] = "fuzzy_finder",
--         ["D"] = "fuzzy_finder_directory",
--         ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
--         -- ["D"] = "fuzzy_sorter_directory",
--         ["f"] = "filter_on_submit",
--         ["<c-x>"] = "clear_filter",
--         ["[g"] = "prev_git_modified",
--         ["]g"] = "next_git_modified",
--         ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
--         ["oc"] = { "order_by_created", nowait = false },
--         ["od"] = { "order_by_diagnostics", nowait = false },
--         ["og"] = { "order_by_git_status", nowait = false },
--         ["om"] = { "order_by_modified", nowait = false },
--         ["on"] = { "order_by_name", nowait = false },
--         ["os"] = { "order_by_size", nowait = false },
--         ["ot"] = { "order_by_type", nowait = false },
--         -- ['<key>'] = function(state) ... end,
--       },
--       fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
--         ["<down>"] = "move_cursor_down",
--         ["<C-n>"] = "move_cursor_down",
--         ["<up>"] = "move_cursor_up",
--         ["<C-p>"] = "move_cursor_up",
--         -- ['<key>'] = function(state, scroll_padding) ... end,
--       },
--     },
--
--     commands = {}, -- Add a custom command or override a global one using the same function name
--   },
--   buffers = {
--     follow_current_file = {
--       enabled = true, -- This will find and focus the file in the active buffer every time
--       --              -- the current file is changed while the tree is open.
--       leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
--     },
--     group_empty_dirs = true, -- when true, empty folders will be grouped together
--     show_unloaded = true,
--     window = {
--       mappings = {
--         ["bd"] = "buffer_delete",
--         ["<bs>"] = "navigate_up",
--         ["."] = "set_root",
--         ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
--         ["oc"] = { "order_by_created", nowait = false },
--         ["od"] = { "order_by_diagnostics", nowait = false },
--         ["om"] = { "order_by_modified", nowait = false },
--         ["on"] = { "order_by_name", nowait = false },
--         ["os"] = { "order_by_size", nowait = false },
--         ["ot"] = { "order_by_type", nowait = false },
--       },
--     },
--   },
--   git_status = {
--     window = {
--       position = "float",
--       mappings = {
--         ["A"] = "git_add_all",
--         ["gu"] = "git_unstage_file",
--         ["ga"] = "git_add_file",
--         ["gr"] = "git_revert_file",
--         ["gc"] = "git_commit",
--         ["gp"] = "git_push",
--         ["gg"] = "git_commit_and_push",
--         ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
--         ["oc"] = { "order_by_created", nowait = false },
--         ["od"] = { "order_by_diagnostics", nowait = false },
--         ["om"] = { "order_by_modified", nowait = false },
--         ["on"] = { "order_by_name", nowait = false },
--         ["os"] = { "order_by_size", nowait = false },
--         ["ot"] = { "order_by_type", nowait = false },
--       },
--     },
--   },
-- })

require("vscode").load()
-- require("toggleterm").setup({})

require('rainbow-delimiters.setup').setup {
    strategy = {
        -- ...
    },
    query = {
        -- ...
    },
    highlight = {
        -- ...
    },
}

local config_which_key = {
  opts = {
    preset = "classic",
  },
}

vim.keymap.set('n', '<MiddleMouse>', vim.lsp.buf.hover)
vim.keymap.set('n', '<A-h>', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left' })
vim.keymap.set('n', '<A-l>', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right' })
vim.keymap.set('n', '<C-A-Left>', '<C-o>', { desc = 'Previous jump list location' })
vim.keymap.set('n', '<C-A-Right>', '<C-i>', { desc = 'Next jump list location' })
