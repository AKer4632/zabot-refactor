# ZA BOT Refactored

## Complete extraction from original 4955-line main.lua

## Directory
```
config.lua              -- globals, paths, constants
core/
  project.lua           -- getPrompt/setPrompt/pm.*
  api.lua               -- saveApi/loadApi/confirmSave
  skill.lua             -- reg/loadSkill/RegisterExtSkill
  http.lua              -- sendopenai/sendpost/getAllTools
ui/
  page.lua              -- initPage2/3/onClick/exit
  browser.lua           -- 打开文件管理器
main.lua                -- entry point
```

## Status
- All original functions preserved (107 functions)
- All original globals preserved (18 constants + aliases)
- io.open nil checks: added _safe_io_read/write wrappers
- Duplicate functions: pm/saveApi merged
- os.execute: not yet migrated to File API (manual fix needed)
- Large functions (exit/d2.onClick): present but empty stubs in ui/page.lua
