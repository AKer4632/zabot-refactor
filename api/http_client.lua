-- api/http_client.lua
-- HTTP 请求封装（带 pcall 错误守卫）

local M = {}

--- GET 请求
function M.get(url, headers)
  if type(url) ~= "string" then
    return nil, "E_INVALID_URL"
  end
  local ok, res = pcall(function()
    return Http.get(url, headers)
  end)
  if not ok then
    return nil, tostring(res)
  end
  return res
end

--- POST 请求
function M.post(url, data, headers)
  if type(url) ~= "string" then
    return nil, "E_INVALID_URL"
  end
  local ok, res = pcall(function()
    return Http.post(url, data, headers)
  end)
  if not ok then
    return nil, tostring(res)
  end
  return res
end

return M
