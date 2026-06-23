-----------------------------------------------------------------------------------------------------------------------
-- Plugins

vim.pack.add({
  -- Treesitter parser & query downloader
  "https://github.com/arborist-ts/arborist.nvim",

  -- Agentic coding
  "https://git.gtz.dk/agj/opencode.nvim.git",

  -- Integrate with tmux
  "https://github.com/christoomey/vim-tmux-navigator",

  -- Theming
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/vague-theme/vague.nvim",
  "https://github.com/vimcolorschemes/olive-crt.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/zaldih/themery.nvim",
  "https://github.com/j-hui/fidget.nvim",

  -- File-tree view
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",

  -- Telescope
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",

  -- lazygit integration
  "https://github.com/kdheepak/lazygit.nvim",

  -- Neorg note taking
  "https://github.com/folke/snacks.nvim",
  "https://github.com/3rd/image.nvim",
  "https://github.com/nvim-neorg/tree-sitter-norg",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/pysan3/pathlib.nvim",
  "https://github.com/nvim-neorg/lua-utils.nvim",
  "https://github.com/nvim-neorg/neorg",
  "https://github.com/sillydan1/tuxedo.nvim",

  -- cmake based repositories
  "https://github.com/civitasv/cmake-tools.nvim",
})

-----------------------------------------------------------------------------------------------------------------------
-- Global options. See `:help vim.o` and `"help vim.g`

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("imap <C-c> <Esc>")
vim.cmd("let g:cmake_link_compile_commands = 1")
vim.cmd("set colorcolumn=120")
vim.o.autoread = true
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
vim.o.winborder = "rounded"
vim.wo.nu = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

vim.filetype.add({
  pattern = {
    [".*.service"] = "systemd",
    ["Jenkinsfile"] = "groovy",
  },
})

-----------------------------------------------------------------------------------------------------------------------
-- Language server setup

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
-- LSP
-----------------------------------------------------------------------------------------------------------------------

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

vim.lsp.config.json_lsp = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json" },
}

-- TODO: Remove basedpyright configuration when ty is battletested
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
          reportCallInDefaultInitializer = false,  -- sometimes used when dependency injecting in a flask app
        }
      }
    }
  }
}

vim.lsp.config.ty = {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  settings = {
    ty = {
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

-- TODO: Investigate neocmakelsp and how to configure it, because it's miles better
vim.lsp.config.cmake_language_server = {
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" }
}

vim.lsp.config.textlsp = {
  cmd = { "textlsp" },
  filetypes = { "txt", "latex", "org" }
}

vim.lsp.enable({
  "clangd",
  "luals",
  "ruff",
  "jdtls",
  "rust_analyzer",
  "textlsp",
  "cmake_language_server",
  "ty",
  "json_lsp",
})

vim.lsp.enable({
  "clangd",
  "luals",
  "ruff",
  "jdtls",
  "rust_analyzer",
  "textlsp",
  "cmake_language_server",
  "ty",
  "json_lsp",
})

-----------------------------------------------------------------------------------------------------------------------
-- Autocommands

-- Highlight whatever you're yanking.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})

-- Switch between header and source file in C/C++ projects.
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
  end,
})

-- Auto-reload files changed outside Neovim
vim.api.nvim_create_autocmd({
  "FocusGained", "BufEnter", "WinEnter",
  "TermLeave", "CursorHold", "CursorHoldI"
}, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Use libuv to watch filesystem for changes in cwd
local cwd_watcher ---@type uv_fs_event_t|nil

local function watch_cwd()
  if cwd_watcher then
    return
  end

  cwd_watcher = vim.uv.new_fs_event()
  cwd_watcher:start(vim.fn.getcwd(), { recursive = true }, function(err, _fname)
    if err then return end
    vim.schedule(function()
      -- Only reload unmodified, non-special buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].modified then goto continue end
        if vim.bo[buf].buftype ~= "" then goto continue end
        local bname = vim.api.nvim_buf_get_name(buf)
        if bname ~= "" and vim.fn.filereadable(bname) == 1 then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("checktime")
          end)
        end
        ::continue::
      end
    end)
  end)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if cwd_watcher then
      cwd_watcher:stop()
      cwd_watcher:close()
      cwd_watcher = nil
    end
  end,
})

watch_cwd()
-----------------------------------------------------------------------------------------------------------------------
-- Plugin setup calls

require("vim._core.ui2").enable({})

require("cmake-tools").setup({})

require("arborist").setup({
  overrides = {
    norg = { url = "https://github.com/nvim-neorg/tree-sitter-norg" },
    norg_meta = { url = "https://github.com/nvim-neorg/tree-sitter-norg-meta" },
  },
  ensure_installed = {
    "norg",
    "norg_meta",
  }
})

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

require("themery").setup({
  themes = {
    "gruvbox",
    "vague",
    "olive-crt",
    "catppuccin",
    "catppuccin-latte",
  }
})

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

-- TODO: It would be nice to not have to rely on snacks.nvim here.
require("snacks").setup({
  image = {},
})

require("fidget").setup()

require("opencode").setup({
  width = 0.3,
})

require("tuxedo").setup({
  create_todo_file = false,
  width_ratio = 0.70,
  height_ratio = 0.50,
})

-----------------------------------------------------------------------------------------------------------------------
-- General navigation

vim.keymap.set("n", "<leader>o", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>p", "<Cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>")
vim.keymap.set("n", "<leader>tt", "<Cmd>Tuxedo<CR>")
vim.keymap.set("n", "<C-w>h", "<Cmd>sp<CR>")
vim.keymap.set('n', '<leader>gk', function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end)

-----------------------------------------------------------------------------------------------------------------------
-- Themery interaction
vim.keymap.set({ "n" }, "<Leader>TT", "<Cmd>Themery<CR>")

-----------------------------------------------------------------------------------------------------------------------
-- Neorg interaction

vim.keymap.set("n", "<leader>ne", "<Cmd>Neorg workspace notes<CR>")
vim.keymap.set("n", "<leader>nj", "<Cmd>Neorg journal today<CR>")

-----------------------------------------------------------------------------------------------------------------------
-- CMake

vim.keymap.set("n", "<leader>cc", "<Cmd>CMakeGenerate<CR>", { desc = "[C]Make project [C]onfigure" })
vim.keymap.set("n", "<leader>cb", "<Cmd>CMakeBuild<CR>", { desc = "[C]Make project [B]uild" })
vim.keymap.set("n", "<leader>ci", "<Cmd>CMakeInstall --prefix out/install<CR>", { desc = "[C]Make project [I]nstall" })
vim.keymap.set("n", "<leader>cC", "<Cmd>CMakeClean<CR>", { desc = "[C]Make project [C]lean" })

-----------------------------------------------------------------------------------------------------------------------
-- LSP interaction

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>FF", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float)

-----------------------------------------------------------------------------------------------------------------------
-- Telescope interaction

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", telescope.find_files)
vim.keymap.set("n", "<leader>sF", function() telescope.find_files({ no_ignore = true }) end)
vim.keymap.set("n", "<leader><space>", telescope.buffers)
vim.keymap.set("n", "<leader>sg", telescope.live_grep)
vim.keymap.set("n", "<leader>sG", function() telescope.live_grep({ additional_args = { "--no-ignore" } }) end)
vim.keymap.set("n", "gr", telescope.lsp_references)

-----------------------------------------------------------------------------------------------------------------------
-- Coding Agent interaction

vim.keymap.set("n", "<leader>a", "<Cmd>OpenCodeToggle<CR>")

-----------------------------------------------------------------------------------------------------------------------

-- NOTE: The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
