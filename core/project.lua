-- core/project.lua
-- 自动重构模块

-- ===== 安全 IO 辅助函数（防止 nil 崩溃）=====
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

function getPrompt(name)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/prompt.txt"
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return ""
end

-- 写入提示词
function setPrompt(name, content)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/prompt.txt"
  local f = io.open(path, "w")
  if f then
    f:write(content or "")
    f:close()
    return true
  end
  return false
end

function getSkills(name)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/skills.txt"
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return ""
end

function setSkills(name, content)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/skills.txt"
  local f = io.open(path, "w")
  if f then
    f:write(content or "")
    f:close()
    return true
  end
  return false
end

function getMemory(name)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/memory.txt"
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return ""
end

function addMemory(name, content)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/memory.txt"
  local f = io.open(path, "a")
  if f then
    f:write((content or "") .. "\n")
    f:close()
    return true
  end
  return false
end

function setMemory(name, content)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/memory.txt"
  local f = io.open(path, "w")
  if f then
    f:write(content or "")
    f:close()
    return true
  end
  return false
end

function deleteMemoryLine(name, lineContains)
  local path = "/storage/emulated/0/aiapp/project/" .. name .. "/memory.txt"
  local f = io.open(path, "r")
  if not f then return false end
  local content = f:read("*a")
  f:close()
  if content == "" then return true end
  local lines = {}
  for line in content:gmatch("[^\r\n]+") do
    if not line:find(lineContains, 1, true) then
      table.insert(lines, line)
    end
  end
  f = io.open(path, "w")
  if f then
    f:write(table.concat(lines, "\n"))
    f:close()
    return true
  end
  return false
end

function clearMemory(name)
  return setMemory(name, "")
end

function deleteProject(projectName)
  -- 保留原有逻辑
  local path = "/storage/emulated/0/aiapp/project/" .. projectName
  local dir = File(path)
  if dir:exists() then
    -- 递归删除保留
    os.execute("rm -rf " .. path)
  end
  return true
end

function listProjects()
  local list = {}
  local dir = File("/storage/emulated/0/aiapp/project/")
  if dir:exists() and dir:isDirectory() then
    local files = dir:listFiles()
    for i = 0, files.length - 1 do
      local f = files[i]
      if f:isDirectory() then
        table.insert(list, tostring(f:getName()))
      end
    end
  end
  return list
end

-- pm 方法占位（保留接口名）
pm = {}
pm.core_rebuildEntireSkillEcosystem = function() end
pm.op_migratePrimaryProjectAnchor = function() end
pm.op_rotateActiveSubProject = function() end
pm.op_overwriteSubProjectStack = function() end
pm.op_purgeSubProjectStack = function() end
pm.query_resolvePrimaryProjectAnchor = function() return "" end
pm.query_resolveSubProjectStack = function() return {} end
pm.query_resolveActiveSubProjectNode = function() return nil end
pm.query_auditRegisteredSkillCardinality = function() return 0 end
pm.query_snapshotProjectRuntimeContext = function() return {} end
pm.ui_summonProjectMigrationWizard = function() end
pm.ui_summonSubProjectRotator = function() end
pm.ui_summonProjectRuntimeSnapshot = function() end
pm.op_commitFullProjectContextSwap = function() end

-- 模块结束 =====
