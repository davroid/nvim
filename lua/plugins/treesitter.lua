return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",

    "nvim-treesitter/nvim-treesitter-context",

    {
      "aaronik/treewalker.nvim",
      keys = {
        {
          "<C-k>",
          function()
            vim.cmd.Treewalker "Up"
          end,
          desc = "Previous treesitter node",
        },
        {
          "<C-j>",
          function()
            vim.cmd.Treewalker "Down"
          end,
          desc = "Next treesitter node",
        },
        {
          "<C-l>",
          function()
            vim.cmd.Treewalker "Right"
          end,
          desc = "Inner treesitter node",
        },
        {
          "<C-h>",
          function()
            vim.cmd.Treewalker "Left"
          end,
          desc = "Outer treesitter node",
        },
        {
          "<C-S-k>",
          function()
            vim.cmd.Treewalker "SwapUp"
          end,
          desc = "Swap with previous treesitter node",
        },
        {
          "<C-S-j>",
          function()
            vim.cmd.Treewalker "SwapDown"
          end,
          desc = "Swap with next treesitter node",
        },
      },
    },

    { "windwp/nvim-ts-autotag", config = true },

    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      main = "ts_context_commentstring",
      opts = {
        enable = true,
        enable_autocmd = false,
      },
    },

    {
      "RRethy/vim-illuminate",
      opts = {
        delay = 200,
        large_file_cutoff = 2000,
      },
      config = function(_, opts)
        require("illuminate").configure(opts)
      end,
    },

    {
      "HiPhish/rainbow-delimiters.nvim",
      opts = function()
        local rainbow_delimiters = require "rainbow-delimiters"

        return {
          strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            commonlisp = rainbow_delimiters.strategy["local"],
          },
          query = {
            [""] = "rainbow-delimiters",
            latex = "rainbow-blocks",
          },
          highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
          },
          blacklist = { "c", "cpp" },
        }
      end,
      config = function(_, opts)
        require("rainbow-delimiters.setup").setup(opts)
      end,
    },
  },
  build = ":TSUpdate",
  ---@type TSConfig
  opts = {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "lua", "python", "tsx", "javascript", "typescript", "vimdoc", "vim" },
    modules = {},

    sync_install = false,
    auto_install = true,
    ignore_install = {},

    indent = { enable = true },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gn",
        node_incremental = "gn",
        scope_incremental = "gs",
        node_decremental = "gm",
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ii"] = "@conditional.inner",
          ["ai"] = "@conditional.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
          ["<leader>p"] = "@function.outer",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
          ["<leader>P"] = "@function.outer",
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
