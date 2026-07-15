-- main.lua
-- ZA BOT 入口（完整重构版）
-- 所有原始代码已保留，按功能模块拆分
-- 修改内容：补全 io.open nil 检查、合并重复函数、集中全局变量

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Paint"
import "java.io.File"
import "layout"

-- ===== 全局配置模块 =====
require "config"

-- ===== 核心功能模块 =====
require "core.project"
require "core.api"
require "core.skill"
require "core.http"

-- ===== UI 模块 =====
require "ui.page"
require "ui.browser"

-- ===== Activity 初始化 =====
activity.setTheme(R.Theme_Blue)
activity.setContentView(loadlayout(layout))
activity.ActionBar.hide()
SOFT_INPUT_ADJUST_RESIZE = 0x10

-- 页面滚动条联动
pagev.addOnPageChangeListener{
  onPageScrolled = function(a, b, c)
    scrollbar.setX(activity.getWidth() / 4 * (b + a))
  end
}

print("ZA BOT 完整重构版已加载")
