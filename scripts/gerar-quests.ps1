# Gera as quests do FTB Quests (config/ftbquests/quests) a partir das listas abaixo.
# Rodar de novo depois de editar: powershell -File scripts\gerar-quests.ps1
# Os IDs saem de um hash da chave de cada quest, então ficam estáveis entre execuções
# (o progresso dos jogadores não se perde ao regerar).

$raiz = Join-Path $PSScriptRoot '..\config\ftbquests\quests'
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Id([string]$chave) {
  $md5 = [System.Security.Cryptography.MD5]::Create()
  $b = $md5.ComputeHash([Text.Encoding]::UTF8.GetBytes("guerra:$chave"))
  ($b[0..7] | ForEach-Object { $_.ToString('X2') }) -join ''
}
function Str([string]$s) { '"' + ($s -replace '\\', '\\' -replace '"', '\"') + '"' }

# Cada quest: chave, x, y, deps (chaves), tarefas (item=qtd | 'check'), recompensas (item=qtd), titulo, descricao (linhas)
$capitulos = @(
  @{ arquivo = 'c1_create'; titulo = '1. Primeiros passos no Create'; icone = 'create:wrench'
     subtitulo = 'O básico para construir qualquer máquina (e qualquer veículo).'
     quests = @(
      @{ k='c1_chave'; x=0; y=0; deps=@(); t=@('create:wrench=1'); r=@('create:andesite_alloy=4'); titulo='Chave inglesa'
         d=@('A ferramenta do Create: gira, ajusta e desmonta blocos (agachado + clique direito).', '', 'Dica: segure §eW§r em cima de qualquer item do Create para ver o §ePonder§r, uma animação que mostra como ele funciona.') }
      @{ k='c1_liga'; x=1.5; y=0; deps=@('c1_chave'); t=@('create:andesite_alloy=8'); r=@(); titulo='Liga de andesito'
         d=@('Andesito + pepita de ferro (ou zinco). Quase tudo no começo do Create usa isso.') }
      @{ k='c1_roda'; x=3; y=-1; deps=@('c1_liga'); t=@('create:water_wheel=1'); r=@('create:shaft=8'); titulo='Primeira força: roda d''água'
         d=@('Coloque na beira de água corrente. Ela gira e gera força rotacional.') }
      @{ k='c1_eixos'; x=4.5; y=-1; deps=@('c1_roda'); t=@('create:shaft=8', 'create:cogwheel=4'); r=@(); titulo='Eixos e engrenagens'
         d=@('Eixos levam a rotação em linha reta; engrenagens mudam a direção e a velocidade.') }
      @{ k='c1_oculos'; x=3; y=1; deps=@('c1_liga'); t=@('create:goggles=1'); r=@(); titulo='Óculos do engenheiro'
         d=@('Com eles você vê velocidade e estresse das máquinas. Se a rede estiver sobrecarregada, tudo para.') }
      @{ k='c1_carcaca'; x=4.5; y=1; deps=@('c1_oculos'); t=@('create:andesite_casing=4'); r=@(); titulo='Carcaça de andesito'
         d=@('Base de várias máquinas (e do montador de física do próximo capítulo).') }
      @{ k='c1_cola'; x=6; y=0; deps=@('c1_eixos', 'c1_carcaca'); t=@('create:super_glue=1'); r=@('create:andesite_alloy=16'); titulo='Super cola'
         d=@('Gruda blocos entre si para que se movam juntos. Todo veículo começa aqui.', '', '§aPróximo capítulo: seu primeiro barco.') }
     ) }
  @{ arquivo = 'c2_barco'; titulo = '2. Seu primeiro barco'; icone = 'simulated:steering_wheel'
     subtitulo = 'Do casco de madeira à primeira viagem.'
     quests = @(
      @{ k='c2_montador'; x=0; y=0; deps=@('c1_cola'); t=@('simulated:physics_assembler=1'); r=@(); titulo='Montador de física'
         d=@('É ele que transforma um monte de blocos em um veículo de verdade, com física.', '', '1. Construa o casco.', '2. Coloque o montador encostado nele.', '3. Dê um sinal de redstone no montador.', '', 'Veja o passo a passo no §ePonder§r (segure §eW§r sobre o item).') }
      @{ k='c2_casco'; x=1.5; y=0; deps=@('c2_montador'); t=@('check'); r=@('minecraft:oak_planks=64'); titulo='Monte o casco'
         d=@('Construa um casco simples de madeira na água e monte com o montador de física.', '', 'Madeira é leve e flutua bem; pedra e metal pesam. Teste perto da margem antes de ir longe.', '', 'Clique na tarefa para marcar como feita.') }
      @{ k='c2_timao'; x=3; y=-1; deps=@('c2_casco'); t=@('simulated:steering_wheel=1'); r=@(); titulo='Timão'
         d=@('Coloque no barco e use para pilotar.') }
      @{ k='c2_helice'; x=3; y=1; deps=@('c2_casco'); t=@('aeronautics:propeller_bearing=1', 'aeronautics:wooden_propeller=1'); r=@(); titulo='Hélice'
         d=@('Rolamento de hélice + hélice de madeira: empurram o barco quando recebem rotação.', '', 'Veja no §ePonder§r como montar e qual lado empurra.') }
      @{ k='c2_motor'; x=4.5; y=1; deps=@('c2_helice'); t=@('simulated:white_portable_engine=1'); r=@(); titulo='Motor portátil'
         d=@('Uma fonte de força que vai junto com o veículo, para girar a hélice no meio do mar.', '', 'Veja no §ePonder§r como alimentar.') }
      @{ k='c2_leme'; x=4.5; y=-1; deps=@('c2_timao'); t=@('simulated:swivel_bearing=1'); r=@(); titulo='Leme'
         d=@('O rolamento giratório deixa uma parte do barco virar: use para um leme ou para apontar a hélice.') }
      @{ k='c2_acelerador'; x=6; y=0; deps=@('c2_motor', 'c2_leme'); t=@('simulated:throttle_lever=1'); r=@(); titulo='Alavanca de aceleração'
         d=@('Controla a força enviada à hélice: devagar no porto, rápido em mar aberto.') }
      @{ k='c2_viagem'; x=7.5; y=0; deps=@('c2_acelerador'); t=@('check'); r=@('create:andesite_alloy=16', 'minecraft:iron_ingot=16'); titulo='Primeira viagem'
         d=@('Navegue até outro bioma e volte com o barco inteiro.', '', '§aPróximo capítulo: voar.') }
     ) }
  @{ arquivo = 'c3_voo'; titulo = '3. Voando: balão e avião'; icone = 'aeronautics:white_envelope'
     subtitulo = 'Primeiro sobe, depois aprende a ir para frente.'
     quests = @(
      @{ k='c3_envelope'; x=0; y=0; deps=@('c2_casco'); t=@('aeronautics:white_envelope=8'); r=@(); titulo='Envelope de ar quente'
         d=@('Blocos que seguram ar quente. Quanto mais envelopes cheios, mais sustentação.') }
      @{ k='c3_queimador'; x=1.5; y=0; deps=@('c3_envelope'); t=@('aeronautics:adjustable_burner=1'); r=@(); titulo='Queimador de ar quente'
         d=@('Coloque embaixo dos envelopes. Com redstone você controla a chama: mais forte para subir, mais fraca para descer.') }
      @{ k='c3_balao'; x=3; y=0; deps=@('c3_queimador'); t=@('check'); r=@('minecraft:string=32'); titulo='Primeiro balão'
         d=@('Monte um balão com cesto, envelopes e queimador, e suba pelo menos 50 blocos.') }
      @{ k='c3_levitita'; x=3; y=-1.5; deps=@('c3_envelope'); t=@('aeronautics:levitite=4'); r=@(); titulo='Levitita'
         d=@('Um material que flutua sozinho. Ajuda a deixar aeronaves pesadas mais leves.') }
      @{ k='c3_paraquedas'; x=3; y=1.5; deps=@('c3_envelope'); t=@('create_parachute:parachute_block=1'); r=@(); titulo='Paraquedas'
         d=@('Sempre leve um. Aeronave cai, ainda mais em guerra.') }
      @{ k='c3_asas'; x=4.5; y=-1; deps=@('c3_balao'); t=@('createpropulsion:wing=4'); r=@(); titulo='Asas'
         d=@('Asas geram sustentação com velocidade: é o que separa um balão de um avião.') }
      @{ k='c3_helice'; x=4.5; y=1; deps=@('c3_balao'); t=@('aeronautics:andesite_propeller=1'); r=@(); titulo='Hélice de andesito'
         d=@('Uma hélice mais forte, para empurrar aeronaves.') }
      @{ k='c3_propulsor'; x=6; y=-1; deps=@('c3_asas'); t=@('createpropulsion:thruster=1'); r=@(); titulo='Propulsor'
         d=@('Empurra a aeronave com combustível. Veja no §ePonder§r o que ele queima e como abastecer.') }
      @{ k='c3_oculos'; x=6; y=1; deps=@('c3_helice'); t=@('aeronautics:aviators_goggles=1'); r=@(); titulo='Óculos de aviador'
         d=@('Todo piloto precisa de um.') }
      @{ k='c3_voo'; x=7.5; y=0; deps=@('c3_propulsor', 'c3_oculos'); t=@('check'); r=@('create_parachute:parachute_block=1'); titulo='Primeiro voo'
         d=@('Decole, voe 500 blocos e pouse com a aeronave inteira.') }
     ) }
  @{ arquivo = 'c4_navegacao'; titulo = '4. Navegação e controle'; icone = 'simulated:navigation_table'
     subtitulo = 'Sensores e redstone para pilotar melhor (e sozinho).'
     quests = @(
      @{ k='c4_mesa'; x=0; y=0; deps=@('c2_viagem'); t=@('simulated:navigation_table=1'); r=@(); titulo='Mesa de navegação'
         d=@('Ajuda a manter o rumo em viagens longas. Veja no §ePonder§r como usar.') }
      @{ k='c4_altitude'; x=1.5; y=-1; deps=@('c4_mesa', 'c3_balao'); t=@('simulated:altitude_sensor=1'); r=@(); titulo='Sensor de altitude'
         d=@('Emite redstone conforme a altura. Ligue no queimador para o balão parar sozinho numa altitude.') }
      @{ k='c4_gimbal'; x=1.5; y=1; deps=@('c4_mesa'); t=@('simulated:gimbal_sensor=1'); r=@(); titulo='Sensor de inclinação'
         d=@('Detecta a inclinação do veículo. Use com redstone para estabilizar.') }
      @{ k='c4_velocidade'; x=3; y=-1; deps=@('c4_altitude'); t=@('simulated:velocity_sensor=1'); r=@(); titulo='Sensor de velocidade'
         d=@('Mede a velocidade do veículo e emite redstone. Bom para controlar o acelerador.') }
      @{ k='c4_doca'; x=3; y=1; deps=@('c4_gimbal'); t=@('simulated:docking_connector=1'); r=@(); titulo='Conector de atracação'
         d=@('Prende um veículo em outro (ou num porto) para atracar sem bater.') }
      @{ k='c4_controle'; x=4.5; y=0; deps=@('c4_velocidade', 'c4_doca'); t=@('create:linked_controller=1'); r=@(); titulo='Controle remoto'
         d=@('Manda sinais de redstone sem fio: controle o veículo de qualquer lugar a bordo.') }
      @{ k='c4_auto'; x=6; y=0; deps=@('c4_controle'); t=@('check'); r=@('minecraft:redstone=32', 'create:andesite_alloy=16'); titulo='Piloto automático'
         d=@('Faça um veículo manter altitude ou rumo sozinho, usando sensores e redstone.') }
     ) }
)

$lang = [ordered]@{}
$lang['file.0000000000000001.title'] = 'Modpack Guerra'
New-Item -ItemType Directory -Force (Join-Path $raiz 'chapters'), (Join-Path $raiz 'lang') | Out-Null
Get-ChildItem (Join-Path $raiz 'chapters') -Filter *.snbt | Remove-Item

$ordem = 0
foreach ($c in $capitulos) {
  $cid = Id "cap:$($c.arquivo)"
  $lang["chapter.$cid.title"] = $c.titulo
  $lang["chapter.$cid.chapter_subtitle"] = @($c.subtitulo)
  $qs = @()
  foreach ($q in $c.quests) {
    $qid = Id "quest:$($q.k)"
    $lang["quest.$qid.title"] = $q.titulo
    $lang["quest.$qid.quest_desc"] = $q.d
    $deps = ($q.deps | ForEach-Object { Str (Id "quest:$_") }) -join ', '
    $i = 0
    $tarefas = foreach ($t in $q.t) {
      $i++; $tid = Id "task:$($q.k):$i"
      if ($t -eq 'check') { "{ id: $(Str $tid), type: `"checkmark`" }" }
      else { $item, $n = $t -split '='; "{ count: ${n}L, id: $(Str $tid), item: { count: 1, id: $(Str $item) }, type: `"item`" }" }
    }
    $i = 0
    $recompensas = foreach ($r in $q.r) {
      $i++; $rid = Id "reward:$($q.k):$i"; $item, $n = $r -split '='
      "{ count: $n, id: $(Str $rid), item: { count: 1, id: $(Str $item) }, type: `"item`" }"
    }
    $qs += "`t`t{`n`t`t`tdependencies: [$deps]`n`t`t`tid: $(Str $qid)`n`t`t`trewards: [$($recompensas -join ', ')]`n`t`t`ttasks: [$($tarefas -join ', ')]`n`t`t`tx: $([string]::Format([Globalization.CultureInfo]::InvariantCulture, '{0:0.0}', $q.x))d`n`t`t`ty: $([string]::Format([Globalization.CultureInfo]::InvariantCulture, '{0:0.0}', $q.y))d`n`t`t}"
  }
  $snbt = "{`n`tdefault_hide_dependency_lines: false`n`tdefault_quest_shape: `"`"`n`tfilename: $(Str $c.arquivo)`n`tgroup: `"`"`n`ticon: { count: 1, id: $(Str $c.icone) }`n`tid: $(Str $cid)`n`torder_index: $ordem`n`tquest_links: [ ]`n`tquests: [`n$($qs -join "`n")`n`t]`n}`n"
  [IO.File]::WriteAllText((Join-Path $raiz "chapters\$($c.arquivo).snbt"), $snbt, $utf8)
  $ordem++
}

$data = @'
{
	default_autoclaim_rewards: "disabled"
	default_consume_items: false
	default_quest_disable_jei: false
	default_quest_shape: "circle"
	default_reward_team: false
	detection_delay: 20
	disable_gui: false
	drop_book_on_death: false
	drop_loot_crates: false
	emergency_items_cooldown: 300
	fallback_locale: "en_us"
	grid_scale: 0.5d
	hide_excluded_quests: true
	id: "0000000000000001"
	lock_message: ""
	pause_game: false
	progression_mode: "linear"
	show_lock_icons: true
	version: 13
}
'@
[IO.File]::WriteAllText((Join-Path $raiz 'data.snbt'), $data, $utf8)

# Textos em pt-BR no en_us (o FTB Quests usa en_us como reserva para todos os idiomas)
$linhas = foreach ($k in $lang.Keys) {
  $v = $lang[$k]
  if ($v -is [array]) { "`t$(Str $k): [`n" + (($v | ForEach-Object { "`t`t$(Str $_)" }) -join "`n") + "`n`t]" }
  else { "`t$(Str $k): $(Str $v)" }
}
[IO.File]::WriteAllText((Join-Path $raiz 'lang\en_us.snbt'), "{`n$($linhas -join "`n")`n}`n", $utf8)
Write-Host "Quests geradas em $raiz"
