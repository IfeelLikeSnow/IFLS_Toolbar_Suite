param(
  [string]$Owner = "IfeelLikeSnow",
  [string]$Repo  = "IFLS_Toolbar_Suite",
  [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

$base = "https://raw.githubusercontent.com/$Owner/$Repo/$Branch"
$urls = @(
  "$base/index.xml",
  "$base/Scripts/IFLS_Toolbar_Suite/tools/diagnostics.lua",
  "$base/Scripts/IFLS_Toolbar_Suite/hubs/IFLS_BeatControlCenter_ImGui.lua",
  "$base/Scripts/IFLS_Toolbar_Suite/hubs/beat/hub.lua",
  "$base/Scripts/IFLS_Toolbar_Suite/hubs/fxbrain/hub.lua"
)

function Head-Url([string]$u) {
  Write-Host ""
  Write-Host "HEAD $u"
  $req = [System.Net.HttpWebRequest]::Create($u)
  $req.Method = "HEAD"
  $req.AllowAutoRedirect = $true
  try {
    $resp = $req.GetResponse()
    $code = [int]$resp.StatusCode
    $resp.Close()
    Write-Host "OK $code"
    return $true
  } catch {
    if ($_.Exception.Response -ne $null) {
      $code = [int]$_.Exception.Response.StatusCode
      Write-Host "FAIL $code"
    } else {
      Write-Host "FAIL (no response)"
    }
    return $false
  }
}

$allOk = $true
foreach ($u in $urls) {
  if (-not (Head-Url $u)) { $allOk = $false }
}

Write-Host ""
if ($allOk) {
  Write-Host "All URLs OK."
  exit 0
} else {
  Write-Host "Some URLs failed. Fix repo contents / index.xml and push again."
  exit 1
}
