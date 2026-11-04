# Gera kubejs/data/tacz/recipe/gun/*.json: as receitas das armas do TaCZ ganham o material da era.
# O pacote de KubeJS carrega por cima do gunpack padrão (testado: a receita sobrescrita vence).
# Rodar de novo se mudar as listas abaixo ou se o gunpack do TaCZ for atualizado:
#   powershell -File scripts\gerar-armas-tacz.ps1
param([string]$Gunpack = (Join-Path $PSScriptRoot '..\..\servidor\tacz\tacz_default_gun\data\tacz\recipe\gun'))

$destino = Join-Path $PSScriptRoot '..\kubejs\data\tacz\recipe\gun'
$utf8 = New-Object System.Text.UTF8Encoding($false)

# Era 1 (Mecânica) fica com a receita original: ferro e madeira.
#   m1911 cz75 glock_17 hk_mk23 m9a4 p320 rhino357 taurus943 lonetrail springfield1873 kar98 db_short db_long m870 sks_tactical
$ERAS = [ordered]@{
  2 = @{ nome = 'Vapor'; extra = @(@('create:brass_ingot', 6), @('create:precision_mechanism', 1))
         armas = @('uzi', 'hk_mp5a5', 'ump45', 'vector45', 'p90', 'b93r', 'deagle', 'taurus500', 'm1014', 'spas_12', 'm700', 'm16a1', 'type_81') }
  3 = @{ nome = 'Petróleo e Aço'; extra = @(@('tfmg:steel_ingot', 10), @('tfmg:sulfur_dust', 2))
         armas = @('ak47', 'm4a1', 'm16a4', 'hk416d', 'g36k', 'aug', 'qbz_95', 'qbz_191', 'scar_l', 'scar_h', 'fn_fal', 'hk_g3', 'mk14', 'spr15hb', 'rpk', 'm249', 'aa12', 'ai_awp') }
  4 = @{ nome = 'Eletricidade'; extra = @(@('tfmg:aluminum_ingot', 8), @('tfmg:circuit_board', 2), @('tfmg:steel_ingot', 6))
         armas = @('m107', 'm95', 'fn_evolys', 'minigun', 'rpg7', 'm320', 'deagle_golden', 'timeless50') }
}

New-Item -ItemType Directory -Force $destino | Out-Null
Get-ChildItem $destino -Filter *.json | Remove-Item
$total = 0
foreach ($par in $ERAS.GetEnumerator()) {
  $e = $par.Value
  foreach ($arma in $e.armas) {
    $orig = Join-Path $Gunpack "$arma.json"
    if (-not (Test-Path $orig)) { throw "Receita original não encontrada: $orig" }
    $r = [IO.File]::ReadAllText($orig) | ConvertFrom-Json
    $mats = @($r.materials)
    foreach ($x in $e.extra) { $mats += [pscustomobject]@{ item = [pscustomobject]@{ item = $x[0] }; count = $x[1] } }
    $r.materials = $mats
    $json = $r | ConvertTo-Json -Depth 10
    [IO.File]::WriteAllText((Join-Path $destino "$arma.json"), $json, $utf8)
    $total++
  }
}
Write-Host "Receitas de armas geradas: $total em $destino"
