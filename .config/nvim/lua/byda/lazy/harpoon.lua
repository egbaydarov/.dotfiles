return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
        vim.keymap.set("n", "<leader>ta", function() harpoon:list():add() end, { desc = "harpoon add tab" })
        vim.keymap.set("n", "<leader>tv", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon tabs view" })

        vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "harpoon tab 1" })
        vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "harpoon tab 2" })
        vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "harpoon tab 3" })
        vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "harpoon tab 4" })
        vim.keymap.set("n", "<C-;>", function() harpoon:list():select(5) end, { desc = "harpoon tab 5" })
    end
  }
}
