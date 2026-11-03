# Gera os exports do Modpack Guerra em modpack-guerra/exports/
#   .mrpack (Modrinth), .zip (CurseForge), instância do Prism (com packwiz-installer) e pacote do servidor.
# Uso: powershell -File scripts\gerar-exports.ps1 -PackUrl https://SEU-HOST/pack.toml
param([string]$PackUrl = 'https://<host-do-repo>/pack.toml')

$ErrorActionPreference = 'Stop'
$pack   = Split-Path $PSScriptRoot -Parent
$raiz   = Split-Path $pack -Parent
$pw     = Join-Path $raiz 'tools\bin\packwiz.exe'
$out    = Join-Path $pack 'exports'
$boot   = Join-Path $raiz 'servidor\packwiz-installer-bootstrap.jar'
New-Item -ItemType Directory -Force $out | Out-Null
Set-Location $pack

$ver = ([regex]::Match((Get-Content pack.toml -Raw), 'version = "([^"]+)"')).Groups[1].Value
$nf  = ([regex]::Match((Get-Content pack.toml -Raw), 'neoforge = "([^"]+)"')).Groups[1].Value

& $pw refresh | Out-Null
& $pw mr export -o (Join-Path $out "ModpackGuerra-$ver.mrpack")
& $pw cf export -o (Join-Path $out "ModpackGuerra-$ver-curseforge.zip")

# ---- Instância do Prism Launcher ----
$tmp = Join-Path $env:TEMP "prism-guerra"
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force (Join-Path $tmp 'minecraft') | Out-Null
Copy-Item $boot (Join-Path $tmp 'minecraft\packwiz-installer-bootstrap.jar')
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
PreLaunchCommand="`$INST_JAVA" -jar packwiz-installer-bootstrap.jar $PackUrl
"@
[IO.File]::WriteAllText((Join-Path $tmp 'instance.cfg'), $cfg, (New-Object Text.UTF8Encoding $false))
$mmc = '{"components":[{"uid":"net.minecraft","version":"1.21.1","important":true},{"uid":"net.neoforged","version":"' + $nf + '"}],"formatVersion":1}'
[IO.File]::WriteAllText((Join-Path $tmp 'mmc-pack.json'), $mmc, (New-Object Text.UTF8Encoding $false))
$prism = Join-Path $out "ModpackGuerra-Prism.zip"
Remove-Item $prism -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $tmp '*') -DestinationPath $prism

# ---- Pacote do servidor (sem mundo) ----
$srv = Join-Path $raiz 'servidor'
$srvZip = Join-Path $out "ModpackGuerra-$ver-servidor.zip"
Remove-Item $srvZip -ErrorAction SilentlyContinue
$itens = 'mods','config','defaultconfigs','kubejs','libraries','iniciar-servidor.bat','run.bat','run.sh','user_jvm_args.txt','server.properties','packwiz-installer-bootstrap.jar' |
  ForEach-Object { Join-Path $srv $_ } | Where-Object { Test-Path $_ }
Compress-Archive -Path $itens -DestinationPath $srvZip

Get-ChildItem $out | Select-Object Name, @{n='MB';e={[math]::Round($_.Length/1MB,1)}}
