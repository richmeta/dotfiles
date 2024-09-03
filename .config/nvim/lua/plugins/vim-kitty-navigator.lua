local los = require("user.os")
local ret = {}
if not los.tmux_enabled then
    ret = {
        "knubie/vim-kitty-navigator",

        build = 'cp ./*.py ~/.config/kitty/',
    }
end

return ret
