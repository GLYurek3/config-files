--[[ 
      ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **
     ----------------------------------------------------------
    <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
---<====██╗███╗░░██╗██╗████████╗░░░██╗░░░░░██╗░░░██╗░█████╗░====>---
--<=====██║████╗░██║██║╚══██╔══╝░░░██║░░░░░██║░░░██║██╔══██╗=====>--
-<======██║██╔██╗██║██║░░░██║░░░░░░██║░░░░░██║░░░██║███████║======>-
-<======██║██║╚████║██║░░░██║░░░░░░██║░░░░░██║░░░██║██╔══██║======>-
--<=====██║██║░╚███║██║░░░██║░░░██╗███████╗╚██████╔╝██║░░██║=====>--
---<====╚═╝╚═╝░░╚══╝╚═╝░░░╚═╝░░░╚═╝╚══════╝░╚═════╝░╚═╝░░╚═╝====>---
    <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	 ----------------------------------------------------------
	  ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **


I converted my init.vim to an init.lua slowly over a few days or so. as of 
writing this comment it will have been ~2 days or so  (09/20/2022 - 09/22/2022)
since I fully transitioned. Eventually it got to the point where my init.vim
was just full of lua blocks and a few  lines of vimscript here and there so I 
finally finished the job. Only part this is of vimscript are  the autocommands,
the method for making them in lua is kinda jank for now so I will sleep on that
unill the api gets better.

-- ]]

-- macros and functions, mostly for dev Ex (lua){{{
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local actions = require("diffview.actions")
local neogit = require("neogit")

-- this function just makes it less wordy to set keybinds in the
-- neovim lua api.
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
--}}}

--Plugins (lua){{{ 
cmd [[packadd packer.nvim]]

 require('packer').startup(function(use)
    	
    use { 'wbthomason/packer.nvim', } --                     <- Package manager for NeoVim.
    use { 'morhetz/gruvbox', } --                            <- A Colorscheme originally written for vim, but has found large success in the programming world.
	use { 'vim-airline/vim-airline', } --                    <- A statusbar plugin for Vim, because I am too lazy to make my own.
	use { 'vim-airline/vim-airline-themes', } --             <- Themes for Airline, for uniformity .
	use { 'ryanoasis/vim-devicons', } --                     <- Nice little Icons, mostly used in NERDTree but other places from time to time.
    use { 'mhinz/vim-startify', } --                         <- A Start page for Vim, a better alternative to a blank buffer.
	use { 'preservim/nerdtree', } --                         <- A file picker for Vim, for that #IDE aesthetic.
	use { 'tiagofumo/vim-nerdtree-syntax-highlight', } --    <- Different colors for different files are nice.
	use { 'PhilRunninger/nerdtree-buffer-ops', } --          <- I believe this is for indication for which files are open in a buffer.
	use { 'PhilRunninger/nerdtree-visual-selection', } --    <- Nope ... its this one.
	use { 'christoomey/vim-tmux-navigator', } --             <- A good method to navigate between tmux windows and vim splits, good for user sanity. 
--  use { 'scrooloose/syntastic', } --                       <- Syntax highligher for vim based on regex I believe. (inert)   
	use { 'vim-jp/vim-cpp', } --                             <- Makes coding in C++ a little better.
	use { 'octol/vim-cpp-enhanced-highlight', } --           <- Better highlighting for C++
	use { 'georgewitteman/vim-fish', } --                    <- Allows for a more stable harmony between NeoVim and the Fish shell
	use { 'airblade/vim-gitgutter', } --                     <- A good indicator for whats new and what hasn't been commited yet.
--  use { 'tpope/vim-fugitive',} --                          <- git intigration for vim inert until I stop using NeoGit
	use { 'w0rp/ale', } --                                   <- Indicates where the issues in your code are with a red >> 
    use { 'famiu/bufdelete.nvim'} --                         <- Says it helps retain the layout after a buffer is deleted but I haven't gotted aroud to using it
    use { 'ms-jpq/coq_nvim', branch = 'coq'} --              <- Code completion and code snippets, makes life just a little better when coding 
    use { 'ms-jpq/coq.artifacts', branch = 'artifacts' } --  <- The snippets that COQ uses 
    use { 'ms-jpq/coq.thirdparty', branch = '3p'} --         <- Third party snippets for COQ
	use { 'rust-lang/rust.vim', } --                         <- Rust integration and enhancements for Vim, I should use this more 
	use { 'folke/which-key.nvim', } --                       <- Like the same plugin for emacs, but in vim. Pretty useful if I do say so myself. 
	use { 'tpope/vim-surround', } --                         <- Makes it easier to change "this" to 'this'
	use { 'vimwiki/vimwiki', } --                            <- practically the emacs org mode equivalent to vim, but not as good as I have heard. I should use this more.  
    use { 'nvim-lua/plenary.nvim', } --                      <- Lua library for a few lua plugins. used by Telescope and Diffview. 
	use { 'nvim-telescope/telescope.nvim', } --              <- This can do alot, its just good as a method to find something, doesn't matter what, it just has to be now.
    use { 'nvim-telescope/telescope-file-browser.nvim',} --  <- a file manager extention for telescope as if it didn't do enough.
    use { 'TimUntersberger/neogit', -- 						 <- magit but in emacs, can you notice the pattern here, I hate emacs but love its plugins
           requires = 'nvim-lua/plenary.nvim', --			 <- dependency for a few lua plugins
		   			  'sindrets/diffview.nvim' } --          <- for better viewing of git diffs 
	use { 'nvim-neorg/neorg', 
			tag = '0.0.12',
			requires = 'nvim-lua/plenary.nvim',
			}
			 -- run = ":Neorg sync-parsers",}
    use { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate', } --                          <- EVEN MORE SYNTAX HIGHLIGHTING
    use { 'tpope/vim-commentary'} --                         <- THis just tells that I am too lazy to comment something out the old fashion way
	use { 'lewis6991/impatient.nvim' }--         		     <- Wake up Mr. :"Torvalds, We have a city to Code    } --                        
	use { 'dstein64/vim-startuptime' } --					 <- See what slowed NeoVim down
	use { 'akinsho/toggleterm.nvim', 
			tag = '*'}
	use { 'ghassan0/telescope-glyph.nvim' } --				 <- this is so cool
-- diable redundant or unnecessary builtin plugins`
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

end)
require('impatient')
--}}}

-- Vim options + global varibles (lua){{{ 

opt.wrap = true --     	      <- 
opt.foldmethod = "marker" --
opt.tabstop = 4
opt.shiftwidth = 4 -- tabs are 4 spaces, no more, no less damnit 
opt.expandtab = true
opt.ignorecase = true
opt.incsearch = true
opt.history = 200
opt.foldcolumn = "auto:1" -- indicates where the fold beginns and ends
opt.showmatch = true
opt.mat = 2
opt.ruler = true
opt.swapfile = false -- dealing with vim caring about swap files gets old fast 
opt.backup = false 	 -- last time I checked I still use git 
opt.autoindent = true
opt.smartindent = true
opt.wrap = true
opt.splitbelow = true
opt.cursorline = true
opt.expandtab = false
opt.mouse = 'a'
opt.number = true
opt.compatible = false 



-- local colorscheme = "gruvbox"
--vim.opt.leader = 
--vim.opt.cursorcolumn = true
g.vimwiki_hl_headers = 1
g.vimwiki_hl_cb_checked = 1
g.vimwiki_autowriteall = 1
g.loaded_perl_provider = 0 -- I don't program in perl
g.loaded_python3_provider = 0 -- I hate python 
g.NERDTreeShowHidden = 1 
g.gruvbox_transparent_bg = 1
g.gruvbox_termcolors = 16
g.gruvbox_bold = 1
g.gruvbox_italic = 1
--vim.g.gruvbox_contrast_dark = "soft"
g.airline_powerline_fonts = 1
-- g.coq_settings = {
    -- auto_start = "shut-up"
-- }
--}}}

-- Auto Command and eye candy config (vimscript){{{
-- had to put the before the autocmd to configure gruvbox
-- gruvbox 
vim.cmd('autocmd VimEnter * ++nested colorscheme gruvbox')
--  sTART nerdtREE AND PUT THE CURSOR BACK IN THE OTHER WINDOW.
--  Nerd Tree 
vim.cmd("autocmd VimEnter * NERDTree | wincmd p")
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
-- This is so gross, the purpose is to get a terminal on the bottom, like an
-- ide, the amount of jank is just comical. For the record I am not versed in 
-- the ways of vim script nor lua so I just threw this together after a 
-- large amount of making shit up as I go plus large amounts of trial and error
-- vim.cmd('autocmd VimEnter * ++nested split term://fish | resize 20 | wincmd p')a

-- this is arguably even worse but for some reason this makes me feel better due to being able to toggle the terminal now
-- that was much needed
-- vim.cmd('autocmd VimEnter * :Startify')
vim.cmd('autocmd VimEnter * :ToggleTerm')
vim.cmd('autocmd VimEnter * :wincmd p')
vim.cmd('autocmd VimEnter * :NERDTree | wincmd p')

 -- Exit Vim if NERDTree is the only window left.
vim.cmd([[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
                         \ quit | endif]])
--}}}

-- Change/Add mappings (lua){{{
-- This isn't just the vanilla nvim api, look at the macros and functions fold
-- to see how this was done, if anyone is looking over this config, I hope you
-- can make sense of it.

map("n",    "<Space>",      		"<leader>",                     		{noremap = false})
map("n",    "<leader>t",    		":Telescope<CR>",               		{noremap = true})
map("n",    "<leader>f",    		":Telescope file_browser<CR>",  		{noremap = true})
map("n",    "<leader>b", 			":Telescope keymaps<CR>",				{noremap = true})
map("n",    "<leader>c",    		":Telescope commands",					{noremap = true})
map("n", 	"<leader>g", 			":Telescope glyph<CR>",         		{noremap = true})
map("n",    "<C-n>",        		":NERDTree<CR>",                		{noremap = true})
map("n",    "<leader>nt",   		":NERDTreeFocus<CR>",           		{noremap = true})
map("n",    "<C-t>",        		":NERDTreeToggle<CR>",          		{noremap = true})
map("n",    "<C-f>",        		":NERDTreeFind<CR>",            		{noremap = true})
map("n",    "<C-w>N",       		":tabNext<CR>",                 		{noremap = true})
map("n",    "<C-w>P",       		":tabprevious<CR>",             		{noremap = true})
map("n",    "ZA",           		":qa!<CR>",                     		{noremap = true})
map("n",    "<leader>s",    		":w<CR>",								{noremap = true})
map("t",    "<Esc>",        		"<C-\\><C-n><C-w><C-p>",        		{noremap = true})
map("n", 	"<leader>i",			":tab h ",   							{noremap = true})
map("n",	"<leader>m", 			":tab h<CR>",							{noremap = true})
map("n",    "<leader>e",    		":source ~/.config/nvim/init.lua<CR>",	{noremap = true})
map("n", 	"<leader>ng", 			":Neogit<CR>",						 	{noremap = true})
map("n", 	"<leader>H", 			":Startify<CR>",						{noremap = true})

--}}}

-- Startify Settings (lua){{{

-- For a while now the configuration for startify has been written in vimscript,
-- it has be rewritten in lua as of 09/25/2022. My excuse was that lists are
-- weird in vimscript and I am not all that familial with either of the 
-- languages even though I have been editing both for a good week.
--
g.startify_files_number = 4 -- three is good enough, I am not editing that much
g.startify_fortune_use_unicode = 1 -- unicode is nice
g.webdevicons_enable_startify = 1 -- not sure if this will work
g.startify_session_dir = '/home/jy/.config/nvim/sessions' -- I haven't ever used this in my almost year of using this plugin

g.startify_lists = {
	{type = 'commands',  header = {'   Commands'} },
	{type = 'bookmarks', header = {'   Bookmarks'} },
	{type = 'files',     header = {'   Recently Opened'} },
	{type = 'sessions',  header = {'   Sessions'} }
} -- the order in which the lists are places in the start page 

g.startify_bookmarks = {
'~/.config/nvim/init.lua',
'~/.config/fish/config.fish',
'~/2400/projects',
'~/projects'
} -- I configure my shell and init.lua quit often
g.startify_commands = {
--	{'File browser',       'Telescope file_browser'},
	{'Find A File',        'Telescope find_files find_command=rg,--hidden,--files'},
	{'Find A keybind',     'Telescope keymaps'},
	{'Find A Command',     'Telescope commands'},
	{'Open VimWiki Index', 'VimwikiIndex'},
	{'Make journal Note',  'VimwikiMakeDiaryNote'},
	{'Vim Manual',     	   'h | wincmd T'}
--	{'Find word',          'Telescope live_grep'}
} -- these make good work in a pinch

g.startify_custom_header = {
'                                            ▄▄                  ',  
'▀███▄   ▀███▀                ▀████▀   ▀███▀ ██                  ', 
'  ███▄    █                    ▀██     ▄█                       ', 
'  █ ███   █   ▄▄█▀██  ▄██▀██▄   ██▄   ▄█  ▀███ ▀████████▄█████▄ ', 
'  █  ▀██▄ █  ▄█▀   ████▀   ▀██   ██▄  █▀    ██   ██    ██    ██ ',  
'  █   ▀██▄▓  ▓█▀▀▀▀▀▀██     ██   ▀▓█ ▓▀     ▓█   ▓█    ██    ██ ',  
'  ▓     ▓█▓  ▓█▄    ▄██     ▓█    ▓██▄      ▓█   ▓█    ▓█    ██ ',  
'  ▓   ▀▓▓▓▓  ▓▓▀▀▀▀▀▀▓█     ▓▓    ▓▓ ▓▀     ▓▓   ▓▓    ▓▓    ▓▓ ',  
'  ▓     ▓▓▓  ▒▓▓     ▓▓▓   ▓▓▓    ▓▓▒▒      ▓▓   ▒▓    ▒▓    ▓▓ ',  
'▒ ▒ ▒    ▒▓▓  ▒ ▒ ▒▒  ▒ ▒ ▒ ▒      ▒      ▒ ▒ ▒▒ ▒▓▒  ▒▒▒   ▒▒▓▒', 
}
--}}}    

-- Which-key.nvim configuration (lua){{{
  require("which-key").setup {
        plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 40, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = "Comments" },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
      },
      window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
      },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by deafult for Telescope
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
 }


--}}}

-- Nvim-TreeSitter Config (lua){{{
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "fish", "make", "latex", "org"},

  -- ensure_installed = { "c", "cpp", "lua", "rust", "fish", "bash", "html", "make", "css", "latex", "vim", },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missi	ng parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--}}}

--Telescope config (lua){{{
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require('telescope').setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker 
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    find_files = {
    hiddent = true,
        }
  },
  extensions = {
	glyph = {
   	   action = function(glyph)
   	     -- argument glyph is a table.
   	     -- {name="", value="", category="", description=""}

   	     vim.fn.setreg("*", glyph.value)
   	     print([[Press p or "*p to paste this glyph]] .. glyph.value)

   	     -- insert glyph when picked
   	     -- vim.api.nvim_put({ glyph.value }, 'c', false, true)
      end,
    },
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      hidden = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after set
-- up function:
require("telescope").load_extension "file_browser"
-- gotta load the extension for a glyph browser for when I get that a(r)||(u)tistic inspiration to make ascii art
require('telescope').load_extension('glyph')
-- }}}

-- NeoGit Config (lua){{{

neogit.setup {
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = false,
  -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size. 
  -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
  auto_refresh = true,
  disable_builtin_notifications = false,
  use_magit_keybindings = false,
  -- Change the default way of opening neogit
  kind = "tab",
  -- Change the default way of opening the commit popup
  commit_popup = {
    kind = "split",
  },
  -- Change the default way of opening popups
  popup = {
    kind = "split",
  },
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
    -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
    --
    -- Requires you to have `sindrets/diffview.nvim` installed.
    -- use { 
    --   'TimUntersberger/neogit', 
    --   requires = { 
    --     'nvim-lua/plenary.nvim',
    --     'sindrets/diffview.nvim' 
    --   }
    -- }
    --
    diffview = true 
  },
  -- Setting any section to `false` will make the section not render at all
  sections = {
    untracked = {
      folded = false
    },
    unstaged = {
      folded = false
    },
    staged = {
      folded = false
    },
    stashes = {
      folded = true
    },
    unpulled = {
      folded = true
    },
    unmerged = {
      folded = false
    },
    recent = {
      folded = true
    },
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      -- Adds a mapping with "B" as key that does the "BranchPopup" command
      ["B"] = "BranchPopup",
      -- Removes the default mapping of "s"
      ["s"] = "",
    }
  }
}

--}}}

-- Diffview config (lua){{{

require("diffview").setup({
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" },      -- The git executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  watch_index = true,       -- Update views and index buffers when the git index changes.
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts: 
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see ':h diffview-config-view.x.layout'.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
    },
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
      win_opts = {}
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      single_file = {
        diff_merges = "combined",
      },
      multi_file = {
        diff_merges = "first-parent",
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
      win_opts = {}
    },
  },
  commit_log_panel = {
    win_config = {   -- See ':h diffview-config-win_config'
      win_opts = {},
    }
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      ["<tab>"]      = actions.select_next_entry,         -- Open the diff for the next file
      ["<s-tab>"]    = actions.select_prev_entry,         -- Open the diff for the previous file
      ["gf"]         = actions.goto_file,                 -- Open the file in a new split in the previous tabpage
      ["<C-w><C-f>"] = actions.goto_file_split,           -- Open the file in a new split
      ["<C-w>gf"]    = actions.goto_file_tab,             -- Open the file in a new tabpage
      ["<leader>e"]  = actions.focus_files,               -- Bring focus to the file panel
      ["<leader>b"]  = actions.toggle_files,              -- Toggle the file panel.
      ["g<C-x>"]     = actions.cycle_layout,              -- Cycle through available layouts.
      ["[x"]         = actions.prev_conflict,             -- In the merge_tool: jump to the previous conflict
      ["]x"]         = actions.next_conflict,             -- In the merge_tool: jump to the next conflict
      ["<leader>co"] = actions.conflict_choose("ours"),   -- Choose the OURS version of a conflict
      ["<leader>ct"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
      ["<leader>cb"] = actions.conflict_choose("base"),   -- Choose the BASE version of a conflict
      ["<leader>ca"] = actions.conflict_choose("all"),    -- Choose all the versions of a conflict
      ["dx"]         = actions.conflict_choose("none"),   -- Delete the conflict region
    },
    diff1 = { --[[ Mappings in single window diff layouts ]] },
    diff2 = { --[[ Mappings in 2-way diff layouts ]] },
    diff3 = {
      -- Mappings in 3-way diff layouts
      { { "n", "x" }, "2do", actions.diffget("ours") },   -- Obtain the diff hunk from the OURS version of the file
      { { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      { { "n", "x" }, "1do", actions.diffget("base") },   -- Obtain the diff hunk from the BASE version of the file
      { { "n", "x" }, "2do", actions.diffget("ours") },   -- Obtain the diff hunk from the OURS version of the file
      { { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
    },
    file_panel = {
      ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
      ["S"]             = actions.stage_all,          -- Stage all entries.
      ["U"]             = actions.unstage_all,        -- Unstage all entries.
      ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
      ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
      ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
      ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
      ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
      ["R"]             = actions.refresh_files,        -- Update stats and entries in the file list.
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
      ["g<C-x>"]        = actions.cycle_layout,
      ["[x"]            = actions.prev_conflict,
      ["]x"]            = actions.next_conflict,
    },
    file_history_panel = {
      ["g!"]            = actions.options,          -- Open the option panel
      ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
      ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
      ["L"]             = actions.open_commit_log,
      ["zR"]            = actions.open_all_folds,
      ["zM"]            = actions.close_all_folds,
      ["j"]             = actions.next_entry,
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["<c-b>"]         = actions.scroll_view(-0.25),
      ["<c-f>"]         = actions.scroll_view(0.25),
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
      ["g<C-x>"]        = actions.cycle_layout,
    },
    option_panel = {
      ["<tab>"] = actions.select_entry,
      ["q"]     = actions.close,
    },
  },
})
--}}}

-- Toggle Term config(lua){{{
 require("toggleterm").setup {
	 size = 18,
  -- size can be a number or function which is passed the current terminal
  -- size = 20 | function(term)
  --   if term.direction == "horizontal" then
  --     return 15
  --   elseif term.direction == "vertical" then
  --     return vim.o.columns * 0.4
  --   end
  -- end,
  open_mapping = [[<leader>y]],
  -- on_open = fun(t: Terminal), -- function to run when the terminal opens
  -- on_close = fun(t: Terminal), -- function to run when the terminal closes
  -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
  -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
  -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
 --  highlights = {
 --    -- highlights which map to a highlight group name and a table of it's values
 --    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
 --    Normal = {
 --      guibg = "<VALUE-HERE>",
 --    },
 --    NormalFloat = {
 --      link = 'Normal'
 --    },
 --    FloatBorder = {
 --      guifg = "<VALUE-HERE>",
 --      guibg = "<VALUE-HERE>",
 --    },
 --  },
  shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
 --  shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = false,
 --  insert_mappings = true, -- whether or not the open mapping applies in insert mode
 --  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
 --  persist_size = true,
 --  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = 'horizontal',
  --^'vertical' | 'horizontal' | 'tab' | 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  auto_scroll = false , -- automatically scroll to the bottom on terminal output
 --  -- This field is only relevant if direction is set to 'float'
  float_opts = {
 --    -- The border key is *almost* the same as 'nvim_open_win'
 --    -- see :h nvim_open_win for details on borders however
 --    -- the 'curved' border is a custom border type
 --    -- not natively supported but implemented in this plugin.
    border = 'single', -- | 'double' | 'shadow' | 'curved' | ... other options supported by win open
 --    -- like `size`, width and height can be a number or function which is passed the current terminal
 --    width = <value>,
    height = 25 
 --    winblend = 3,
  },
 --  winbar = {
 --    enabled = false,
 --    name_formatter = function(term) --  term: Terminal
 --      return term.name
 --    end
  -- },
 }

	-- }}}

-- Neorg Config(FUCK NEORG's DEVELOPERS)(lua){{{
-- this took a abhorrent amount of time to just to get to even get working.
-- The first time it even started I fell out of my chair in shock that it even worked 
-- You see the devs and the users either don't use treesitter or use nightly builds of nvim 
-- (tldr; they are fucking psychos). In addition they also just don't care about stability 
-- and reproducability accross different configs. Thats fine by me but atleast make it obvious
-- that It will have issues if in is not pegged to version 0.0.12( which is 3 tags beghind btw)
-- So out of just spite and rage I refused to give up like the ass I am. A note on the nightly builds
-- WHY, that just seems hell. at that point I would litteraly just clone the git repo for neovim and
-- just recompile it every night using the perscribed build options that are normaly used for arch
-- packages
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    home = "~/notes/home",
                }
            }
        }
    }
}
-- }}}
