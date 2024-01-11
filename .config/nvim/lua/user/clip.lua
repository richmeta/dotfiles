local M = {}

function M.copy(what)
    vim.fn.setreg("+", what)
end


return M

