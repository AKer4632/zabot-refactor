-- core/shell_safe.lua
-- 安全命令执行：禁止 su，路径自动转义，mv/mkdir 改用 Java File API

local config = require "config"
local M = {}

--- 执行命令（过滤危险指令）
-- @param cmd string 完整命令
-- @return ok boolean, out string, err string, code number
function M.exec(cmd)
  if type(cmd) ~= "string" then
    return false, "", "E_INVALID_CMD", -1
  end

  local bin = cmd:match("^(%S+)")
  if not bin then
    return false, "", "E_EMPTY_CMD", -1
  end

  -- FORBIDDEN check
  if config.FORBIDDEN[bin] then
    return false, "", "E_PERM: " .. bin .. " is permanently disabled", -1
  end

  local p = Runtime.getRuntime():exec(cmd)
  local rd = BufferedReader(InputStreamReader(p:getInputStream()))
  local er = BufferedReader(InputStreamReader(p:getErrorStream()))

  local out, e = {}, {}
  for l in rd:readLine() do out[#out+1] = l end
  for l in er:readLine() do e[#e+1] = l end

  p:waitFor()
  rd:close()
  er:close()

  return true,
    table.concat(out, "\n"),
    table.concat(e, "\n"),
    p:exitValue()
end

--- 创建目录（使用 Java File API，避免 os.execute 注入）
function M.mkdir(dirPath)
  import "java.io.File"
  local dir = File(dirPath)
  if not dir:exists() then
    return dir:mkdirs()
  end
  return true
end

--- 重命名/移动文件（使用 Java File API）
function M.mv(src, dst)
  import "java.io.File"
  local f1 = File(src)
  local f2 = File(dst)
  return f1:renameTo(f2)
end

return M
