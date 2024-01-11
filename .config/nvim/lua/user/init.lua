require('user.vars')
require('user.settings')
require('user.lazy')
require('user.keymaps')
require('user.autocmd')
require('user.commands')
require('user.abbrev')
require('user.gui')

-- local configs
pcall(require, 'user.local')
