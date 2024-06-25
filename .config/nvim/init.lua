-- Install lazy
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

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { "rcarriga/nvim-dap-ui", dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' } },
  { 'neovim/nvim-lspconfig', dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'folke/neodev.nvim' } },
  { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip','L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' } },
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  { 'romgrk/barbar.nvim', dependencies = { 'nvim-web-devicons' } },
  { "mfussenegger/nvim-jdtls", ft = 'java' },
  { 'j-hui/fidget.nvim', tag = 'legacy' },
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },
  -- TODO: Write my own, because this sucks
  -- { 'jackMort/ChatGPT.nvim', event = 'VeryLazy', config = function() setup_chatgpt() end, dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' } },
  'f-person/git-blame.nvim',
  'nvim-tree/nvim-web-devicons',
  'aca/marp.nvim',
  'natecraddock/workspaces.nvim',
  'natecraddock/sessions.nvim',
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',
  'kdheepak/lazygit.nvim',
  'christoomey/vim-tmux-navigator',
  'navarasu/onedark.nvim',
  'nvim-lualine/lualine.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'numToStr/Comment.nvim',
  'tpope/vim-sleuth',
  'eliseshaffer/darklight.nvim',
  'civitasv/cmake-tools.nvim',
  "maxmellon/vim-jsx-pretty",
  "yuezk/vim-js",
  'BurntSushi/ripgrep',
  'sharkdp/fd',
  "https://codeberg.org/esensar/nvim-dev-container",
  'tell-k/vim-autopep8',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
  'https://codeberg.org/esensar/nvim-dev-container',
  'mfussenegger/nvim-dap-python',
  'pixelneo/vim-python-docstring',
  'andythigpen/nvim-coverage',
  'klen/nvim-test',
  'github/copilot.vim',
  'mbbill/undotree',
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  'sillydan1/luajava.nvim',
  'sillydan1/graphedit-lua.nvim',
  'kelly-lin/ranger.nvim',
  'tamton-aquib/duck.nvim',
  'igankevich/mesonic'
})

-- [[ Setting options ]
-- See `:help vim.o`
vim.cmd('set clipboard+=unnamedplus')
-- Ctrl+c should be just the same as pressing escape!
vim.cmd('imap <C-c> <Esc>')
vim.cmd('let g:cmake_link_compile_commands = 1')
vim.cmd('set colorcolumn=120')
-- set termguicolors to enable highlight groups
vim.o.termguicolors = true
-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
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
vim.cmd [[colorscheme catppuccin]]
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.cindent = true
vim.api.nvim_set_option("clipboard","unnamed")

-- files named "Jenkinsfile" should be set to use the groovy syntax highlighter
-- Not setting filetype=groovy, because groovy-language-server is not too happy with jenkinsfiles
-- TODO: Write a better jenkinsfile language-server / linter.
vim.cmd[[
  augroup groovy_filetype
    autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
  augroup END
]]

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('todo-comments').setup({
  keywords = {
    TODO = {
      alt = { 'todo:', ' todo ', ' TODO ' }
    },
    NOTE = {
      alt = { 'note:' }
    }
  }
})

require('fidget').setup({
  text = {
    spinner = 'dots'
  }
})

local ranger_nvim = require('ranger-nvim')
ranger_nvim.setup({
  enable_cmds = false,
  replace_netrw = false,
  keybinds = {
    ["ov"] = ranger_nvim.OPEN_MODE.vsplit,
    ["oh"] = ranger_nvim.OPEN_MODE.split,
    ["ot"] = ranger_nvim.OPEN_MODE.tabedit,
    ["or"] = ranger_nvim.OPEN_MODE.rifle,
  },
  ui = {
    border = "rounded",
    height = 0.8,
    width = 0.8,
    x = 0.5,
    y = 0.5,
  }
})

require('darklight').setup({
  mode = 'colorscheme', -- Sets darklight to colorscheme mode
  light_mode_colorscheme = 'catppuccin', -- Sets the colorscheme to use for light mode
  dark_mode_colorscheme = 'catppuccin', -- Sets the colorscheme to use for dark mode
})

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

require('cmake-tools').setup({})

require('sessions').setup()
require("dapui").setup()
require('workspaces').setup()
require('nvim-test').setup({})
require('coverage').setup()
require("devcontainer").setup({
  log_level = 'trace'
})
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
})
require('Comment').setup()
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
require('telescope').setup({
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
})
pcall(require('telescope').load_extension, 'fzf')
require('nvim-treesitter.configs').setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'java', 'rust', 'typescript', 'jsonc', 'vimdoc', 'vim' },
  modules = {},
  ignore_install = {},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true
  }
})

require('neodev').setup()
require('mason').setup()
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
  nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')

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
local servers = {
  clangd = {},
  -- gopls = {},
  -- pylsp = {
  --   pylsp = {
  --     plugins = {
  --       rope_autoimport = { enabled = true }
  --     }
  --   }
  -- },
  rust_analyzer = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      }
    }
  },
  tsserver = {},
  jdtls = {},
  lua_ls = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}
require('mason-lspconfig').setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
  ["jdtls"] = function()
    require('lspconfig').jdtls.setup({
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
    })
  end,
  ["clangd"] = function()
    require('lspconfig').clangd.setup({
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', --[[ 'proto' --]] }, -- TODO: clangd's proto stuff is seriously borked, re-enable when it works again
      capabilities = {
        unpack(capabilities),
        offsetEncoding = "utf-16",
      },
      on_attach = on_attach,
      settings = servers["clangd"],
    })
  end,
})

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
---@diagnostic disable-next-line: missing-fields
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

require('luasnip/loaders/from_vscode').load()

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

local dap = require('dap')
-- NOTE: Use this in your launch.json file
--        {
--        	"name": "pytest: unit",
--        	"type": "python",
--        	"request": "launch",
--        	"program": "${workspaceFolder}/venv/bin/pytest",
--        	"cwd": "${workspaceFolder}",
--        	"args": [
--        		"${workspaceFolder}/test"
--        	]
--        },
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = os.getenv('VIRTUAL_ENV') .. '/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end
-- dap.configurations.python = {
--   {
--     name = "Run",
--     type = "python",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     pythonPath = os.getenv('VIRTUAL_ENV') .. '/bin/python',
--     cwd = "${workspaceFolder}",
--     stopOnEntry = false,
--   },
-- }
dap.configurations.c = {
  {
    name = "Launch file",
    type = (vim.fn.has('macunix') and "codelldb" or "cppdbg"),
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local a = vim.fn.input('Arguments: ')
      return { a }
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  }
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = (vim.fn.has('macunix') and "codelldb" or "cppdbg"),
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local a = vim.fn.input('Arguments: ')
      return { a }
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  }
}
-- codelldb is better on MacOS
dap.adapters.codelldb = {
  type = 'server',
  host = '127.0.0.1',
  port = "${port}",
  executable = {
    command = vim.fn.getenv('HOME') .. '/.local/share/nvim/dap/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
    -- detached = false, --  NOTE: On windows you may have to uncomment this:
  }
}
-- cppdbg is better on non-MacOS
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.getenv('HOME') .. '/.local/share/nvim/dap/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
}
dap.defaults.fallback.exception_breakpoints = {}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
vim.api.nvim_create_user_command('DuckHatch', 'lua require("duck").hatch()', {})
vim.api.nvim_create_user_command('DuckCook', 'lua require("duck").cook()', {})
-- press <C-D> to accept the completion
vim.cmd(':Copilot disable')
vim.keymap.set('i', '<C-D>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-W>', '<Plug>(copilot-suggest)')
vim.keymap.set('n', '<leader>cp', function() vim.cmd(':Copilot panel') end)
vim.keymap.set('i', '<C-Q>', '<Plug>(copilot-dismiss)')
vim.g.copilot_no_tab_map = true

-- vim.keymap.set('n', '<leader>gp', function() vim.cmd(':ChatGPT') end, { desc = 'Open Chat[GP]T' })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '½', '$')
vim.keymap.set('n', '<leader>DD', ':Docstring<CR>', { desc = 'Generate [D]ocstring' })
vim.keymap.set('n', '<leader>tt', ':DarkLightSwitch<CR>', { desc = '[T]oggle [T]heme' })
vim.keymap.set('n', '<leader>uu', ':UndotreeToggle<CR>', { desc = '[U]ndotree toggle' })
vim.keymap.set('n', '<leader>ff', function() ranger_nvim.open(true) end, { desc = 'Open [F]ile using ranger' })
vim.keymap.set('n', '<leader>bl', ':!black .<CR>', { desc = '[Bl]ack formatting' })
vim.keymap.set('n', '<leader>gb', function() vim.cmd('GitBlameToggle') end,                   { desc = '[G]it [B]lame Toggle' })
vim.keymap.set('n', '<leader>gg', function() vim.cmd('LazyGit') end,                          { desc = 'Open lazy[g]it client' })
vim.keymap.set('n', '<leader>st', function() vim.cmd(':TodoTelescope keywords=TODO,FIX') end, { desc = '[S]earch [T]odos' })
vim.keymap.set('n', '<leader>sT', function() vim.cmd(':TodoTelescope') end,                   { desc = '[S]earch all [T]odos' })
vim.keymap.set('n', '<leader>p', require('nvim-tree.api').tree.find_file,                     { desc = 'open the current buffer file in nvim tree' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,                       { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,                  { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzily search in current buffer]' })

-- Coverage shit
vim.keymap.set('n', '<leader>co', function()
  require("coverage").load_lcov("coverage.info", true)
end, { desc = '[CO]verage Toggle' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,                                                        { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', function() require('telescope.builtin').find_files({ no_ignore = true }) end,                   { desc = '[S]earch All Files' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,                                                         { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', function() require('telescope.builtin').live_grep({ additional_args = { '--no-ignore' } }) end, { desc = '[S]earch all by [G]rep' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags,                                                         { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,                                                       { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,                                                       { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>cc', function() vim.cmd('CMakeGenerate') end, { desc = '[C]Make project [C]onfigure' })
vim.keymap.set('n', '<leader>cb', function() vim.cmd('CMakeBuild') end,    { desc = '[C]Make project [B]uild' })
vim.keymap.set('n', '<leader>cC', function() vim.cmd('CMakeClean') end,    { desc = '[C]Make project [C]lean' })
vim.keymap.set('n', '<leader>mm', function() vim.cmd('MesonInit') end,     { desc = '[M]eson project configure' })
vim.keymap.set('n', '<leader>mb', function() vim.cmd('make') end,          { desc = '[M]eson project [B]uild' })
vim.keymap.set('n', '<leader>Ss', function() require('sessions').save('.nvim/session', { silent = true }) end, { desc = '[S]ession [s]ave' })
vim.keymap.set('n', '<leader>Sl', function() require('sessions').load('.nvim/session', { silent = true }) end, { desc = '[S]ession [l]oad' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,         { desc = 'Next diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,         { desc = 'Previous diagnostic' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Open diagnostics floating window' })
vim.keymap.set('n', '<leader>r', vim.diagnostic.setloclist, { desc = 'Add ' })
vim.keymap.set('n', '<C-w>h', function() vim.cmd(':sp') end, { desc = 'split horizontally' })

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
vim.keymap.set('n', '<F2>', require('dapui').open,    { desc = 'Debugger UI Open' })
vim.keymap.set('n', '<F3>', require('dapui').close,   { desc = 'Debugger UI close' })
vim.keymap.set('n', '<F4>', require('dap').close,     { desc = 'Debugger Close' })
vim.keymap.set('n', '<F5>', function()
  if vim.fn.filereadable('.vscode/launch.json') then
    require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp' }, codelldb = { 'c', 'cpp' }})
  end
  require('dap').continue()
end, { desc = 'Debugger Continue' })
vim.keymap.set('n', '<F6>', require('dap').step_over, { desc = 'Debugger Step Over' })
vim.keymap.set('n', '<F7>', require('dap').step_into, { desc = 'Debugger Step Into' })
vim.keymap.set('n', '<F8>', require('dap').step_out,  { desc = 'Debugger Step Out' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Set breakpoint condition: '), nil, nil) end, { desc = 'Debugger New breakpoint with a condition' })
vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint, { desc = 'Debugger New breakpoint' })
vim.keymap.set('n', '<leader>dr', require('dap').repl.open,   { desc = 'Debugger open REPL' })
vim.keymap.set('n', '<leader>dl', require('dap').run_last,    { desc = 'Debugger run last run executable' })
vim.keymap.set('n', '<leader>df', require('dap').focus_frame, { desc = 'Debugger focus to current stack' })
vim.keymap.set('n', '<leader>db', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = 'Debugger new logpoint' })
vim.keymap.set('n', '<leader>dj', function()
  require('dap.ext.vscode').load_launchjs(vim.fn.input('Path to json: ', vim.fn.getcwd() .. '/', 'file'), { cppdbg = { 'c', 'cpp' }, codelldb = { 'c', 'cpp' } })
end, { desc = 'Debugger Load launch specification file' })
vim.keymap.set({'n', 'v'}, '<Leader>dh', require('dap.ui.widgets').hover,   { desc = 'Debugger hover menu' })
vim.keymap.set({'n', 'v'}, '<Leader>dp', require('dap.ui.widgets').preview, { desc = 'Debugger preview menu' })
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = 'Debugger summon centered_float' })

vim.keymap.set('n', '<leader>o', require('nvim-tree.api').tree.toggle,  { desc = '[O]pen file' })

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', 'H', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('n', 'L', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<Cmd>BufferClose<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Q', '<Cmd>BufferClose!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><', '<Cmd>BufferMovePrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>>', '<Cmd>BufferMoveNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tp', '<Cmd>BufferPin<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- NOTE: The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
