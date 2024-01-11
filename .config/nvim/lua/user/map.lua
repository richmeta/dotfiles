local los = require("user.os")
local M = {}

local fn_mapping_term = {
    ["<S-F1>"]  = "<f13>",
    ["<S-F2>"]  = "<f14>",
    ["<S-F3>"]  = "<f15>",
    ["<S-F4>"]  = "<f16>",
    ["<S-F5>"]  = "<f17>",
    ["<S-F6>"]  = "<f18>",
    ["<S-F7>"]  = "<f19>",
    ["<S-F8>"]  = "<f20>",
    ["<S-F9>"]  = "<f21>",
    ["<S-F10>"] = "<f22>",
    ["<S-F11>"] = "<f23>",
    ["<S-F12>"] = "<f24>",
    ["<C-F1>"]  = "<f25>",
    ["<C-F2>"]  = "<f26>",
    ["<C-F3>"]  = "<f27>",
    ["<C-F4>"]  = "<f28>",
    ["<C-F5>"]  = "<f29>",
    ["<C-F6>"]  = "<f30>",
    ["<C-F7>"]  = "<f31>",
    ["<C-F8>"]  = "<f32>",
    ["<C-F9>"]  = "<f33>",
    ["<C-F10>"] = "<f34>",
    ["<C-F11>"] = "<f35>",
    ["<C-F12>"] = "<f36>",
}

-- returns the correct terminal mapping key for Ctrl/Shift Fn mappings
function M.fn_term(mapping)
    if not los.is_gui and string.match(mapping, "<[SCsc]%-[Ff]%d+>") ~= nil then
        return fn_mapping_term[mapping:upper()]
    end
    return mapping
end

local function bind(op, outer_opts)
    -- outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts or {}, opts or {})

        -- translate terminal fn keys
        if not los.is_gui and string.match(lhs, "<[SC]%-F%d+>") ~= nil then
            lhs = fn_mapping_term[lhs:upper()]
        end

        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local noremap = { noremap = true }
local nvo = { "n", "v", "o" }

M.noremap = bind(nvo, noremap)
M.cnoremap = bind("c", noremap)
M.inoremap = bind("i", noremap)
M.lnoremap = bind("l", noremap)
M.nnoremap = bind("n", noremap)
M.onoremap = bind("o", noremap)
M.snoremap = bind("s", noremap)
M.tnoremap = bind("t", noremap)
M.vnoremap = bind("v", noremap)
M.xnoremap = bind("x", noremap)
M.map = bind(nvo)
M.cmap = bind("c")
M.imap = bind("i")
M.lmap = bind("l")
M.nmap = bind("n")
M.omap = bind("o")
M.smap = bind("s")
M.tmap = bind("t")
M.vmap = bind("v")
M.xmap = bind("x")


-- buffer maps
-- add as appropriate
local buffer = { buffer = true }
local buffer_noremap = { noremap = true, buffer = true }
M.nnoremap_b = bind("n", buffer_noremap)
M.tnoremap_b = bind("t", buffer_noremap)
M.xnoremap_b = bind("x", buffer_noremap)
M.nmap_b = bind("n", buffer)
M.imap_b = bind("i", buffer)
M.vmap_b = bind("v", buffer)
M.tmap_b = bind("t", buffer)

return M
