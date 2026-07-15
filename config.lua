-- config.lua
-- 全局配置与路径常量
-- 集中管理，避免硬编码散落

local M = {}

M.DEBUG_MODE = false

-- 路径常量（唯一数据源）
M.PROJECT_ROOT = "/storage/emulated/0/aiapp/project/"
M.SYS_CFG_DIR = "/storage/emulated/0/aiapp/setting/"
M.BASE_STORAGE = "/storage/emulated/0/aiapp/"

-- 权限开关
M.SYS_ALL = {
  test_toast = true,
  http_get = true,
  http_post = true,
  shell_exec = true,
  add_memory = true,
  memory_delete = true,
  file_write = true,
  file_read = true,
  file_delete = true,
  ["查询可用项目"] = true,
  ["切换项目"] = true,
  ["开启网页"] = true,
  sys_exec = true,
  sys_sh = true,
}

-- 子项目状态（惰性初始化）
M.subProjects = {}
M.activeSub = nil
M.EXT_REGISTRY = {}
M.EXT_ALLOWED = {}

-- 最大工具轮次
M.MAX_TOOL_ROUNDS = 10

-- FORBIDDEN binaries
M.FORBIDDEN = {
  ["su"] = true
}

return M
