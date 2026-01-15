local accept = "<Tab>"
local accept_word = "<C-j>"
local dismiss = "<C-}>"

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = accept,
          dismiss = dismiss,
          accept_word = accept_word,
        },
      },
      panel = { enabled = false },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    enabled = true,
    event = "InsertEnter",
    opts = {
      {
        keymaps = {
          accept_suggestion = accept,
          clear_suggestion = dismiss,
          accept_word = accept_word,
        },
      },
    },
  },

  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      window = {
        position = "vertical",
      },
      git = {
        use_git_root = false,
      },
    },
  },
}
