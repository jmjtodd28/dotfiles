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
        --ensure_installed = { "lua_ls", "gopls" },
        ensure_installed = { "lua_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", {
        -- capabilities = capabilities,
      })

      --[[
      vim.lsp.config("gopls", {
        capabilities = capabilities,
				root_dir = "~/core3/src/vault",
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        directoryFilters = { "-plz-out" },
        linksInHover = false,
        usePlaceholders = false,
        semanticTokens = true,
        codelenses = {
          gc_details = true,
        },
      })
      --]]
      vim.lsp.enable("gopls", {
        -- Optional: customize capabilities, settings, etc.
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

      --[[
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        root_dir = vim.fn.expand("~/core3/src/vault"),
        directoryFilters = { "-plz-out" },
        --analyses = {
        --	unusedparams = true,
        --},
        --staticcheck = true,
      })
      --]]

      vim.lsp.config("pyright", {
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
      -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>ge", vim.diagnostic.goto_next, {})
      vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

      -- Map find references to telescope picker
      vim.keymap.set("n", "<leader>gr", function()
        require("telescope.builtin").lsp_references({})
      end, {})
    end,
  },
}
