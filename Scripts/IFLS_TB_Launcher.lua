-- @description IFLS_Toolbar_Suite: Launcher (compat wrapper)
-- @version 1.0.4
-- @author IfeelLikeSnow
-- @about Wrapper so older Action-list entries like "IFLS_TB_Launcher.lua" keep working.

local r = reaper

local function get_self_dir()
  local ok, _, script_file = pcall(r.get_action_context)
  if ok and script_file and script_file ~= "" then
    return (script_file:match("^(.*[\\/])") or "")
  end
  local src = debug.getinfo(1, "S").source
  if src:sub(1,1) == "@" then src = src:sub(2) end
  return (src:match("^(.*[\\/])") or "")
end

local function try(path)
  local f = io.open(path, "rb")
  if f then f:close(); return true end
  return false
end

local self_dir = get_self_dir():gsub("\\","/")
local candidates = {
  self_dir .. "IFLS_Toolbar_Suite/entry/IFLS_TB_Launcher.lua",
  (r.GetResourcePath():gsub("\\","/")) .. "/Scripts/IFLS_Toolbar_Suite/entry/IFLS_TB_Launcher.lua",
}

local target
for _, p in ipairs(candidates) do
  if try(p) then target = p break end
end

if not target then
  r.MB("Launcher not found. Tried:\n- " .. table.concat(candidates, "\n- "), "IFLS_Toolbar_Suite", 0)
  return
end

dofile(target)
