-- @description IFLS_Toolbar_Suite: Diagnostics (paths + ImGui)
-- @version 1.0.0
-- @author IfeelLikeSnow

local r = reaper
r.ClearConsole()

local function msg(s) r.ShowConsoleMsg(tostring(s) .. "\n") end

msg("== IFLS_Toolbar_Suite Diagnostics ==")
msg("ResourcePath: " .. r.GetResourcePath())
msg("ImGui_CreateContext: " .. tostring(r.ImGui_CreateContext))
msg("reaper.ImGui table: " .. tostring(r.ImGui))

local ok, ig = pcall(require, "imgui")
msg("require('imgui'): " .. tostring(ok) .. " / " .. tostring(ig))

-- Show first chunk of package.path for debugging
msg("package.path (head): " .. tostring(package.path):sub(1, 220) .. "...")
