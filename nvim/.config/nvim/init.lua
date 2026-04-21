-- Editor Settings
vim.g.mapleader = " "
vim.o.guicursor = "i:ver1"
vim.o.background = 'dark'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.hlsearch = false
vim.opt.cursorline = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamed'
vim.opt.laststatus = 2
vim.opt.swapfile = false
vim.opt.pumheight = 10

vim.diagnostic.config({
  virtual_text = { severity = vim.diagnostic.severity.ERROR },
  float = {
      source = true,
  }
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- Git
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    },
  },

  -- Multicursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set
      set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
      set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
      set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)
      set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
      set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
      set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
      set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)
      set({"n", "x"}, "<c-q>", mc.toggleCursor)
      mc.addKeymapLayer(function(layerSet)
        layerSet({"n", "x"}, "<left>", mc.prevCursor)
        layerSet({"n", "x"}, "<right>", mc.nextCursor)
        layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  -- LSP Signature
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "LspAttach",
  --   opts = {
  --     handler_opts = { border = "rounded" },
  --     hi_parameter = "LspSignatureActiveParameter",
  --     toggle_key = '<C-x>',
  --     doc_lines = 0,
  --     floating_window = true,
  --   },
  -- },

  -- Colorschemes
  { "bavajitu/brellary.nvim" },
  { 'alligator/accent.vim' },
  { "loctvl842/monokai-pro.nvim" },
  { 'aditya-azad/candle-grey' },
  { 'ntk148v/komau.vim' },
  { "zekzekus/menguless" },
  { "xiantang/darcula-dark.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "ramojus/mellifluous.nvim" },
  { "metalelf0/jellybeans-nvim", dependencies = { "rktjmp/lush.nvim" } },
  {
    "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.g.zenbones = { darkness = 'warm', colorize_diagnostic_underline_text = true }
    end,
  },
  { "dzfrias/noir.nvim" },
  { "lifepillar/vim-gruvbox8" },
  { "mhartington/oceanic-next" },
  { "EdenEast/nightfox.nvim" },
  { "alexpasmantier/hubbamax.nvim" },
  { "wincent/base16-nvim" },
  { "folke/tokyonight.nvim" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      dark_variant = 'main',
      disable_background = true,
      styles = {
        comments = 'italic',
        keywords = 'bold',
        functions = 'italic',
        variables = 'none',
        transparency = true,
      },
    },
  },
  {
    "morhetz/gruvbox",
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_bold = 0
      vim.g.gruvbox_italicize_comments = 1
      vim.g.gruvbox_italicize_strings = 1
      vim.g.gruvbox_invert_selection = 0
      vim.g.gruvbox_contrast_dark = "hard"
      vim.g.gruvbox_material_background = 'hard'
      vim.cmd("colorscheme gruvbox-material")
      vim.g.gruvbox_material_background = 'hard'
      local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
      vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
      vim.api.nvim_set_hl(0, "@variable.builtin", { link = "@variable" })
    end,
  },
  { "sainnhe/gruvbox-material" },
  { "olivercederborg/poimandres.nvim" },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      background = { dark = "dragon", light = "lotus" },
    },
  },
  { "Th3Whit3Wolf/one-nvim" },
  { "RomanAverin/charleston.nvim" },
  { "darianmorat/gruvdark.nvim" },
  {
    "metalelf0/black-metal-theme-neovim",
    config = function()
      require("black-metal").setup({
        theme = "emperor",
        alt_bg = true,
        colored_docstrings = true,
        diagnostics = { darker = true, undercurl = true, background = true },
        code_style = {
          comments = "italic",
          functions = "italic",
          headings = "bold",
        },
      })
    end,
  },
  { "nyoom-engineering/oxocarbon.nvim" },

  -- Utilities
  { "folke/snacks.nvim" },
  {
      "Sang-it/fluoride",
      config = function()
        require("fluoride").setup()
      end,
  },
  -- Syntax / Filetypes
  { "lepture/vim-jinja" },
  { "Glench/Vim-Jinja2-Syntax" },
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_quickfix_ignore_filters = { 'Overfull', 'Underfull' }
      vim.g.vimtex_compiler_latexmk = {
          aux_dir = 'build',
          options  = {
           '-verbose',
           '-file-line-error',
           '-synctex=0',
           '-interaction=nonstopmode',
        },
    }
    end,
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 1000,
    opts = {
      ensure_installed = {
        "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
        "c", "cpp", "rust", "html", "latex", "javascript",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<leader>ss",
            node_incremental = "<leader>si",
            scope_incremental = "<leader>sc",
            node_decremental = "<leader>sd",
        },
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
          },
          include_surrounding_whitespace = false,
        },
      }
    end,
  },

  -- File explorer
  { "preservim/nerdtree", cmd = "NERDTreeToggle" },
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = false,
        sort = { { "type", "asc" } },
      },
    },
  },

  -- Editing
  { "jiangmiao/auto-pairs" },
  { "tpope/vim-surround" },
  { "shortcuts/no-neck-pain.nvim", cmd = "NoNeckPain" },
  {
      "nvim-mini/mini.splitjoin",
      config = function()
          require("mini.splitjoin").setup()
      end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require('mason').setup({})

      vim.lsp.config('basedpyright', {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              useLibraryCodeForTypes = true,
              inlayHints = {
                callArgumentNames = true,
                functionReturnTypes = true,
                genericTypes = true,
                variableTypes = true,
              },
            },
          },
        },
      })
      vim.lsp.config('vtsls', {
          filetypes = { "ts" },
      })
      vim.lsp.config('clangd', {
        cmd = { "clangd", "--offset-encoding=utf-16" },
      })
      vim.lsp.config('lua_ls', {
          filetypes = { "lua" },
      })
      vim.lsp.config('ruff', {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
        filetypes = { "python" }
      })
      vim.lsp.config('ty', {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
        filetypes = { "python" }
      })
      vim.lsp.config('html', { filetypes = { "html" } })
      vim.lsp.config('rust_analyzer', {
        init_options = {
          rustfmt = {
            rangeFormatting = { enable = true },
          },
        },
        settings = {
          ['rust-analyzer'] = {
            rustfmt = {
              rangeFormatting = { enable = true },
            },
          },
        },
      })
    end,
  },
  -- Debugging
  { "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local ui = require "dapui"
      require("dapui").setup()

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}},
  {
      "mfussenegger/nvim-dap-python",
      config = function()
          require("dap-python").setup("/Users/omerjunedi/.virtualenvs/debugpy/bin/python")
      end,
  },
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      local types = require('cmp.types')
      cmp.setup({
        sources = { { name = 'nvim_lsp' } },
        sorting = {
          comparators = {
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            function(entry1, entry2)
              local kind1 = entry1:get_kind()
              local kind2 = entry2:get_kind()
              local member = types.lsp.CompletionItemKind.EnumMember
              if kind1 == member and kind2 ~= member then return true end
              if kind1 ~= member and kind2 == member then return false end
              return nil
            end,
            compare.kind,
            compare.offset,
            compare.length,
            compare.order,
          },
        },
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
          ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
          ['<C-k>'] = cmp.mapping(function()
            if cmp.visible() then cmp.select_prev_item({ behavior = 'insert' })
            else cmp.complete() end
          end),
          ['<C-j>'] = cmp.mapping(function()
            if cmp.visible() then cmp.select_next_item({ behavior = 'insert' })
            else cmp.complete() end
          end),
        },
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        window = {
          documentation = { border = "rounded", winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None" },
          completion = { border = "rounded", winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None" },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
      { "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
    },
    opts = {
      pickers = {
        buffers = { mappings = { i = { ["<c-d>"] = "delete_buffer" } } },
      },
    },
  },

  -- FZF
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local function my_location()
        return string.format("%d/%d | %d", vim.fn.line('.'), vim.fn.line('$'), vim.fn.col('.'))
      end
      require('lualine').setup({
        options = {
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', file_status = true, path = 1 } },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { my_location },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  -- Misc
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "MeanderingProgrammer/render-markdown.nvim", ft = "markdown" },
})

vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover({ border = "single" })
end)

-- DAP keymaps
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = "Start/continue debugging" })
vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = "Step over" })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = "Step into" })
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = "Open REPL" })
vim.keymap.set('n', '<leader>dt', function() require('dap-python').test_method() end, { desc = "Debug test method" })

-- LSP navigation
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set({'n', 'i'}, '<C-x>', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })

-- Keymaps
vim.keymap.set('n', "<leader>gn", vim.diagnostic.goto_next)
vim.keymap.set('n', "<leader>gp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>bg", function()
  if vim.o.background == "dark" then vim.o.background = "light"
  else vim.o.background = "dark" end
end, { desc = "Toggle background light/dark" })
vim.keymap.set('n', '<leader>O', '<cmd>Oil<CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<leader><leader>', '<cmd>b#<CR>')
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>')
vim.keymap.set('n', '<leader>so', '<cmd>so ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set('n', "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set('n', "dv", '"_dd')
vim.keymap.set('i', "<C-c>", "<Esc>")
vim.keymap.set("n", "ycc", "yygccp", { remap = true })
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Actions" })

vim.keymap.set({ "x", "o" }, "af", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)

vim.keymap.set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}), {})
end, { desc = "Toggle inlay hints" })
vim.keymap.set({ "x", "o" }, "il", function() vim.cmd("normal! ^vg_") end, { desc = "inner line" })
vim.keymap.set({ "x", "o" }, "al", function() vim.cmd("normal! 0v$h") end, { desc = "a line" })

vim.keymap.set('n', '<leader>ft',
  function() vim.lsp.buf.format() end,
  { desc = '[lsp] format buffer' })
vim.keymap.set('v', '<leader>ft',
  function() vim.lsp.buf.format() end,
  { desc = '[lsp] format selection' })

-- Colorscheme
vim.cmd("hi StatusLine guibg=NONE")
vim.cmd("hi link TreesitterContext Normal")
vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
vim.g.seoulbones = { darkness = 'stark', solid_line_nr = true, darken_comments = 45 }
vim.g.zenwritten = { darkness = 'warm', solid_line_nr = true, darken_comments = 45 }
vim.g.gruvbox_material_background = 'dark'

-- Cursor shape for tmux
if vim.env.TMUX then
  vim.cmd([[
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
  ]])
else
  vim.cmd([[
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
  ]])
end

-- LSP
vim.lsp.enable({ 'ruff', 'clangd', 'html', 'rust_analyzer' , 'ty', 'basedpyright', 'texlab', 'lua_ls', 'vtsls'})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client then
--             client.server_capabilities.semanticTokensProvider = nil
--         end
--     end,
-- })

-- vim.api.nvim_create_autocmd('FileType', {
--     callback = function()
--         pcall(vim.treesitter.start)
--         vim.api.nvim_set_hl(0, "@variable", { fg = "#ebdbb2" })
--         vim.api.nvim_set_hl(0, "Identifier", { fg = "#ebdbb2" })
--     end,
-- })

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.diagnostic.config({ virtual_text = false })
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.diagnostic.config({ virtual_text = true })
    end,
})
