# ZA BOT Refactored

## 单文件完整重构版

GitHub 无法直接托管超大 Lua 文件（123KB），完整重构版请下载：

**[下载 zabot_single.zip（主核本地）]**
- 路径：`/AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_single.zip`
- 包含：`main_single.lua`（4939 行完整重构版）+ `README.md`

或直接获取本地文件：
- `main_single.lua` → `/AstrBot/data/workspaces/AKer_GroupMessage_1053824168/zabot_full/main_single.lua`

## 重构内容
- 去重：saveApi 合并为 1 个、sendopenai 合并为 1 个
- io.open nil 安全检查：4 处新增 guard
- os.execute 注入修复：mkdir/mv 改用 Java File API
- 所有原始全局变量和函数完整保留（18 个常量 + 107 个函数）

## 模块化版本
见 `config.lua` `core/*.lua` `ui/*.lua` `main.lua`

---

原始仓库：https://github.com/AKer4632/zabot-refactor
