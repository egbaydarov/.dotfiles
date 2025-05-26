local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)

map("n", "<leader>gd", vim.lsp.buf.definition)               -- Go to definition
map("n", "<leader>gr", vim.lsp.buf.references)               -- Find references
map("n", "<leader>gi", vim.lsp.buf.implementation)           -- Go to implementation
map("n", "<leader>gD", vim.lsp.buf.declaration)              -- Go to declaration
map("n", "<leader>K", vim.lsp.buf.hover)                     -- Show hover documentation
map("n", "<leader>rn", vim.lsp.buf.rename)                   -- Rename symbol
map("n", "<leader>ca", vim.lsp.buf.code_action)              -- Show code actions
map("n", "<leader>td", vim.lsp.buf.type_definition)          -- Go to type definition
map("n", "<leader>sh", vim.lsp.buf.signature_help)           -- Show signature help
map("n", "<leader>lh", vim.lsp.buf.typehierarchy)            -- Show type hierarchy

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

