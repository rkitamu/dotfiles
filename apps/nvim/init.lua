-- NOTE: Ghostty の背景透過を活かすため、カラースキームの背景色を外す
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", update = true })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", update = true })

vim.pack.add({
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})
