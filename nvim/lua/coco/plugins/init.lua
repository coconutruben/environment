return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier",
        "ruff",
        "stylua",
      },
      run_on_start = true,
      start_delay = 3000,
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "rust_analyzer",
        "ts_ls",
      },
    },
    config = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for _, server in ipairs(opts.ensure_installed) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      require("mason-lspconfig").setup(opts)
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "milanglacier/minuet-ai.nvim",
    },
    opts = function()
      return {
        keymap = {
          preset = "default",
          ["<A-y>"] = require("minuet").make_blink_map(),
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = { auto_show = false },
          trigger = { prefetch_on_insert = false },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              timeout_ms = 3000,
              score_offset = 50,
            },
          },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },
      }
    end,
  },

  {
    "milanglacier/minuet-ai.nvim",
    cmd = "Minuet",
    opts = {
      provider = "openai",
      blink = {
        enable_auto_complete = false,
      },
      virtualtext = {
        auto_trigger_ft = {},
      },
      provider_options = {
        openai = {
          stream = true,
          api_key = "OPENAI_API_KEY",
        },
      },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI inline" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = { adapter = "openai_responses" },
        inline = { adapter = "openai_responses" },
        cmd = { adapter = "openai_responses" },
      },
      adapters = {
        http = {
          openai_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              env = {
                api_key = "OPENAI_API_KEY",
              },
              schema = {
                model = {
                  default = "gpt-5.4-mini",
                },
              },
            })
          end,
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local languages = {
        "bash",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "toml",
        "typescript",
        "vim",
        "yaml",
      }

      require("nvim-treesitter").setup()

      if #vim.api.nvim_list_uis() > 0 then
        require("nvim-treesitter").install(languages)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        javascript = { "prettier", stop_after_first = true },
        javascriptreact = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        typescriptreact = { "prettier", stop_after_first = true },
        rust = { "rustfmt", lsp_format = "fallback" },
        lua = { "stylua" },
      },
    },
  },
}
