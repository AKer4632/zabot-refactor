-- core/api.lua
-- API 管理模块

local function _safe_io_read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local c = f:read("*a")
  f:close()
  return c
end
local function _safe_io_write(path, content)
  local f = io.open(path, "w")
  if not f then return false end
  f:write(content or "")
  f:close()
  return true
end

function saveApi(name, data)
  local path = "/storage/emulated/0/aiapp/api/" .. name .. ".json"
  return _safe_io_write(path, data)
end

function getApiData(name)
  local path = "/storage/emulated/0/aiapp/api/" .. name .. ".json"
  return _safe_io_read(path) or "{}"
end

function setApiName(name, value) end
function setApiru(name, value) end
function setApicu(name, value) end
function setApiUrl(name, value) end
function setApimethod(name, value) end
function setApiType(name, value) end
function setOpenAIKey(name, value) end
function setOpenAIModel(name, value) end
function setApiParam(name, key, value) end
function removeApiParam(name, key) end
function isOpenAI(name) return false end
function listApis()
  return {}
end
function loadApi(name)
  return {}
end
function deleteApi(name) return true end
function selectApiType(name) end
function selectHttpMethod(name) end
function inputHttpUrl(name, url) end
function manageParams(name) end
function editParam(name, key, value) end
function inputOpenAIUrl(name, url) end
function inputOpenAIKey(name, key) end
function inputOpenAIModel(name, model) end
function confirmSave(name) return true end
function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

-- 模块结束 =====
