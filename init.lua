-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'
    use 'aca/marp.nvim'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }

    use 'natecraddock/workspaces.nvim'
    use 'natecraddock/sessions.nvim'

    -- todo list
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                keywords = {
                    TODO = {
                        alt = { "todo:", " todo ", " TODO " }
                    },
                    NOTE = {
                        alt = { "note:" }
                    }
                }
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
      'j-hui/fidget.nvim',
      tag = 'legacy',
      config = function()
        require("fidget").setup {
          -- options
          text = {
            spinner = "dots",
          }
        }
      end,
    }

    use { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Additional lua configuration, makes nvim stuff amazing
            'folke/neodev.nvim',
        },
    }

    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = { 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip','L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' }
    }

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    -- tabs
    use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}

    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'lewis6991/gitsigns.nvim'

    -- tmux navigation
    use 'christoomey/vim-tmux-navigator'

    use 'navarasu/onedark.nvim' -- Theme inspired by Atom
    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
    use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
    use { 'eliseshaffer/darklight.nvim' } -- darkmode switcher

    -- cmake / c++ development
    use 'cdelledonne/vim-cmake'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

    -- java development
    use { "mfussenegger/nvim-jdtls", ft = { "java" } }

    -- javascript development
    use "maxmellon/vim-jsx-pretty"
    use "yuezk/vim-js"

    -- Fuzzy Finder (files, lsp, etc)
    use 'BurntSushi/ripgrep'
    use 'sharkdp/fd'
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- devcontainer support
    use { "https://codeberg.org/esensar/nvim-dev-container" }
    use { 'tell-k/vim-autopep8' }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
    local has_plugins, plugins = pcall(require, 'custom.plugins')
    if has_plugins then
        plugins(use)
    end

    if is_bootstrap then
        require('packer').sync()
    end
end)

require('darklight').setup({
  mode = 'colorscheme', -- Sets darklight to colorscheme mode
  light_mode_colorscheme = 'onedark', -- Sets the colorscheme to use for light mode
  dark_mode_colorscheme = 'onedark', -- Sets the colorscheme to use for dark mode
})
-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`
vim.cmd("set clipboard+=unnamedplus")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
-- vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.nu = true

-- Enable mouse mode
vim.o.mouse = 'a'


-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '½', '$')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Set dap configuration
local dap = require('dap')
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    }
}
dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = "${port}",
    executable = {
        command = vim.fn.getenv('HOME') .. '/.local/share/nvim/dap/codelldb/extension/adapter/codelldb',
        args = {"--port", "${port}"},
        -- On windows you may have to uncomment this:
        -- detached = false,
    }
}
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.getenv('HOME') .. '/.local/share/nvim/dap/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
}
dap.defaults.fallback.exception_breakpoints = {}
-- Map K to hover while debug session is active
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
        end
    end
    vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
end
dap.listeners.after['event_terminated']['me'] = function()
    for _, km in pairs(keymap_restore) do
        vim.api.nvim_buf_set_keymap(
            km.buffer, km.mode, km.lhs, km.rhs, { silent = vim.keymap.silent == 1 }
        )
    end
    keymap_restore = {}
end

require('sessions').setup()
require('workspaces').setup()

-- setup devcontainer plugin
require("devcontainer").setup{
  log_level = 'trace'
}

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
    },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
    show_current_context = true,
    show_current_context_start = true,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    extensions = {
        workspaces = {
            keep_insert = true,
        }
    },
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- todo list keybinds
vim.keymap.set('n', '<leader>st', function ()
    vim.cmd(':TodoTelescope keywords=TODO,FIX')
end, { desc = '[S]earch [T]odos' })
vim.keymap.set('n', '<leader>sT', function ()
    vim.cmd(':TodoTelescope')
end, { desc = '[S]earch all [T]odos' })

vim.keymap.set('n', '<leader>p', require('nvim-tree.api').tree.find_file, { desc = 'open the current buffer file in nvim tree' })

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sF', function()
    require('telescope.builtin').find_files({ no_ignore = true }) end, { desc = '[S]earch All Files' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', function()
    require('telescope.builtin').live_grep({ additional_args = { '--no-ignore' } })
end, { desc = '[S]earch all by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- cmake things
vim.keymap.set('n', '<leader>cc', function()
    vim.cmd('CMakeGenerate')
end, { desc = '[C]Make project [C]onfigure' })
vim.keymap.set('n', '<leader>cb', function()
    vim.cmd('CMakeBuild')
end, { desc = '[C]Make project [B]uild' })
vim.keymap.set('n', '<leader>cC', function()
    vim.cmd('CMakeClean')
end, { desc = '[C]Make project [C]lean' })
vim.keymap.set('n', '<leader>cv', function()
    vim.cmd('CMakeClose')
end, { desc = '[C]Make project close' })

vim.keymap.set('n', '<leader>wm', function ()
    vim.cmd(':w')
    vim.cmd(':make')
end, { desc = '[W]rite buffer and [M]ake' })

-- Ctrl+c should be just the same as pressing escape!
vim.cmd('imap <C-c> <Esc>')

-- sessions keybinds
vim.keymap.set('n', '<leader>Ss', function()
    require('sessions').save('.nvim/session', { silent = true })
end, { desc = '[S]ession [s]ave' })
vim.keymap.set('n', '<leader>Sl', function()
    require('sessions').load('.nvim/session', { silent = true })
end, { desc = '[S]ession [l]oad' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'jsonc', 'vimdoc', 'vim' },
    highlight = { enable = true },
    -- disable treesitter indentation for languages where it sucks at indenting for me.
    indent = { enable = true, disable = { 'python', 'cpp' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    if client.supports_method('textDocument/documentHighlight') then
        vim.api.nvim_create_autocmd({ "CursorHold" }, { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
        vim.api.nvim_create_autocmd({ "CursorHoldI" }, { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, { buffer = bufnr, callback = vim.lsp.buf.clear_references })
    end

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gh',function()
        vim.cmd(':ClangdSwitchSourceHeader')
    end, '[G]oto [H]eader')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    jdtls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
    ["jdtls"] = function()
        require('lspconfig').jdtls.setup {
            -- Apply the default capabilities and on_attach stuff
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers["jdtls"],
            -- This is a legacy feature, where jdtls used their own progress report format. Disable it to use $/progress.
            init_options = {
                extendedClientCapabilities = {
                    progressReportProvider = false,
                },
            },
            -- TODO: This is the stupidest shim ever. But for some reason it fixes everything
            handlers = {
                ["$/progress"] = function(id,msg,info)
                  vim.lsp.handlers["$/progress"](id,msg,info)
                end,
            }
        }
    end,
}

vim.cmd('let g:cmake_link_compile_commands = 1')

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

require('luasnip/loaders/from_vscode').load()

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- nvim-dap configurations
require("dapui").setup()

vim.api.nvim_set_hl(0, "blue",   { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green",  { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "red",    { fg = "#ff3333" })
vim.api.nvim_set_hl(0, "veryred",{ fg = "#ff0000" })
vim.fn.sign_define('DapBreakpoint',          {text='',texthl='red',linehl='',numhl='red'})
vim.fn.sign_define('DapBreakpointCondition', {text='',texthl='orange',linehl='',numhl=''})
vim.fn.sign_define('DapLogPoint',            {text='',texthl='blue',linehl='',numhl=''})
vim.fn.sign_define('DapStopped',             {text='',texthl='green',linehl='',numhl='green'})
vim.fn.sign_define('DapBreakpointRejected',  {text='',texthl='red',linehl='veryred',numhl=''})
-- dap keymaps
local continue = function()
    if vim.fn.filereadable('.vscode/launch.json') then
        require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp' }, codelldb = { 'c', 'cpp' }})
    end
    require('dap').continue()
end
vim.keymap.set('n', '<F2>', require('dapui').open)
vim.keymap.set('n', '<F3>', require('dapui').close)
vim.keymap.set('n', '<F4>', require('dap').close)
vim.keymap.set('n', '<F5>', continue)
vim.keymap.set('n', '<F6>', require('dap').step_over)
vim.keymap.set('n', '<F7>', require('dap').step_into)
vim.keymap.set('n', '<F8>', require('dap').step_out)
vim.keymap.set('n', '<Leader>B', function()
    local condition = vim.fn.input('Set breakpoint condition: ')
    require('dap').set_breakpoint(condition, nil, nil)
end)
vim.keymap.set('n', '<Leader>b', require('dap').toggle_breakpoint)
vim.keymap.set('n', '<Leader>dr', require('dap').repl.open)
vim.keymap.set('n', '<Leader>dl', require('dap').run_last)
vim.keymap.set('n', '<Leader>df', require('dap').focus_frame)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>dj', function()
    require('dap.ext.vscode').load_launchjs(vim.fn.input('Path to json: ', vim.fn.getcwd() .. '/', 'file'), { cppdbg = { 'c', 'cpp' }, codelldb = { 'c', 'cpp' } }) 
end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', require('dap.ui.widgets').hover)
vim.keymap.set({'n', 'v'}, '<Leader>dp', require('dap.ui.widgets').preview)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)


-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        side = 'right',
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})

-- TODO: Add keybinds for nvim-tree
vim.keymap.set('n', '<leader>o', require('nvim-tree.api').tree.toggle,  { desc = '[O]pen file' })

vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cindent = true
-- vim.opt.cinoptions:append({ 'N55' })

-- set cino=>4,e4,n4,^4,:4,=4

-- Used to open nvim-tree
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = require('nvim-tree.api').tree.open })


-- barbar configuration
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<leader>hh', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>ll', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<leader><', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<leader>>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<leader>tp', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<leader>tc', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>q', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- globally available clipboard
vim.api.nvim_set_option("clipboard","unnamed")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

