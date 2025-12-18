return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },

    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "gopls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            }
          }
        }
      }
      vim.lsp.enable("lua_ls")

      vim.lsp.config.gopls = {
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go" },
        settings = {
          gopls = {
            directoryFilters = { '-plz-out' },
            linksInHover = false,
            semanticTokens = true,
            analyses = {
              unusedimports = false,
            },
          },
        },
        root_dir = function(bufnr, on_dir)
          local current_file = vim.api.nvim_buf_get_name(bufnr)
          local work_path = "/home/jtodd/core3/src"
          local vault_path = "/home/jtodd/core3/src/vault/"

          -- 1. Check if the current file is inside work project directory
          if current_file:find(work_path, 1, true) then
            on_dir(vault_path)
            return
          end

          -- 2. Use standard Go/Git root discovery for everything else
          local root = vim.fs.root(bufnr, { "go.work", "go.mod", ".git" })

          -- If no root is found, default to the directory of the current file
          on_dir(root or vim.fs.dirname(current_file))
        end,
      }
      vim.lsp.enable("gopls")

      local util = require('lspconfig.util')

      vim.lsp.pyright = {
        capabilities = capabilities,
        cmd = { "pyright" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              typeCheckingMode = "standard",
              verboseOutput = false,
              logLevel = "Error",
              extraPaths = {
                "plz_out/gen",
                "plz-out/gen",
                "plz-out/python/venv",
              },
            },
          },
        },
        on_new_config = function(config, root_dir)
          if util.root_pattern('.plzconfig') then
            config.settings = vim.tbl_deep_extend('force', config.settings, {
              python = {
                analysis = {
                  extraPaths = {
                    vim.fs.joinpath(root_dir, 'plz-out/python/venv'),
                  },
                  exclude = { 'plz-out' },
                },
              },
            })
          end
        end,
        root_dir = function()
          return vim.fn.getcwd()
        end,
      }
      vim.lsp.enable("pyright")

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<leader>go", vim.lsp.buf.type_definition, {})
      vim.keymap.set("n", "<leader>gq", vim.lsp.buf.references, {}) --open in quick fix
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>ge", vim.diagnostic.goto_next, {})
      vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

      -- Map find references to telescope picker
      vim.keymap.set("n", "<leader>gr", function()
        require("telescope.builtin").lsp_references({})
      end, {})

      -- format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
}
