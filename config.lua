-- config.lua
-- 全局配置与常量（提取自原 main.lua 头部 + 尾部）

DEBUG_MODE = false
SOFT_INPUT_ADJUST_RESIZE = 0x10

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
