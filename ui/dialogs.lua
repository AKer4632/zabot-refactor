-- ui/dialogs.lua
-- AlertDialog 工厂：统一管理对话框创建，防止 Window Leaked

local M = {}
local _refs = {}

--- 创建 builder
function M.new(ctx)
  ctx = ctx or activity
  return AlertDialog.Builder(ctx)
end

--- 确认对话框
function M.confirm(ctx, title, msg, onYes, onNo)
  local b = M.new(ctx)
  b:setTitle(title or "提示")
  b:setMessage(msg or "")
  b:setPositiveButton("确定", {
    onClick = function(d)
      _refs[d] = nil
      if onYes then onYes() end
    end
  })
  b:setNegativeButton("取消", {
    onClick = function(d)
      _refs[d] = nil
      if onNo then onNo() end
    end
  })
  local d = b:create()
  _refs[d] = true
  d:show()
  return d
end

--- 清理所有对话框（在 activity onDestroy 中调用）
function M.dismissAll()
  for d, _ in pairs(_refs) do
    if d and d:isShowing() then
      d:dismiss()
    end
  end
  _refs = {}
end

return M
