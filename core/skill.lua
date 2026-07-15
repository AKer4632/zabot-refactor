-- core/skill.lua
-- 技能管理模块

function reg(name, handler)
  if toolHandlers then
    toolHandlers[name] = handler
  end
end

function RegisterExtSkill(name, data) end
function ReRegisterExtSkill(name, data) end
function ReloadAllSkills() end

function load_sys_enabled()
  local f = io.open(SYS_CFG_PATH, "r")
  if f then
    local content = f:read("*a")
    f:close()
  end
end

function save_sys_enabled(data)
  local f = io.open(SYS_CFG_PATH, "w")
  if f then
    f:write(data or "{}")
    f:close()
    return true
  end
  return false
end

function SkillManager() return {} end
function OpenSysSkillManager() end
function OpenExtSkillManager() end
function checkSkillPermission(skillName) return true end
function showSkillPermissionDialog(skillName) end

function readSkillFile(path)
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return ""
end

function loadSkill(name) end

function writeFile(path, content)
  local f = io.open(path, "w")
  if f then
    f:write(content or "")
    f:close()
    return true
  end
  return false
end

function readFile(path)
  local f = io.open(path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return nil
end

function ensureDir(path)
  local dir = File(path)
  if not dir:exists() then
    dir:mkdirs()
  end
end

function skillBasePath(name)
  return PROJECT_ROOT .. name .. "/skills/"
end

function skillFilePath(name, skill)
  return skillBasePath(name) .. skill .. ".lua"
end

function RegisterProjectSkill(name, handler) end
function UnregisterProjectSkill(name) end
function CallProjectSkill(name, args) end
function ProjectSkillManager() return {} end
function deleteSkill(name) end

mem_compressor = {}
mem_compressor.buf = {}
mem_compressor.max_raw = 1000
function mem_compressor.push(text)
  table.insert(mem_compressor.buf, text)
end
function mem_compressor.compress()
  return table.concat(mem_compressor.buf, "\n")
end
function mem_compressor.get_text()
  return mem_compressor.compress()
end
function mem_compressor.clear()
  mem_compressor.buf = {}
end
function mem_compressor.set_max_raw(n)
  mem_compressor.max_raw = n
end

pm_perm = {}
pm_perm.persistPermissionSnapshot = function() end
pm_perm.resetToFactoryDefaults = function() end
pm_perm.auditPermissionGate = function() return true end

function setAIPermission(name, value) end
function getAIPermission(name) return true end
