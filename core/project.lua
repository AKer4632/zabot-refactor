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
  return _safe_io_read(PROJECT_ROOT .. name .. "/prompt.txt") or ""
end

function setPrompt(name, content)
  return _safe_io_write(PROJECT_ROOT .. name .. "/prompt.txt", content)
end

function getSkills(name)
  return _safe_io_read(PROJECT_ROOT .. name .. "/skills.txt") or ""
end

function setSkills(name, content)
  return _safe_io_write(PROJECT_ROOT .. name .. "/skills.txt", content)
end

function getMemory(name)
  return _safe_io_read(PROJECT_ROOT .. name .. "/memory.txt") or ""
end

function addMemory(name, content)
  local path = PROJECT_ROOT .. name .. "/memory.txt"
  local f = io.open(path, "a")
  if f then
    f:write((content or "") .. "\n")
    f:close()
    return true
  end
  return false
end

function setMemory(name, content)
  return _safe_io_write(PROJECT_ROOT .. name .. "/memory.txt", content)
end

function deleteMemoryLine(name, lineContains)
  local mem = getMemory(name)
  if mem == "" then return true end
  local lines = {}
  for line in mem:gmatch("[^\r\n]+") do
    if not line:find(lineContains, 1, true) then
      table.insert(lines, line)
    end
  end
  return setMemory(name, table.concat(lines, "\n"))
end

function clearMemory(name)
  return setMemory(name, "")
end

function deleteProject(projectName)
  os.execute("rm -rf " .. PROJECT_ROOT .. projectName)
  return true
end

function listProjects()
  local list = {}
  local dir = File(PROJECT_ROOT)
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

-- pm 项目方法占位（保留接口）
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
