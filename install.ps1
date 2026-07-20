<#
Install the agents-workflow skill for a given AI coding agent (Windows / PowerShell).

Usage:
  .\install.ps1 -Agent claude   [-Global | -Project DIR]
  .\install.ps1 -Agent cursor   [-Project DIR]
  .\install.ps1 -Agent opencode [-Global | -Project DIR]
  .\install.ps1 -Agent generic  [-Project DIR]      # AGENTS.md standard

Defaults: -Project . (current directory). -Global uses your home config.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][ValidateSet('claude','cursor','opencode','generic')][string]$Agent,
  [switch]$Global,
  [string]$Project = '.'
)

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$BodyPath = Join-Path $Here 'skill\agents-workflow.md'
if (-not (Test-Path $BodyPath)) { Write-Error "skill\agents-workflow.md not found (run from the repo)."; exit 1 }
$Body = Get-Content $BodyPath -Raw

$Desc = "Bootstrap and maintain the .agents/ Markdown project-memory workflow (executor/auditor roles, files as durable state). Use when starting a new project with this system, when asked to set up .agents/, or to plan / audit / compact project state."

function Ensure-Dir($path) { $d = Split-Path -Parent $path; if ($d -and -not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null } }
function Write-Utf8($path, $content) { Ensure-Dir $path; Set-Content -Path $path -Value $content -Encoding utf8 -NoNewline }

function Write-Marked($target) {
  $begin = '<!-- BEGIN agents-workflow -->'; $end = '<!-- END agents-workflow -->'
  $block = "$begin`n$Body`n$end`n"
  Ensure-Dir $target
  if ((Test-Path $target) -and (Select-String -Path $target -SimpleMatch $begin -Quiet)) {
    $lines = Get-Content $target; $out = New-Object System.Collections.Generic.List[string]; $drop = $false
    foreach ($l in $lines) {
      if ($l -eq $begin) { $drop = $true }
      if (-not $drop) { $out.Add($l) }
      if ($l -eq $end) { $drop = $false }
    }
    $existing = ($out -join "`n").TrimEnd()
    Set-Content -Path $target -Value ($existing + "`n`n" + $block) -Encoding utf8 -NoNewline
  } elseif (Test-Path $target) {
    Add-Content -Path $target -Value ("`n" + $block) -Encoding utf8
  } else {
    Write-Utf8 $target $block
  }
}

switch ($Agent) {
  'claude' {
    if ($Global) { $base = Join-Path $HOME '.claude' } else { $base = Join-Path $Project '.claude' }
    $out = Join-Path $base 'skills\agents-workflow\SKILL.md'
    Write-Utf8 $out ("---`nname: agents-workflow`ndescription: $Desc`n---`n`n" + $Body)
    Write-Host "Installed -> $out"
  }
  'cursor' {
    $out = Join-Path $Project '.cursor\rules\agents-workflow.mdc'
    Write-Utf8 $out ("---`ndescription: $Desc`nglobs:`nalwaysApply: false`n---`n`n" + $Body)
    Write-Host "Installed -> $out  (set alwaysApply: true to always load)"
  }
  'opencode' {
    if ($Global) { $out = Join-Path $HOME '.config\opencode\AGENTS.md' } else { $out = Join-Path $Project 'AGENTS.md' }
    Write-Marked $out; Write-Host "Installed -> $out  (OpenCode reads AGENTS.md)"
  }
  'generic' {
    $out = Join-Path $Project 'AGENTS.md'; Write-Marked $out
    Write-Host "Installed -> $out  (AGENTS.md standard — read by many tools)"
  }
}
Write-Host "Done. In your agent, ask it to 'set up the .agents/ structure' to bootstrap a project."
