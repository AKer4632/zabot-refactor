-- core/project_manager.lua
-- 项目管理器：合并原 pm 模块所有重复定义，提供统一接口

local io_safe = require "core.io_safe"
local config = require "config"
local M = {}

-- hooks
M.onBeforeSwitch = nil
M.onAfterSwitch = nil
M.onSkillLoad = nil
M.onSkillUnload = nil
M.onError = nil
M.onStatusChange = nil

--- 安全触发 hook
function M.fireHook(name, ...)
  local hook = M[name]
  if type(hook) == "function" then
    return pcall(hook, ...)
  end
  return true
end

--- 获取项目提示词
function M.getPrompt(name)
  return io_safe.read(config.PROJECT_ROOT .. name .. "/prompt.txt") or ""
end

--- 写入提示词
function M.setPrompt(name, content)
  return io_safe.write(config.PROJECT_ROOT .. name .. "/prompt.txt", content or "")
end

--- 获取技能列表
function M.getSkills(name)
  return io_safe.read(config.PROJECT_ROOT .. name .. "/skills.txt") or ""
end

--- 写入技能列表
function M.setSkills(name, content)
  return io_safe.write(config.PROJECT_ROOT .. name .. "/skills.txt", content or "")
end

--- 获取记忆
function M.getMemory(name)
  return io_safe.read(config.PROJECT_ROOT .. name .. "/memory.txt") or ""
end

--- 追加记忆
function M.addMemory(name, content)
  return io_safe.append(config.PROJECT_ROOT .. name .. "/memory.txt", (content or "") .. "\n")
end

--- 覆盖记忆
function M.setMemory(name, content)
  return io_safe.write(config.PROJECT_ROOT .. name .. "/memory.txt", content or "")
end

--- 清除记忆
function M.clearMemory(name)
  return M.setMemory(name, "")
end

--- 删除包含特定文本的记忆行
function M.deleteMemoryLine(name, lineContains)
  local mem = M.getMemory(name)
  if mem == "" then return true end
  local lines = {}
  for line in mem:gmatch("[^\r\n]+") do
    if not line:find(lineContains, 1, true) then
      lines[#lines+1] = line
    end
  end
  return M.setMemory(name, table.concat(lines, "\n"))
end

--- 列出所有子项目
function M.listProjects()
  import "java.io.File"
  local dir = File(config.PROJECT_ROOT)
  local list = {}
  if dir:exists() and dir:isDirectory() then
    local files = dir:listFiles()
    for i = 0, files.length - 1 do
      local f = files[i]
      if f:isDirectory() then
        list[#list+1] = tostring(f:getName())
      end
    end
  end
  return list
end

--- 切换项目（带 hook）
function M.switchProject(newName)
  if type(newName) ~= "string" or newName == "" then
    return false, "E_INVALID_NAME"
  end
  M.fireHook("onBeforeSwitch", newName)
  config.activeSub = newName
  M.fireHook("onAfterSwitch", newName)
  return true
end

return M
