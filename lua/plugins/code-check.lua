-- selencopeFuzzyCommandSearch): allow(mixed_table)
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      {
        "rshkarin/mason-nvim-lint",
        opts = { quiet_mode = true },
      },
    },
    config = function()
      local check_spelling = true

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()

          if check_spelling then
            require("lint").try_lint "cspell"
          end
        end,
      })

      vim.keymap.set("n", "<leader>sp", function()
        require("lint").try_lint "cspell"
      end, { desc = "Check spelling on the current buffer" })

      vim.keymap.set("n", "<leader>ts", function()
        check_spelling = not check_spelling

        if not check_spelling then
          vim.diagnostic.reset()
        end

        local msg = "Spell checking " .. (check_spelling and "ON" or "OFF")

        vim.notify(msg, vim.log.levels.INFO)
      end, { desc = "Toggle spelling" })

      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        html = { "eslint_d" },

        lua = { "selene" },

        python = { "flake8" },

        cpp = { "cpplint" },
        c = { "cpplint" },

        go = { "golangcilint" },

        sh = { "shellcheck" },
      }
    end,
  },

  {

    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "zapling/mason-conform.nvim", config = true },
    },
    keys = {
      {
        "<M-f>",
        function()
          require("conform").format {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          }
        end,
        mode = { "n", "v" },
        desc = "Format file or range (in visual mode) with conform",
      },
    },
    opts = {
      format_after_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
      formatters_by_ft = {
        javascript = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
        typescript = {
          "eslint_d",
          "prettierd",
          "prettier",
          stop_after_first = true,
        },
        javascriptreact = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },

        nix = { "nixpkgs_fmt" },

        yaml = { "yamlfmt" },

        lua = { "stylua" },

        python = { "isort", "black" },

        go = { "goimports", "gofumpt" },

        cpp = { "clang-format" },
        c = { "clang-format" },

        rust = { "rustfmt" },

        sh = { "beautysh" },
      },
    },
  },
}
