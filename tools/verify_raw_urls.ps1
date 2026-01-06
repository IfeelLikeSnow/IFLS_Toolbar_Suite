param(
  [string]$Base = "https://raw.githubusercontent.com/IfeelLikeSnow/IFLS_Toolbar_Suite/main"
)

$paths = @(
  "index.xml",
  "Scripts/IFLS_Toolbar_Suite/tools/diagnostics.lua",
  "Scripts/IFLS_Toolbar_Suite/hubs/IFLS_BeatControlCenter_ImGui.lua",
  "Scripts/IFLS_Toolbar_Suite/hubs/beat/hub.lua",
  "Scripts/IFLS_Toolbar_Suite/hubs/fxbrain/hub.lua",
  "Scripts/IFLS_Toolbar_Suite/lib/imgui.lua",
  "Scripts/imgui.lua"
)

$failed = $false

foreach ($p in $paths) {
  $url = "$Base/$p"
  Write-Host ""
  Write-Host "HEAD $url"
  try {
    $resp = Invoke-WebRequest -Method Head -Uri $url -UseBasicParsing -TimeoutSec 20
    if ($resp.StatusCode -eq 200) {
      Write-Host "OK 200"
    } else {
      Write-Host ("FAIL " + $resp.StatusCode)
      $failed = $true
    }
  } catch {
    Write-Host ("FAIL " + $_.Exception.Message)
    $failed = $true
  }
}

Write-Host ""
if ($failed) {
  Write-Host "One or more URLs failed."
  exit 1
} else {
  Write-Host "All URLs OK."
  exit 0
}
