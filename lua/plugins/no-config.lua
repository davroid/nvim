return {
  {
    "theprimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  {
    "wakatime/vim-wakatime",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "m4xshen/hardtime.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false,
      disabled_filetypes = {
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_stacks",
        "dapui_watches",
        "dapui_repl",
        "dap-float",
        "FTerm",
        "netrw",
        "mason",
      },
    },
  },

  {
    "echasnovski/mini.move",
    keys = {
      { "<M-S-j>", mode = { "n", "v" } },
      { "<M-S-k>", mode = { "n", "v" } },
      { "<M-S-h>", mode = { "n", "v" } },
      { "<M-S-l>", mode = { "n", "v" } },
    },
    version = "*",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = "<M-S-h>",
        right = "<M-S-l>",
        down = "<M-S-j>",
        up = "<M-S-k>",

        -- Move current line in Normal mode
        line_left = "<M-S-h>",
        line_right = "<M-S-l>",
        line_down = "<M-S-j>",
        line_up = "<M-S-k>",
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },

  {
    "thalesgelinger/toon.nvim",
    config = function()
      require("toon").setup()
    end,
  },
}
