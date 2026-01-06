-- @description IFLS_Toolbar_Suite: Beat Control Center (Entry)
-- @version 1.0.0
-- @author IfeelLikeSnow

local r = reaper

-- get this script path (best in REAPER)
local ok_ctx, _, script_file = pcall(r.get_action_context)
if not ok_ctx or not script_file or script_file == "" then
  local src = debug.getinfo(1, "S").source
  script_file = (type(src) == "string" and src:sub(1,1) == "@") and src:sub(2) or src
end
local script_dir = script_file and script_file:match("^(.*[\\/])") or nil
if not script_dir then
  r.MB("Cannot resolve script directory.", "IFLS_Toolbar_Suite", 0)
  return
end

local suite_root = (script_dir .. "../"):gsub("\\", "/") -- .../Scripts/IFLS_Toolbar_Suite/

-- add suite-local requires first
local function add_pkg(dir)
  dir = dir:gsub("\\","/"):gsub("/+$","")
  package.path = dir .. "/?.lua;" .. dir .. "/?/init.lua;" .. package.path
end
add_pkg(suite_root .. "lib")
add_pkg(suite_root .. "Core")
add_pkg(suite_root .. "Domain")
add_pkg(suite_root .. "tools")
add_pkg(suite_root .. "hubs")

-- real ReaImGui check
if type(r.ImGui_CreateContext) ~= "function" then
  r.MB("ReaImGui extension not loaded.\nInstall ReaImGui via ReaPack and restart REAPER.", "IFLS_Toolbar_Suite", 0)
  return
end

-- optional shim (table-style API)
if type(r.ImGui) ~= "table" then
  local ok, ig = pcall(require, "imgui")
  if ok and type(ig) == "table" then r.ImGui = ig end
end

-- load hub (try both casings)
local candidates = {
  suite_root .. "hubs/IFLS_BeatControlCenter_ImGui.lua",
  suite_root .. "Hubs/IFLS_BeatControlCenter_ImGui.lua",
}
local hub
for _, p in ipairs(candidates) do
  local f = io.open(p, "rb")
  if f then f:close(); hub = p; break end
end

if not hub then
  r.MB("Hub not found.\nTried:\n- " .. table.concat(candidates, "\n- "), "IFLS_Toolbar_Suite", 0)
  return
end

local ok, err = xpcall(function() dofile(hub) end, debug.traceback)
if not ok then
  r.ShowConsoleMsg("[IFLS] Hub crash:\n" .. tostring(err) .. "\n")
end
