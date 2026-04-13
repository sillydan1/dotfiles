vim.pack.add({
  -- Neorg and dependencies
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-neorg/tree-sitter-norg",
  "https://github.com/vhyrro/luarocks.nvim",
  "https://github.com/nvim-neorg/lua-utils.nvim",
  "https://github.com/pysan3/pathlib.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  { src = "https://github.com/nvim-neorg/neorg", version = "v9.6.4" },

  -- Other
  -- "https://github.com/christoomey/vim-tmux-navigator",
  -- "https://github.com/f-person/git-blame.nvim",
  -- "https://github.com/mfussenegger/nvim-dap",
  -- "https://github.com/numtostr/comment.nvim",
  -- "https://github.com/nvim-tree/nvim-web-devicons",
})

-----------------------------------------------------------------------------------------------------------------------

-- NOTE: see `:help vim.o`
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
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

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

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

vim.diagnostic.config({
  virtual_text = true
})

vim.lsp.enable({ "clangd", "luals", "ruff", "jdtls", "rust_analyzer", "textlsp", "cmake_language_server", "ty",
  "json_lsp" })

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
    -- local telescope = require("telescope.builtin")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
    -- vim.keymap.set("n", "gr", telescope.lsp_references)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help)
  end,
})

-----------------------------------------------------------------------------------------------------------------------

require("luarocks-nvim").setup()

require("neorg").setup({
  config = {
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
  }
})

-----------------------------------------------------------------------------------------------------------------------

-- All of these are installed through `pacman -S tree-sitter-grammar`
vim.treesitter.language.add('bash')
vim.treesitter.language.add('c')
vim.treesitter.language.add('javascript')
vim.treesitter.language.add('lua')
vim.treesitter.language.add('markdown')
vim.treesitter.language.add('python')
vim.treesitter.language.add('query')
vim.treesitter.language.add('rust')
vim.treesitter.language.add('vim ')
vim.treesitter.language.add('vimdoc')

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

-- NOTE: The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
