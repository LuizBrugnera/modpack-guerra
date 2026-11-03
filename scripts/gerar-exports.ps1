# Gera os exports do Modpack Guerra em modpack-guerra/exports/
#   - Instância do Prism (recomendado): packwiz-installer atualiza tudo sozinho a cada abertura
#   - .mrpack (alternativa): sem os mods "manuais" do CurseForge (ver $SLUGS_MANUAIS)
#   - Pacote do servidor (sem o mundo)
# Uso: powershell -File scripts\gerar-exports.ps1 -PackUrl https://SEU-HOST/pack.toml
param([Parameter(Mandatory = $true)][string]$PackUrl)

$ErrorActionPreference = 'Stop'
$pack = Split-Path $PSScriptRoot -Parent
$raiz = Split-Path $pack -Parent
$pw   = Join-Path $raiz 'tools\bin\packwiz.exe'
$out  = Join-Path $pack 'exports'
$boot = Join-Path $raiz 'servidor\packwiz-installer-bootstrap.jar'
$utf8 = New-Object Text.UTF8Encoding $false
New-Item -ItemType Directory -Force $out | Out-Null
Set-Location $pack

# Mods do CurseForge cujo autor bloqueou download por API: baixados direto do CDN do CurseForge
$SLUGS_MANUAIS = @('create-sentry-mechanical-arm-1')

function Get-Manual($slug) {
  $t = Get-Content (Join-Path $pack "mods\$slug.pw.toml") -Raw
  $fn = [regex]::Match($t, 'filename = "([^"]+)"').Groups[1].Value
  $id = [int][regex]::Match($t, 'file-id = (\d+)').Groups[1].Value
  $url = "https://mediafilez.forgecdn.net/files/$([math]::Floor($id / 1000))/$($id % 1000)/$fn"
  [pscustomobject]@{ Arquivo = $fn; Url = $url }
}
$jarsManuais = $SLUGS_MANUAIS | ForEach-Object { Get-Manual $_ }

$ver = ([regex]::Match((Get-Content pack.toml -Raw), 'version = "([^"]+)"')).Groups[1].Value
$nf  = ([regex]::Match((Get-Content pack.toml -Raw), 'neoforge = "([^"]+)"')).Groups[1].Value
& $pw refresh | Out-Null

# ---- .mrpack (cópia temporária do pack sem os mods manuais) ----
$tmpPack = Join-Path $env:TEMP 'mrpack-guerra'
Remove-Item $tmpPack -Recurse -Force -ErrorAction SilentlyContinue
robocopy $pack $tmpPack /E /XD .git exports scripts /NFL /NDL /NJH /NJS /NP | Out-Null
$SLUGS_MANUAIS | ForEach-Object { Remove-Item (Join-Path $tmpPack "mods\$_.pw.toml") }
Push-Location $tmpPack
& $pw refresh | Out-Null
& $pw mr export -o (Join-Path $out "ModpackGuerra-$ver.mrpack")
Pop-Location

# ---- Instância do Prism Launcher ----
$tmp = Join-Path $env:TEMP 'prism-guerra'
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force (Join-Path $tmp 'minecraft\mods') | Out-Null
Copy-Item $boot (Join-Path $tmp 'minecraft\packwiz-installer-bootstrap.jar')
$linhas = @('@echo off', 'REM Roda antes de cada abertura do jogo (Prism: comando de pre-lancamento)', 'cd /d "%~dp0"', 'if not exist mods mkdir mods')
foreach ($m in $jarsManuais) {
  $linhas += "if not exist `"mods\$($m.Arquivo)`" curl -fsSL -o `"mods\$($m.Arquivo)`" `"$($m.Url)`""
}
$linhas += "`"%~1`" -jar packwiz-installer-bootstrap.jar $PackUrl"
[IO.File]::WriteAllText((Join-Path $tmp 'minecraft\atualizar-mods.bat'), ($linhas -join "`r`n") + "`r`n", $utf8)
$cfg = @"
[General]
ConfigVersion=1.2
InstanceType=OneSix
name=Modpack Guerra
iconKey=default
OverrideMemory=true
MinMemAlloc=4096
MaxMemAlloc=8192
OverrideJavaArgs=true
JvmArgs=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15
OverrideCommands=true
PreLaunchCommand=cmd /c "`$INST_MC_DIR\\atualizar-mods.bat" "`$INST_JAVA"
"@
[IO.File]::WriteAllText((Join-Path $tmp 'instance.cfg'), $cfg, $utf8)
$mmc = '{"components":[{"uid":"net.minecraft","version":"1.21.1","important":true},{"uid":"net.neoforged","version":"' + $nf + '"}],"formatVersion":1}'
[IO.File]::WriteAllText((Join-Path $tmp 'mmc-pack.json'), $mmc, $utf8)
$prism = Join-Path $out 'ModpackGuerra-Prism.zip'
Remove-Item $prism -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $tmp '*') -DestinationPath $prism

# ---- Pacote do servidor (sem mundo; rode com o servidor desligado) ----
$srv = Join-Path $raiz 'servidor'
$srvZip = Join-Path $out "ModpackGuerra-$ver-servidor.zip"
Remove-Item $srvZip -ErrorAction SilentlyContinue
$itens = 'mods', 'config', 'defaultconfigs', 'kubejs', 'libraries', 'iniciar-servidor.bat', 'run.bat', 'run.sh', 'user_jvm_args.txt', 'server.properties', 'packwiz-installer-bootstrap.jar' |
  ForEach-Object { Join-Path $srv $_ } | Where-Object { Test-Path $_ }
Compress-Archive -Path $itens -DestinationPath $srvZip

Write-Host "Mods manuais (fora do .mrpack):"; $jarsManuais | Format-Table -AutoSize | Out-String | Write-Host
Get-ChildItem $out | Select-Object Name, @{n = 'MB'; e = { [math]::Round($_.Length / 1MB, 1) } }
