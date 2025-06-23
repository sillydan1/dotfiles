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
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    lazy = true
  },
  {
    "github/copilot.vim",
    lazy = false
  },
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "folke/todo-comments.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  -- NOTE: I would like to use snacks.nvim instead of this - I only use ui-select for code actions.
  "nvim-telescope/telescope-ui-select.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/nvim-treesitter",
  "romgrk/barbar.nvim",
  "nvim-web-devicons",
  "williamboman/mason.nvim",
  "j-hui/fidget.nvim",
  "f-person/git-blame.nvim",
  "jay-babu/mason-nvim-dap.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-tree/nvim-web-devicons",
  "aca/marp.nvim",
  "lewis6991/gitsigns.nvim",
  "christoomey/vim-tmux-navigator",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "rose-pine/neovim",
  "nvim-lualine/lualine.nvim",
  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup({
        themes = {
          "catppuccin-macchiato",
          "catppuccin-latte",
          "rose-pine-dawn"
        }
      })
    end
  },
  "hrsh7th/nvim-cmp",
  "lukas-reineke/indent-blankline.nvim",
  "numToStr/Comment.nvim",
  "civitasv/cmake-tools.nvim",
  "BurntSushi/ripgrep",
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
  "kristijanhusak/vim-dadbod-completion",
  "danymat/neogen",
  "andythigpen/nvim-coverage",
  "klen/nvim-test",
  "mbbill/undotree",
  "mikavilpas/yazi.nvim",
  "raafatturki/hex.nvim",
  { "danymat/neogen",  config = true },
  {
    "folke/lazydev.nvim",
    ft = "lua"
  },
  "sillydan1/luajava.nvim",
  "sillydan1/graphedit-lua.nvim",
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = false,
  },
  {
    "folke/snacks.nvim",
    dependencies = { "3rd/image.nvim" },
    priority = 1000,
    lazy = false,
    opts = {
      image = {},
      input = {},
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      notifier = {
        enabled = true,
        timeout = 3000,
        top_down = false,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>.",  function() Snacks.scratch() end,          desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,   desc = "Select Scratch Buffer" },
      { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git Blame Line" },
      { "<leader>dd", function() Snacks.notifier.hide() end,    desc = "Dismiss All Notifications" },
      {
        "<leader>1", -- Still debating this...
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
  -- Markdown workflow things
  "jghauser/follow-md-links.nvim",
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        style = "full",
        border = "thick",
        sign = false,
      },
      heading = {
        sign = false,
        width = 'block',
        position = 'inline',
        icons = { "◉ ", "◎ ", "○ ", "✺ ", "▶ ", "◉ " },
      },
    }
  }
})

-----------------------------------------------------------------------------------------------------------------------

-- NOTE: see `:help vim.o`
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("imap <C-c> <Esc>")
vim.cmd("let g:cmake_link_compile_commands = 1")
vim.cmd("set colorcolumn=120")
vim.o.breakindent = true
vim.o.cindent = true
vim.o.completeopt = "menu,noselect,noinsert,noselect,fuzzy,popup"
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.mouse = "a"
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.wo.nu = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

vim.cmd [[
  augroup groovy_filetype
    autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
  augroup END
]]

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.lsp.config.clangd = {
  cmd = { "clangd", "--background-index" },
  root_markers = { "compile_commands.json", "compile_flags.txt" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}

vim.lsp.config.luals = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME
        }
      }
    }
  }
}

vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        include = {
          "src"
        },
        diagnosticSeverityOverrides = {
          reportAny = false,
          reportUnknownMemberType = false,
          reportMissingImports = "error",
          reportMissingTypeStubs = false,
          reportUnknownVariableType = false,
          reportUnknownArgumentType = false,
          reportImplicitOverride = false,        -- python3.12 is a bit too new for some projects.
          reportUnusedCallResult = false,
          reportPrivateLocalImportUsage = false, -- a bit aggressive, even though I empathize
          reportImplicitRelativeImport = false,
          reportUnusedFunction = "warning",
          reportUnannotatedClassAttribute = false, -- https://peps.python.org/pep-0591/ is quite aggressive
        }
      }
    }
  }
}

vim.lsp.config.ruff = {
  cmd = { "ruff", "server" },
  filetypes = { "python" }
}

vim.lsp.config.jdtls = {
  cmd = { "jdtls" },
  filetypes = { "java" },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}

vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" }
}

vim.lsp.config.textlsp = {
  cmd = { "textlsp" },
  filetypes = { "org" }
}

-- TODO: Investigate neocmakelsp and how to configure it, because it's miles better
vim.lsp.config.cmake_language_server = {
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" }
}

vim.diagnostic.config({
  virtual_text = true
})

vim.lsp.enable({ "clangd", "luals", "basedpyright", "ruff", "jdtls", "rust_analyzer", "textlsp", "cmake_language_server" })

-- NOTE: Stolen from nvim-lspconfig
-- TODO: Move this somewhere prettier
local function switch_source_header(bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  vim.validate("bufnr", bufnr, "number")
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
  if not client then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end

    -- Enable autocompletion
    if client:supports_method("textDocument/completion") then
      -- Overwrite the trigger characters to be ANY character
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      -- Enable LSP Completion
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true
      })
    end

    -- Feature-gated keybinds
    if client:supports_method("textDocument/switchSourceHeader") then
      vim.keymap.set("n", "gh", function() switch_source_header(0) end)
    end

    -- Set keybinds
    local telescope = require("telescope.builtin")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
    vim.keymap.set("n", "gr", telescope.lsp_references)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help)
  end,
})

-----------------------------------------------------------------------------------------------------------------------

vim.cmd(":Copilot disable") -- Disable copilot to get it to be on-demand rather than always on.
require("lazydev").setup()
require("fidget").setup()
require("cmake-tools").setup({})
require("dapui").setup()
require("nvim-test").setup()
require("coverage").setup()
require("Comment").setup()
require("hex").setup()
require("mason").setup()
require("todo-comments").setup()
pcall(require("telescope").load_extension, "fzf")
require("telescope").load_extension("ui-select")

local python_path = table.concat({
      vim.fn.stdpath("data"),
      "mason",
      "packages",
      "debugpy",
      "venv",
      "bin",
      "python"
    }, "/")
    :gsub("//+", "/")
require("dap-python").setup(python_path)

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    side = "right",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
require("neorg").setup({
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.export"] = {},
    ["core.export.markdown"] = {},
    ["core.latex.renderer"] = {},
    ["core.ui.calendar"] = {},
    ["core.journal"] = {
      config = {
        journal_folder = "journal",
        strategy = "flat",
        workspace = "notes"
      }
    },
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/git/notes",
        },
        index = "index.norg",
      }
    }
  }
})
require("lualine").setup({
  options = {
    icons_enabled = false,
    component_separators = "|",
    section_separators = "|",
  },
})
require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
}
require("telescope").setup({
  extensions = {
    workspaces = {
      keep_insert = true,
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "java",
    "rust",
    "typescript",
    "jsonc",
    "vimdoc",
    "vim",
    "norg"
  },
  modules = {},
  ignore_install = {},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true
  }
})
require("mason-nvim-dap").setup({
  ensure_installed = { "codelldb" },
  automatic_installation = false,
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end,
    codelldb = function(config)
      config.adapters = {
        type = "executable",
        command = "codelldb",
      }
      require("mason-nvim-dap").default_setup(config)
    end
  }
})
-- NOTE: native "gdb" is not available through mason yet.
require("dap").adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
require("dap").configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    postRunCommands = {
      "breakpoint name configure --disable cpp_exception" -- Don't stop on every exception please
    }
  },
  {
    name = "Select and attach to process",
    type = "codelldb",
    request = "attach",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    pid = function()
      local name = vim.fn.input("Executable name (filter): ")
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = "${workspaceFolder}",
    postRunCommands = {
      "breakpoint name configure --disable cpp_exception" -- Don't stop on every exception please
    }
  },
  {
    name = "Attach to gdbserver localhost:1234",
    type = "gdb", -- NOTE: This is using native GDB, because codelldb is not fantastic regarding gdbserver
    request = "attach",
    target = "localhost:1234",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
}

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("i", "<C-D>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set("i", "<C-W>", "<Plug>(copilot-suggest)")
vim.keymap.set("n", "<leader>cp", function() vim.cmd(":Copilot panel") end)
vim.keymap.set("i", "<C-Q>", "<Plug>(copilot-dismiss)")
vim.g.copilot_no_tab_map = true

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<C-w>h", function() vim.cmd(":sp") end, { desc = "split horizontally" })

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>nq", ":cnext<CR>", { desc = "[N]ext quickfix item" })
vim.keymap.set("n", "<leader>Nq", ":cprevious<CR>", { desc = "[N]ext quickfix item (backwards)" })
vim.keymap.set("n", "<leader>DD", ":Neogen<CR>", { desc = "Generate [D]ocstring" })
vim.keymap.set("n", "<leader>uu", ":UndotreeToggle<CR>", { desc = "[U]ndotree toggle" })
vim.keymap.set("n", "<leader>ff", ":Yazi cwd<CR>", { desc = "Open [F]ile using filemanager" })
vim.keymap.set("n", "<leader>FF", function() vim.lsp.buf.format() end, { desc = "[F]ormat [F]ile (using LSP)" })
vim.keymap.set("n", "<leader>st", function() vim.cmd(":TodoTelescope") end, { desc = "[S]earch [T]odos" })
vim.keymap.set("n", "<leader>p", require("nvim-tree.api").tree.find_file, { desc = "show current file in nvim tree" })
vim.keymap.set("n", "<leader>o", require("nvim-tree.api").tree.toggle, { desc = "[O]pen file" })
vim.keymap.set("n", "H", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "L", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<leader>q", "<Cmd>BufferClose<CR>")
vim.keymap.set("n", "<leader>Q", "<Cmd>BufferClose!<CR>")
vim.keymap.set("n", "<leader><", "<Cmd>BufferMovePrevious<CR>")
vim.keymap.set("n", "<leader>>", "<Cmd>BufferMoveNext<CR>")
vim.keymap.set("n", "<leader>tp", "<Cmd>BufferPin<CR>")
vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>")

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>co", function()
  require("coverage").load_lcov("coverage.info", true)
end, { desc = "[CO]verage Toggle" })

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sF", function() require("telescope.builtin").find_files({ no_ignore = true }) end,
  { desc = "[S]earch All Files" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG",
  function() require("telescope.builtin").live_grep({ additional_args = { "--no-ignore" } }) end,
  { desc = "[S]earch all by [G]rep" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sc", require("telescope.builtin").commands, { desc = "[S]earch [C]ommands" })

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>cc", function() vim.cmd("CMakeGenerate") end, { desc = "[C]Make project [C]onfigure" })
vim.keymap.set("n", "<leader>cb", function() vim.cmd("CMakeBuild") end, { desc = "[C]Make project [B]uild" })
vim.keymap.set("n", "<leader>ci", function() vim.cmd("CMakeInstall --prefix out/install") end,
  { desc = "[C]Make project [I]nstall" })
vim.keymap.set("n", "<leader>cC", function() vim.cmd("CMakeClean") end, { desc = "[C]Make project [C]lean" })

-----------------------------------------------------------------------------------------------------------------------

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Next diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float, { desc = "Open diagnostics floating window" })

-----------------------------------------------------------------------------------------------------------------------

vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "red", { fg = "#ff3333" })
vim.api.nvim_set_hl(0, "veryred", { fg = "#ff0000" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red", linehl = "", numhl = "red" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "orange", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "blue", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "green", linehl = "", numhl = "green" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "red", linehl = "veryred", numhl = "" })
vim.keymap.set("n", "<F2>", require("dapui").open, { desc = "Debugger UI Open" })
vim.keymap.set("n", "<F3>", require("dapui").close, { desc = "Debugger UI close" })
vim.keymap.set("n", "<F4>", require("dap").close, { desc = "Debugger Close" })
vim.keymap.set("n", "<F5>", function()
  if vim.fn.filereadable(".vscode/launch.json") then
    require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" }, codelldb = { "c", "cpp" } })
  end
  require("dap").continue()
end, { desc = "Debugger Continue, or launch" })
vim.keymap.set("n", "<F6>", require("dap").step_over, { desc = "Debugger Step Over" })
vim.keymap.set("n", "<F7>", require("dap").step_into, { desc = "Debugger Step Into" })
vim.keymap.set("n", "<F8>", require("dap").step_out, { desc = "Debugger Step Out" })
vim.keymap.set("n", "<leader>B",
  function() require("dap").set_breakpoint(vim.fn.input("Set breakpoint condition: "), nil, nil) end,
  { desc = "Debugger New breakpoint with a condition" })
vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Debugger New breakpoint" })
vim.keymap.set("n", "<leader>dr", require("dap").repl.open, { desc = "Debugger open REPL" })
vim.keymap.set("n", "<leader>dl", require("dap").run_last, { desc = "Debugger run last run executable" })
vim.keymap.set("n", "<leader>df", require("dap").focus_frame, { desc = "Debugger focus to current stack" })
vim.keymap.set("n", "<leader>db",
  function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
  { desc = "Debugger new logpoint" })
vim.keymap.set("n", "<leader>dj", function()
  require("dap.ext.vscode").load_launchjs(vim.fn.input("Path to json: ", vim.fn.getcwd() .. "/", "file"),
    { cppdbg = { "c", "cpp" }, codelldb = { "c", "cpp" } })
end, { desc = "Debugger Load launch specification file" })
vim.keymap.set({ "n", "v" }, "<Leader>dh", require("dap.ui.widgets").hover, { desc = "Debugger hover menu" })
vim.keymap.set({ "n", "v" }, "<Leader>dp", require("dap.ui.widgets").preview, { desc = "Debugger preview menu" })
vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Debugger summon centered_float" })

vim.keymap.set({ "n" }, "<Leader>TT", function()
  vim.cmd("Themery")
end, { desc = "Open Themery" })

-----------------------------------------------------------------------------------------------------------------------

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>nl", function() vim.cmd("Neorg render-latex") end, { desc = "[N]eorg render [L]atex" })
vim.keymap.set("n", "<leader>ne", function() vim.cmd("Neorg workspace notes") end,
  { desc = "Open [Ne]org personal workspace" })
vim.keymap.set("n", "<leader>nj", function() vim.cmd("Neorg journal today") end, { desc = "Open [Ne]org [J]ournal" })
vim.api.nvim_create_augroup("filetype_mappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function()
    -- These are all detected using :checkhealth neorg
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>cm", "<Plug>(neorg.looking-glass.magnify-code-block)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>id", "<Plug>(neorg.tempus.insert-date)", opts) -- this uses core.ui.calendar.
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>li", "<Plug>(neorg.pivot.list.invert)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>lt", "<Plug>(neorg.pivot.list.toggle)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>ta", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>tc", "<Plug>(neorg.qol.todo-items.todo.cancelled)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>th", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>ti", "<Plug>(neorg.qol.todo-items.todo.task-important)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", opts)
  end
})

-----------------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  callback = function()
    -- Get the full path of the current file
    local file_path = vim.fn.expand("%:p")
    -- Ignore files in my daily note directory
    if file_path:match(os.getenv("HOME") .. "/github/obsidian_main/250%-daily/") then
      return
    end -- Avoid running zk multiple times for the same buffer
    if vim.b.zk_executed then
      return
    end
    vim.b.zk_executed = true -- Mark as executed
    -- Use `vim.defer_fn` to add a slight delay before executing `zk`
    vim.defer_fn(function()
      vim.cmd("normal zk")
      -- This write was disabling my inlay hints
      -- vim.cmd("silent write")
      vim.notify("Folded keymaps", vim.log.levels.INFO)
    end, 100) -- Delay in milliseconds (100ms should be enough)
  end,
})

-----------------------------------------------------------------------------------------------------------------------

-- NOTE: The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
