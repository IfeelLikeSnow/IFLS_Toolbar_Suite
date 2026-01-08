-- @description IFLS_Toolbar_Suite: FX Param Index (stable)
-- Provides lightweight TSV parsing + param index utilities used by FXBrain/diagnostics.
local M = {}

local function split_tab(line)
  local out = {}
  local i = 1
  for field in (line .. "\t"):gmatch("([^\t]*)\t") do
    out[i] = field
    i = i + 1
  end
  return out
end

function M.parse_tsv(tsv_text)
  if type(tsv_text) ~= "string" then return {} end
  local rows = {}
  local header
  for line in (tsv_text .. "\n"):gmatch("([^\n]*)\n") do
    if line ~= "" then
      if not header then
        header = split_tab(line)
      else
        local cols = split_tab(line)
        local row = {}
        for i=1, math.max(#header, #cols) do
          row[header[i] or ("col"..i)] = cols[i] or ""
        end
        rows[#rows+1] = row
      end
    end
  end
  return rows
end

-- Convenience: build index by FX name -> list of params
function M.index_by_fx(rows)
  local idx = {}
  for _, r in ipairs(rows or {}) do
    local fx = r.FX or r.fx or r.Fx or r["FX Name"] or ""
    if fx ~= "" then
      idx[fx] = idx[fx] or {}
      idx[fx][#idx[fx]+1] = r
    end
  end
  return idx
end

return M
