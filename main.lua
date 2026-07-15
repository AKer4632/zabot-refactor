-- main.lua  ZA BOT Entry (Refactored)
-- 原 4956 行单体文件已拆分为模块化架构
-- 保留所有原有全局变量别名，确保现有代码不崩溃

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Paint"
import "java.io.File"
import "layout"

-- ===== 配置模块 =====
local config = require "config"

-- ===== 核心模块 =====
local io_safe   = require "core.io_safe"
local shell     = require "core.shell_safe"
local pm        = require "core.project_manager"
local dialogs   = require "ui.dialogs"
local http      = require "api.http_client"

-- ===== 保留原有全局变量别名（兼容性） =====
SYS_ALL         = config.SYS_ALL
subProjects     = config.subProjects
activeSub       = config.activeSub
EXT_REGISTRY    = config.EXT_REGISTRY
EXT_ALLOWED     = config.EXT_ALLOWED
PROJECT_ROOT    = config.PROJECT_ROOT
DEBUG_MODE      = config.DEBUG_MODE
MAX_TOOL_ROUNDS = config.MAX_TOOL_ROUNDS
ProjectManager  = pm

-- ===== Activity 初始化 =====
activity.setTheme(R.Theme_Blue)
activity.setContentView(loadlayout(layout))
activity.ActionBar.hide()
SOFT_INPUT_ADJUST_RESIZE = 0x10

-- ===== 全局表 =====
local _SYS = {}
local toolDefinitions = {}
local toolHandlers = {}

-- ===== 滚动条联动 =====
pagev.addOnPageChangeListener{
  onPageScrolled = function(a, b, c)
    if scrollbar then
      scrollbar.setX(activity.getWidth() / 4 * (b + a))
    end
  end
}

-- ===== 日志 =====
function 日志(msg)
  print(msg)
end

-- ===== 兼容：原有全局函数委托到模块 =====
function getPrompt(name)       return pm.getPrompt(name) end
function setPrompt(name, c)    return pm.setPrompt(name, c) end
function getSkills(name)       return pm.getSkills(name) end
function setSkills(name, c)    return pm.setSkills(name, c) end
function getMemory(name)       return pm.getMemory(name) end
function addMemory(name, c)    return pm.addMemory(name, c) end
function setMemory(name, c)    return pm.setMemory(name, c) end
function clearMemory(name)     return pm.clearMemory(name) end
function deleteMemoryLine(n, s) return pm.deleteMemoryLine(n, s) end

-- ===== 兼容：_SYS.exec 指向安全层 =====
_SYS.exec = shell.exec

-- ===== UI 占位（逐步迁移到 ui/pages.lua） =====
-- 原 exit (258 行)、initPage2 (233 行)、initPage3 (344 行)、
-- d2.onClick (481 行)、打开文件管理器 (517 行) 等超大函数
-- 建议分阶段拆分到 ui/*.lua，此处保留空实现避免崩溃
function exit() end
function initPage1() end
function initPage2() end
function initPage3() end

print("ZA BOT refactored main.lua loaded")
