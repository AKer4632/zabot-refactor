# ZA BOT Refactored

## Directory
```
main.lua              -- Entry, slimmed to <300 lines
config.lua            -- All globals/paths in one place
core/
  io_safe.lua         -- Safe file ops with nil checks
core/
  shell_safe.lua      -- Safe exec (forbidden su, Java File API)
core/
  project_manager.lua -- Merged pm methods, no duplicates
ui/
  dialogs.lua         -- AlertDialog factory with ref cache
api/
  http_client.lua     -- HTTP with pcall guards
```

## Fixed Issues
1. io.open nil crashes  -> io_safe.read/write/append
2. os.execute injection -> Java File API for mv/mkdir
3. Duplicate func defs   -> Merged in project_manager
4. Globals scattered    -> Centralized in config.lua
5. Hardcoded paths      -> Extracted to config constants
6. Dialog leaks         -> Reference cache + dismissAll

## Migration Guide
1. Copy all files into your project directory
2. Replace old main.lua with this main.lua
3. Move large UI handlers (initPage2/3, exit, onClick) into ui/pages.lua
4. Keep original Lua syntax for AndroLua+ compatibility
