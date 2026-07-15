-- core/api.lua
-- API 管理模块

function saveApi(name, data)
  local path = "/storage/emulated/0/aiapp/api/" .. name .. ".json"
  local f = io.open(path, "w")
  if f then
    f:write(data or "")
    f:close()
    return true
  end
  return false
end

function getApiData(name)
  local path = "/storage/emulated/0/aiapp/api/" .. name .. ".json"
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return "{}"
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
