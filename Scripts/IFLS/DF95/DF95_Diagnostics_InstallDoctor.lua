-- DF95_Diagnostics_InstallDoctor.lua (V3)
-- Interactive dependency helper: detects missing extensions and offers install hints.
local r = reaper

local function norm(s) return (s or ""):gsub("\\","/") end
local function join(a,b,c,d,e) return table.concat({a,b,c,d,e}, "/"):gsub("/+","/") end
local base = norm(r.GetResourcePath())

local Caps = dofile(join(base,"Scripts","DF95Framework","Lib","DF95_Capabilities.lua"))

local LINKS = {
  sws = "https://www.sws-extension.org/",
  reapack = "https://reapack.com/",
  reaimgui = "https://github.com/cfillion/reaimgui",
  js_reascriptapi = "https://github.com/juliansader/ReaExtensions",
}

local DESCR = {
  sws = "SWS/S&M Extension",
  reapack = "ReaPack package manager",
  reaimgui = "ReaImGui (Dear ImGui binding)",
  js_reascriptapi = "js_ReaScriptAPI (ReaScript API extension)",
}

local function open_url(url)
  if type(r.CF_ShellExecute) == "function" then
    r.CF_ShellExecute(url)
    return true
  end
  return false
end

local function msg(txt, title, t)
  r.ShowMessageBox(txt, title or "DF95 Install Doctor", t or 0)
end


local JSON = dofile(join(base,"Scripts","IFLS","DF95","Core","DF95_JSON.lua"))

local function read_config_reapack_url()
  local cfg_path = join(r.GetResourcePath(), "Support", "DF95_Config.json")
  local f = io.open(cfg_path, "r")
  if not f then return nil end
  local s = f:read("*a"); f:close()
  local ok, cfg = pcall(JSON.decode, s)
  if not ok or type(cfg) ~= "table" then return nil end
  if type(cfg.reapack) == "table" and type(cfg.reapack.df95_repo_index_url) == "string" and cfg.reapack.df95_repo_index_url ~= "" then
    return cfg.reapack.df95_repo_index_url
  end
  return nil
end

local caps = Caps.detect()
local missing = {}
for _,k in ipairs({"sws","reapack","reaimgui","js_reascriptapi"}) do
  if not caps[k] then missing[#missing+1] = k end
end

r.ClearConsole()
r.ShowConsoleMsg("DF95 Install Doctor\n===================\n")
for _,k in ipairs({"sws","reapack","reaimgui","js_reascriptapi"}) do
  r.ShowConsoleMsg(string.format(" - %-13s : %s\n", k, caps[k] and "OK" or "MISSING"))
end
r.ShowConsoleMsg("\n")

-- If ReaPack itself is missing: keep it to ONE clear path (install ReaPack first).
if not caps.reapack then
  local txt = "ReaPack is not installed.\n\n"
    .. "Install ReaPack first, restart REAPER, then run DF95 Install Doctor again.\n\n"
    .. "Download/info:\n" .. (LINKS.reapack or "https://reapack.com/")
  msg(txt, "DF95 Install Doctor", 0)
  if LINKS.reapack then
    local ask = r.ShowMessageBox("Open ReaPack download page now?", "DF95 Install Doctor", 4)
    if ask == 6 then open_url(LINKS.reapack) end
  end
  return
end

-- ReaPack is present: show ReaPack-aware DF95 install/update instructions (no generic links).
local df95_url = read_config_reapack_url()
local how = "ReaPack detected.\n\n"
  .. "To install/update DF95 via ReaPack:\n"
  .. "  1) Extensions > ReaPack > Import repositories...\n"
  .. "  2) Paste the DF95 repository index.xml URL and confirm\n"
  .. "  3) Extensions > ReaPack > Synchronize packages\n\n"
  .. "Tip: If you've already imported the repo, step (3) is enough.\n\n"

if df95_url then
  how = how .. "DF95 repo URL (index.xml):\n" .. df95_url .. "\n\n"
else
  how = how .. "DF95 repo URL (index.xml):\n"
    .. "(not set)\n\n"
    .. "Set it in Support/DF95_Config.json:\n"
    .. '  "reapack": { "df95_repo_index_url": "https://.../index.xml" }\n\n'
end

-- If other dependencies are missing, explain the ReaPack-first path.
local others = {}
for _,k in ipairs(missing) do
  if k ~= "reapack" then others[#others+1] = k end
end

if #others > 0 then
  how = how .. "Missing optional dependencies:\n"
  for _,k in ipairs(others) do
    how = how .. " • " .. (DESCR[k] or k) .. "\n"
  end
  how = how .. "\nInstall them via:\n"
    .. "  Extensions > ReaPack > Browse packages...\n"
    .. "Search for the package name (e.g. 'ReaImGui', 'js_ReaScriptAPI').\n\n"
end

msg(how, "DF95 Install Doctor", 0)

-- Convenience: open key pages (optional)
local choice = r.ShowMessageBox("Open ReaPack user guide (shows Import/Synchronize steps)?", "DF95 Install Doctor", 4)
if choice == 6 then open_url("https://reapack.com/user-guide") end

if df95_url then
  local ask2 = r.ShowMessageBox("Open DF95 repository index.xml URL now?", "DF95 Install Doctor", 4)
  if ask2 == 6 then open_url(df95_url) end
end
