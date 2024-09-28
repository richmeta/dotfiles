-- useful for logging plugins etc
local M = {}
local logfile = assert(io.open("/tmp/lua.log", "a"))

function M.logwrite(s)
  local now = os.date("%H:%M:%S")
  logfile:write(now .. ' ' .. s .. "\n")
  logfile:flush()
end

function M.log(s)
  local file = io.open("/tmp/lint.log", "a")
  assert(file, "failed to open log for write")
  file:write(s .. "\n")
  file:close()
end

function M.debug_linter(cmd, linter_opts)
  M.logwrite("cwd = " .. vim.fn.getcwd())
  local c = cmd .. ' ' .. table.concat(linter_opts.args, ' ')
  M.logwrite("running: " .. c)
  local f = assert(io.popen(c, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  M.logwrite(s)
end

return M
