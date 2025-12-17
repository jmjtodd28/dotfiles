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
        -- For some reason gopls doesnt work on TM machine when using mason
        -- need to manually download as an executable on machine for this to work
        ensure_installed = { "lua_ls", "pyright" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.enable("lua_ls", {
        capabilities = capabilities,
      })

      vim.lsp.enable("gopls", {
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
        settings = {
          gopls = {
            directoryFilters = { "-plz-out" },
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })

      vim.lsp.enable("pyright", {
        capabilities = capabilities,
        root_dir = "~/core3/src/vault",
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              typeCheckingMode = "standard",
              verboseOutput = true,
              logLevel = "Trace",
              extraPaths = {
                "plz_out/gen",
                "plz-out/gen",
                "plz-out/python/venv",
              },
            },
          },
        },
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<leader>go", vim.lsp.buf.type_definition, {})
      vim.keymap.set("n", "<leader>gq", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>ge", vim.diagnostic.goto_next, {})
      vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

      -- Map find references to telescope picker
      vim.keymap.set("n", "<leader>gr", function()
        require("telescope.builtin").lsp_references({})
      end, {})
    end,
  },
}
