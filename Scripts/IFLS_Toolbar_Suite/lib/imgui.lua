-- imgui.lua (IFLS_Toolbar_Suite shim)
-- Provides a table-style ImGui API via `require("imgui")` by proxying to ReaImGui's `reaper.ImGui_*` functions.
-- This allows legacy code to use `ig.X()` style calls while ReaImGui exposes `reaper.ImGui_X()`.

local r = reaper
if not (r and type(r.ImGui_CreateContext) == "function") then
  error("ReaImGui extension not loaded. Install ReaImGui via ReaPack (ReaTeam Extensions) and restart REAPER.")
end

local M = {}
setmetatable(M, {
  __index = function(_, key)
    local fn = r["ImGui_" .. key]
    if type(fn) == "function" then return fn end
    return nil
  end
})

return M
