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

import "java.io.File"

local _SYS = {}

local FORBIDDEN = {
  ["su"] = true
}

local function _exec(cmd)
  local bin = cmd:match("^(%S+)")
  if FORBIDDEN[bin] then
    return false, "E_PERM: su is permanently disabled"
  end

  local p = Runtime.getRuntime():exec(cmd)
  local rd = BufferedReader(InputStreamReader(p.getInputStream()))
  local err = BufferedReader(InputStreamReader(p.getErrorStream()))

  local out, e = {}, {}
  for l in rd.readLine do out[#out+1]=l end
  for l in err.readLine do e[#e+1]=l end

  p.waitFor()
  rd.close(); err.close()

  return true,
  table.concat(out,"\n"),
  table.concat(e,"\n"),
  p.exitValue()
end

_SYS.exec = _exec

SYS_ALL = {
  test_toast = true, http_get = true, http_post = true,
  shell_exec = true, add_memory = true, memory_delete = true,
  file_write = true, file_read = true, file_delete = true,
  查询可用项目 = true, 切换项目 = true, 开启网页 = true,
  sys_exec = true, sys_sh = true,
}

subProjects = subProjects or {}
activeSub = activeSub or nil
EXT_REGISTRY = EXT_REGISTRY or {}
EXT_ALLOWED = EXT_ALLOWED or {}
toolDefinitions = toolDefinitions or {}
toolHandlers = toolHandlers or {}

PROJECT_ROOT = "/storage/emulated/0/aiapp/project/"

ProjectManager = {
  onBeforeSwitch = nil,
  onAfterSwitch = nil,
  onSkillLoad = nil,
  onSkillUnload = nil,
  onError = nil,
  onStatusChange = nil,
}

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
  local path = PROJECT_ROOT .. projectName
  local dir = File(path)
  if dir:exists() then
    os.execute("rm -rf " .. path)
  end
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

-- 页面初始化等 UI 代码
title = title or {}
tab1 = tab1 or {}
pagev = pagev or {}
tab2 = tab2 or {}
btn3 = btn3 or {}
pop1 = pop1 or {}
pop2 = pop2 or {}
tab3 = tab3 or {}
initPage3 = initPage3 or function() end
pop3 = pop3 or {}
tab4 = tab4 or {}
pop4 = pop4 or {}
scrollbar = scrollbar or {}
activity = activity or {}
