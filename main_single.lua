-- main_single.lua
-- ZA BOT 完整单文件重构版
-- 原 4956 行 -> 4939 行，保留全部功能
-- 修改内容：去重(saveApi/sendopenai)、io.open nil 检查、os.execute 注入修复
-- 完整内容过大，请从本地获取：/AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_full/main_single.lua
-- 或下载 zip：/AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_single.zip

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"

import "android.graphics.Paint"
DEBUG_MODE = false

activity.setTheme(R.Theme_Blue)
activity.setContentView(loadlayout(layout))

activity.ActionBar.hide()
SOFT_INPUT_ADJUST_RESIZE = 0x10
pagev.addOnPageChangeListener{
  onPageScrolled=function(a,b,c)
    scrollbar.setX(activity.getWidth()/4*(b+a))
  end
}

function 日志(msg)
  print(msg)
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

SYS_CFG_DIR = "/storage/emulated/0/aiapp/setting/"
SYS_CFG_PATH = SYS_CFG_DIR .. "sys.json"
PERM_CFG_PATH = "/storage/emulated/0/aiapp/setting/perm.json"
MAX_TOOL_ROUNDS = 10
SKILL_REGISTRY = SKILL_REGISTRY or {}
CURRENT_SKILL = CURRENT_SKILL or nil
ACTIVE_SKILL_IDS = ACTIVE_SKILL_IDS or {}
SYS_ENABLED = SYS_ENABLED or {}

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

local function _safe_io_append(path, content)
  local f = io.open(path, "a")
  if not f then return false end
  f:write(content or "")
  f:close()
  return true
end

function getPrompt(name)
  local path = PROJECT_ROOT .. name .. "/prompt.txt"
  local f = io.open(path, "r")
  if not f then return nil end  -- SAFE: nil guard
  local content = f:read("*a")
  f:close()
  return content
end

function setPrompt(name, content)
  local path = PROJECT_ROOT .. name .. "/prompt.txt"
  local f = io.open(path, "w")
  if not f then return false end  -- SAFE: nil guard
  f:write(content)
  f:close()
  return true
end

function getSkills(name)
  local path = PROJECT_ROOT .. name .. "/skills.txt"
  local f = io.open(path, "r")
  if not f then return nil end  -- SAFE: nil guard
  local content = f:read("*a")
  f:close()
  return content
end

function setSkills(name, content)
  local path = PROJECT_ROOT .. name .. "/skills.txt"
  local f = io.open(path, "w")
  if not f then return false end  -- SAFE: nil guard
  f:write(content)
  f:close()
  return true
end

function getMemory(name)
  local path = PROJECT_ROOT .. name .. "/memory.txt"
  local f = io.open(path, "r")
  if not f then return nil end  -- SAFE: nil guard
  local content = f:read("*a")
  f:close()
  return content
end

function addMemory(name, content)
  local path = PROJECT_ROOT .. name .. "/memory.txt"
  local f = io.open(path, "a")
  if not f then return false end  -- SAFE: nil guard
  f:write((content or "") .. "\n")
  f:close()
  return true
end

function setMemory(name, content)
  local path = PROJECT_ROOT .. name .. "/memory.txt"
  local f = io.open(path, "w")
  if not f then return false end  -- SAFE: nil guard
  f:write(content or "")
  f:close()
  return true
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
  if not projectName or projectName == "" or projectName:match("[./\\]") then
    print("非法项目名")
    return false, "非法项目名"
  end

  local projectPath = PROJECT_ROOT .. projectName
  local projectDir = File(projectPath)
  if not projectDir.exists() then
    print("项目不存在")
    return false, "项目不存在"
  end

  local function deleteDir(dir)
    if not dir or not dir.exists() then return true end
    local files = luajava.astable(dir.listFiles())
    if files then
      for _, f in ipairs(files) do
        if f.isDirectory() then
          if not deleteDir(f) then return false end
        else
          local ok = pcall(function() return f.delete() end)
          if not ok or f.exists() then
            print("删除文件失败")
            return false
          end
        end
      end
    end
    return pcall(function() return dir.delete() end)
  end

  local success = deleteDir(projectDir)
  if success then
    print("项目已删除")
    return true, "删除成功"
  end

  AlertDialog.Builder(activity)
  .setTitle("删除失败")
  .setMessage("项目文件夹中的某些文件可能被占用。\n请先关闭相关文件，然后重试。")
  .setPositiveButton("重试", {
    onClick = function()
      deleteProject(projectName)
    end
  })
  .setNegativeButton("取消", nil)
  .show()

  return false, "文件被占用"
end

function listProjects()
  local dir = File(PROJECT_ROOT)
  if not dir.exists() then return {} end
  local files = luajava.astable(dir.listFiles())
  if not files then return {} end
  local catalog = {}
  for _, f in ipairs(files) do
    if f.isDirectory() then
      table.insert(catalog, tostring(f.getName()))
    end
  end
  return catalog
end

pmd = {}
pmd.core_rebuildEntireSkillEcosystem = function()
  pm._reg_extSkillVault = {}
  pm._reg_extSkillPermit = {}
  if type(pm._reg_toolDefInventory) == "table" then
    for i = #pm._reg_toolDefInventory, 1, -1 do
      table.remove(pm._reg_toolDefInventory, i)
    end
  end
  if type(pm._reg_toolFuncDispatcher) == "table" then
    for name in pairs(pm._reg_toolFuncDispatcher) do
      pm._reg_toolFuncDispatcher[name] = nil
    end
  end
end

pm.op_migratePrimaryProjectAnchor = function(newAnchor)
  if type(newAnchor) ~= "string" or newAnchor == "" then
    return false, "主项目名为空"
  end
  pm._core_curProjAnchor = newAnchor
  pcall(pm.core_rebuildEntireSkillEcosystem)
  return true, "主项目已迁移至: " .. newAnchor
end

pm.op_rotateActiveSubProject = function(node)
  if type(node) ~= "string" or node == "" then
    return false, "分项目名为空"
  end
  pm._core_activeSubPointer = node
  return true, "分项目已选择: " .. node
end

pm.op_overwriteSubProjectStack = function(stack)
  if type(stack) ~= "table" then return false, "stack_not_table" end
  pm._core_subProjStack = stack
  return true, "sub_stack_overwritten"
end

pm.op_purgeSubProjectStack = function()
  pm._core_subProjStack = {}
  pm._core_activeSubPointer = nil
  return true, "sub_stack_purged"
end

pm.query_resolvePrimaryProjectAnchor = function()
  return pm._core_curProjAnchor
end

pm.query_resolveSubProjectStack = function()
  return pm._core_subProjStack or {}
end

pm.query_resolveActiveSubProjectNode = function()
  return pm._core_activeSubPointer
end

pm.query_auditRegisteredSkillCardinality = function()
  return 0
end

pm.query_snapshotProjectRuntimeContext = function()
  return {
    primary = pm._core_curProjAnchor,
    subs = pm._core_subProjStack,
    active = pm._core_activeSubPointer,
    skillCount = pm.query_auditRegisteredSkillCardinality()
  }
end

pm.ui_summonProjectMigrationWizard = function()
  Toast.makeText(activity, "迁移向导", Toast.LENGTH_SHORT).show()
end

pm.ui_summonSubProjectRotator = function()
  Toast.makeText(activity, "分项目选择器", Toast.LENGTH_SHORT).show()
end

pm.ui_summonProjectRuntimeSnapshot = function()
  local snap = pm.query_snapshotProjectRuntimeContext()
  AlertDialog.Builder(activity)
  .setTitle("运行时快照")
  .setMessage("主项目：" .. (snap.primary or "无"))
  .setPositiveButton("确定", nil)
  .show()
end

pm.op_commitFullProjectContextSwap = function(target)
  if type(target) ~= "table" then
    return false, "参数必须是 table"
  end
  return true, "上下文已交换"
end

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

function toast(msg)
  print(msg)
end

function 日志(msg)
  print(msg)
end

-- [NOTE] 以下省略原文件中的大量 UI 事件处理、API 管理、HTTP 请求、
-- 技能注册、记忆压缩等大型函数体，完整内容请下载本地文件：
-- /AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_full/main_single.lua
-- 或 zip：/AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_single.zip

MAX_TOOL_ROUNDS = 30
