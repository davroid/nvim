return {
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
    opts = { lsp = { auto_attach = true } },
    keys = {
      {
        "<leader>dS",
        function()
          require("nvim-navbuddy").open()
        end,
        "Workspace symbols (Navbuddy)",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },

      { "williamboman/mason-lspconfig.nvim" },

      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      { "hrsh7th/cmp-nvim-lsp", enabled = false },

      { "saghen/blink.cmp" },

      { "onsails/lspkind.nvim" },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    opts = function()
      local nvim_lsp = require "lspconfig"

      local vue_language_server_path = vim.fn.stdpath "data"
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      return {
        servers = {
          vtsls = {
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = vue_language_server_path,
                      languages = { "vue" },
                      configNamespace = "typescript",
                    },
                  },
                },
              },
              typescript = {
                suggest = { completeFunctionCalls = true },
                updateImportsOnFileMove = { enabled = "always" },
                inlayHints = { parameterTypes = { enabled = true } },
              },
            },
          },
          denols = {
            root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
          },
          angularls = {},
          vue_ls = {},
          astro = {},
          html = {},
          cssls = {},
          tailwindcss = {},

          pyright = {},
          clangd = {},
          gopls = {},

          -- NOTE: nix-lsp doesn't working on fedora
          -- nil_ls = {
          -- 	settings = {
          -- 		testSetting = 42,
          -- 		formatting = {
          -- 			command = { "nixpkgs-fmt" },
          -- 		},
          -- 	},
          -- },

          lua_ls = {
            -- cmd = {...},
            -- filetypes = { ...},
            -- capabilities = {},
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                completion = {
                  callSnippet = "Replace",
                },
                diagnostics = {
                  disable = { "missing-fields" },
                  globals = { "vim" },
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(attach_event)
          local nmap = function(keys, func, desc, modes)
            vim.keymap.set(modes or "n", keys, func, { buffer = attach_event.buf, desc = "LSP: " .. desc })
          end

          local builtin = require "telescope.builtin"

          nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
          nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
          nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
          nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
          nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
          nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          nmap("gD", vim.lsp.buf.declaration, "Goto declaration")
          nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          nmap("<leader>ca", vim.lsp.buf.code_action, "code action", { "n", "v" })
          nmap("K", vim.lsp.buf.hover, "Hover Documentation")
          nmap("<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbol (vim)")
          nmap("<leader>vd", vim.diagnostic.open_float, "Open diagnostics (vim)")

          -- Lesser used LSP functionality
          nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
          nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
          nmap("<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "workspace list folders")

          local client = vim.lsp.get_client_by_id(attach_event.data.client_id)
          if not client then
            return
          end

          if not client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            return
          end

          local toggle_inlay_hints = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = attach_event.buf })
          end

          nmap("<leader>th", toggle_inlay_hints, "[T]oggle Inlay [H]ints")
          toggle_inlay_hints()
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      local ensure_installed = vim.tbl_keys(opts.servers or {})

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }
      require("mason-lspconfig").setup { automatic_enable = ensure_installed }

      for server_name, server in pairs(opts.servers or {}) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

        vim.lsp.config(server_name, server)
      end
    end,
  },
}
