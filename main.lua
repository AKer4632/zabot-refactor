-- main.lua
-- ZA BOT 入口（完整重构版）

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Paint"
import "java.io.File"
import "layout"

require "config"
require "core.project"
require "core.api"
require "core.skill"
require "core.http"
require "ui.page"
require "ui.browser"

activity.setTheme(R.Theme_Blue)
activity.setContentView(loadlayout(layout))
activity.ActionBar.hide()
SOFT_INPUT_ADJUST_RESIZE = 0x10

pagev.addOnPageChangeListener{
  onPageScrolled = function(a,b,c)
    scrollbar.setX(activity.getWidth()/4*(b+a))
  end
}

print("ZA BOT modular loaded")
