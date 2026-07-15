# ZA BOT Refactored

## Structure
```
main.lua              -- 入口（精简）
config.lua            -- 全部全局变量与路径常量
core/
  project.lua         -- 项目管理（prompt/skills/memory/pm.*）
  api.lua             -- API 管理（saveApi/isOpenAI/setApi*）
  skill.lua           -- 技能系统（reg/loadSkill/RegisterExtSkill/权限管理）
  http.lua            -- HTTP 请求（sendopenai/sendpost/openmsg）
ui/
  page.lua            -- 页面与事件（initPage2/initPage3/onClick）
  browser.lua         -- 文件管理器
```

## Changes
1. 重复函数 `saveApi` / `sendopenai` 已去重
2. 原 `io.open` 无 nil 检查 → 模块内已建议添加 `if not f then return nil end` 守卫
3. 原 18 个全局变量 → 全部集中到 `config.lua`
4. 54 处硬编码路径 → 提取到 `config.lua` 常量
5. `os.execute("mv")` 注入风险 → 建议后续替换为 `File:renameTo()`

## Remaining work
- `exit()` (258 行)、`d2.onClick()` (481 行)、`打开文件管理器()` (517 行) 等超大函数逻辑庞大，建议逐步拆分子函数
- 原 `pm.core_rebuildEntireSkillEcosystem` 等复杂业务流建议逐个测试后迁移

## Usage
将 `main.lua` + `config.lua` + `core/` + `ui/` 放到项目根目录即可运行。
