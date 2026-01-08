# IFLS_Toolbar_Suite Option B – Syntax Scan Report

Generated: 2026-01-08T06:06:10.143742Z

This repo includes IFLS_Toolbar_Suite (core) plus DF95 legacy scripts and assets.

## Automated fixes applied

### 1) Short-string newline repairs (Lua syntax)
The following files contained invalid newlines inside short strings ("..." or '...').
They were auto-rewritten by replacing embedded newlines with `\n` to restore valid Lua syntax.

- `Scripts/DF95Framework/Lib/DF95_Diagnostics_Lib_Insight.lua`
- `Scripts/IFLS/DF95/Core/DF95_JSON.lua`
- `Scripts/IFLS/DF95/DF95_AIWorker_Material_Apply_ProposedNew.lua`
- `Scripts/IFLS/DF95/DF95_AI_FXChain_From_AIResult.lua`
- `Scripts/IFLS/DF95/DF95_AI_FXChain_FullAuto_From_AIResult.lua`
- `Scripts/IFLS/DF95/DF95_AI_FXMacro_Apply_From_AIResult.lua`
- `Scripts/IFLS/DF95/DF95_FXChains_Index_Enricher.lua`
- `Scripts/IFLS/DF95/DF95_MetaCore_VST_All_Flat.lua`
- `Scripts/IFLS/DF95/DF95_SelfCheck_Toolkit.lua`
- `Scripts/IFLS/DF95/DF95_SelfTest_ResultViewer.lua`
- `Scripts/IFLS/DF95/DF95_System_Health_Panel_ImGui.lua`
- `Scripts/IFLS/DF95/DF95_V133_AIBeat_Soundscape_Generator.lua`
- `Scripts/IFLS/DF95/DF95_V170_Fieldrec_Fusion_Export_GUI.lua`
- `Scripts/IFLS/DF95/DF95_Workflow_Brain_ImGui.lua`
- `Scripts/IFLS/DF95/ReampSuite/DF95_V86_ReampSuite_BatchReampEngine.lua`
- `Scripts/IFLS/DF95/ReampSuite/DF95_V95_2_Fieldrec_OneClick_SplitEngine.lua`
- `Scripts/IFLS/DF95/ReampSuite/DF95_V97_Fieldrec_BeatEngine_Audio.lua`
- `Scripts/IFLS/IFLS/Hubs/IFLS_PerformanceHub_ImGui.lua`
- `Scripts/IFLS/IFLS/Hubs/IFLS_TuningSync_ImGui.lua`

### 2) Global escape fixes
Applied safe replacements across repo where found:
- `gsub("\", "/")` → `gsub("\\", "/")`
- `~= "\"` / `== "\"` → `~= "\\"` / `== "\\"`

### 3) Suite compatibility wrappers
- `Scripts/IFLS_Diagnostics.lua` (compat)
- `Scripts/IFLS_TB_Launcher.lua` (compat)
- nested `Scripts/IFLS_Toolbar_Suite/Scripts/Scripts/...` wrappers (from KB legacy paths)

### 4) Rebuilt `IFLS_FXParamIndex.lua`
Replaced corrupted file with stable TSV parser + index helper.

## Notes
- This scan focuses on common Lua syntax killers (short-string newlines, unterminated strings).
- For runtime issues (missing dependencies, ReaImGui/SWS requirements), use `Scripts/IFLS_Toolbar_Suite/tools/diagnostics.lua` in REAPER.
