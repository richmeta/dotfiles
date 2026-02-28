local mp = require("user.map")

-- note: we keep horizontal 'o' or CR
-- so as not to overwrite 's' (stage)

-- ctrl-t = open in tab (fugitive)
mp.nmap_b("<C-t>", "O", { remap = true})

-- ctrl-v = open in vertical split (fugitive)
mp.nmap_b("<c-v>", "gO", { remap = true})

