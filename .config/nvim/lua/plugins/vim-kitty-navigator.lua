local los = require("user.os")
if los.tmux_enabled then
    return {}
else
    return {
        "knubie/vim-kitty-navigator",
    }
end
