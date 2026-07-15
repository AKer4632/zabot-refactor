-- core/io_safe.lua
-- 安全 IO 封装层：所有文件操作带 nil 检查和错误返回

local M = {}

--- 安全读取文件
-- @param path string 文件绝对路径
-- @return string|nil content 文件内容；失败返回 nil, err
function M.read(path)
  if type(path) ~= "string" or path == "" then
    return nil, "E_INVALID_PATH"
  end
  local f, err = io.open(path, "r")
  if not f then
    return nil, err or "E_OPEN_FAIL"
  end
  local content = f:read("*a")
  f:close()
  return content
end

--- 安全写入文件（覆盖）
-- @param path string
-- @param content string
-- @return boolean, string?
function M.write(path, content)
  if type(path) ~= "string" or path == "" then
    return false, "E_INVALID_PATH"
  end
  if type(content) ~= "string" then
    content = tostring(content)
  end
  local f, err = io.open(path, "w")
  if not f then
    return false, err or "E_OPEN_FAIL"
  end
  f:write(content)
  f:close()
  return true
end

--- 安全追加写入
function M.append(path, content)
  if type(path) ~= "string" or path == "" then
    return false, "E_INVALID_PATH"
  end
  local f, err = io.open(path, "a")
  if not f then
    return false, err or "E_OPEN_FAIL"
  end
  f:write(content or "")
  f:close()
  return true
end

--- 判断文件是否存在
function M.exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

return M
