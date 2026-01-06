-- imgui.lua (compat shim)
-- Provides table-style ImGui API for scripts that do: local ig = reaper.ImGui or require('imgui')

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
