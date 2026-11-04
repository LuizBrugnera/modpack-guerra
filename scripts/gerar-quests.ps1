# Gera as quests do FTB Quests (config/ftbquests/quests) a partir das listas abaixo.
# Rodar de novo depois de editar: powershell -File scripts\gerar-quests.ps1
# Os IDs saem de um hash da chave de cada quest, então ficam estáveis entre execuções
# (o progresso dos jogadores não se perde ao regerar, desde que a chave 'k' não mude).
# Regras de progressão (eras, travas, armas): PROGRESSAO.md.

$raiz = Join-Path $PSScriptRoot '..\config\ftbquests\quests'
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Id([string]$chave) {
  $md5 = [System.Security.Cryptography.MD5]::Create()
  $b = $md5.ComputeHash([Text.Encoding]::UTF8.GetBytes("guerra:$chave"))
  ($b[0..7] | ForEach-Object { $_.ToString('X2') }) -join ''
}
function Str([string]$s) { '"' + ($s -replace '\\', '\\' -replace '"', '\"') + '"' }
function Num([double]$n) { [string]::Format([Globalization.CultureInfo]::InvariantCulture, '{0:0.0}', $n) + 'd' }

$DICA_PONDER = 'Segure §eW§r em cima do item para ver o §ePonder§r (animação de como funciona). No EMI, §eR§r mostra a receita e §eU§r os usos.'

# Quest: k (chave), x, y, deps, t (tarefas: 'item=qtd' ou 'check'), r (recompensas 'item=qtd'),
#        titulo, d (linhas da descrição), opcional: forma ('gear', 'hexagon'…), tam (tamanho)
$grupos = @(
 @{ k = 'g_inicio'; titulo = 'Começo'; capitulos = @(
  @{ arquivo = 'c0_bemvindo'; titulo = 'Bem-vindo à Guerra'; icone = 'minecraft:writable_book'
     subtitulo = 'Leia antes de tudo: como o servidor funciona.'
     quests = @(
      @{ k='q0_bemvindo'; x=0; y=0; deps=@(); t=@('check'); r=@('minecraft:bread=16'); titulo='Bem-vindo à Guerra'; forma='gear'; tam=1.5
         d=@('Este é um servidor de §cguerra entre times§r: indústria do Create e do TFMG sustentando canhões, armas, aviões, mísseis e bombas.', '', 'A progressão é dividida em §65 eras§r. Cada era libera armas e veículos novos, e cada um exige o material da indústria daquela era. Não dá para pular etapas: quem domina a indústria domina a guerra.', '', 'Clique na tarefa para marcar como lida.') }
      @{ k='q0_eras'; x=1.5; y=0; deps=@('q0_bemvindo'); t=@('check'); r=@(); titulo='Como funcionam as eras'
         d=@('§fEra 1 — Mecânica:§r Create básico. Pistolas, rifles clássicos, canhões de ferro, barcos e balões.', '§fEra 2 — Vapor:§r latão e motor a vapor. Submetralhadoras, autocanhões, hélices, trens.', '§fEra 3 — Petróleo e Aço:§r refinaria e aço do TFMG. Fuzis, canhões de aço, bombas, Superb Warfare.', '§fEra 4 — Eletricidade:§r alumínio e circuitos. Armas pesadas, Mk 84, mísseis guiados, veículos, jatos.', '§fEra 5 — Fim de jogo:§r urânio. A Fat Man.', '', 'Você sobe de era ao ter no inventário o §emarco§r da próxima: §fmotor a vapor → aço → placa de circuito → urânio§r. O servidor anuncia para todo mundo.', '', 'Digite §e/era§r a qualquer momento para ver sua era e o que falta.') }
      @{ k='q0_emi'; x=3; y=-1; deps=@('q0_eras'); t=@('check'); r=@(); titulo='Receitas e regras no EMI'
         d=@('A lista de itens à direita do inventário é o §eEMI§r (o JEI do pack).', '', '§eR§r em cima de um item: receitas. §eU§r: onde ele é usado.', 'Itens com regra especial (era, confisco, limite) têm uma página §fInformação§r explicando — por exemplo a bancada de armas do TaCZ, o aço do TFMG e a Fat Man.') }
      @{ k='q0_time'; x=3; y=1; deps=@('q0_eras'); t=@('check'); r=@(); titulo='Monte seu time e proteja a base'
         d=@('Os claims são do §eOpen Parties and Claims§r:', '1. Aperte §e''§r (apóstrofo) para abrir o menu e crie um §fgrupo§r (party). Convide seus amigos.', '2. Abra o mapa (§eM§r), clique com o direito nos chunks e escolha §fReivindicar§r.', '', 'Limite: §f64 chunks§r, +16 por membro do grupo. Os claims são do grupo.', 'Dentro do claim, ninguém de fora quebra nem abre nada.') }
      @{ k='q0_horario'; x=4.5; y=-1; deps=@('q0_emi'); t=@('check'); r=@(); titulo='Horário de guerra'
         d=@('Explosões só quebram blocos no §chorário de guerra§r: §fsexta e sábado, 20h–23h§r (Brasília).', 'Fora disso, explosões ainda ferem, mas não destroem nada.', '', 'Admins podem forçar com /guerra on | off.') }
      @{ k='q0_regras'; x=4.5; y=1; deps=@('q0_time'); t=@('check'); r=@(); titulo='Regras de armamento'
         d=@('§c•§r Armas nucleares (exceto a Fat Man) só existem em eventos do servidor.', '§c•§r Fat Man só vale montada no Crafter Mecânico 7x7 (Era 5). Outras são confiscadas.', '§c•§r Bombas grandes Mk 84 exigem a Era 4; sem ela o item some.', '§c•§r Blocos à prova total (bunker): no máximo 128 por jogador.') }
      @{ k='q0_mundo'; x=6; y=0; deps=@('q0_horario', 'q0_regras'); t=@('check'); r=@('minecraft:torch=32'); titulo='O mundo'
         d=@('§f•§r O mapa tem borda: §f16.000 × 16.000 blocos§r, centro em 0, 0.', '§f•§r Existem §fcidades abandonadas§r pelo mapa, com loot e prédios para combate urbano.', '§f•§r §fTornados§r quebram blocos. Fique de olho no céu.', '§f•§r Algumas noites têm §fluas especiais§r: horda de zumbis, aranhas, cegueira (Lua Negra), caos (mobs do Born in Chaos mais fortes)…', '§f•§r Morreu? Seu §fcorpo§r fica no lugar com os itens (mod Corpse). Volte para buscar.', '', '§aAgora comece pela Era 1.') }
     ) }
 ) }
 @{ k = 'g_eras'; titulo = 'Eras'; capitulos = @(
  @{ arquivo = 'c1_era1'; titulo = 'Era 1 — Mecânica'; icone = 'create:water_wheel'
     subtitulo = 'Create básico, primeiras armas e a primeira artilharia.'
     quests = @(
      @{ k='e1_chave'; x=0; y=0; deps=@('q0_eras'); t=@('create:wrench=1'); r=@('create:andesite_alloy=4'); titulo='Chave inglesa'
         d=@('A ferramenta do Create: gira, ajusta e desmonta blocos (agachado + clique direito).', '', $DICA_PONDER) }
      @{ k='e1_liga'; x=1.5; y=0; deps=@('e1_chave'); t=@('create:andesite_alloy=16'); r=@(); titulo='Liga de andesito'
         d=@('Andesito + pepita de ferro (ou zinco). Quase tudo do começo do Create usa isso.') }
      @{ k='e1_roda'; x=3; y=-1; deps=@('e1_liga'); t=@('create:water_wheel=1'); r=@('create:shaft=8'); titulo='Primeira força'
         d=@('A roda d''água gira com água corrente e gera força rotacional.', 'Moinhos de vento também servem (veja no EMI).') }
      @{ k='e1_eixos'; x=4.5; y=-1; deps=@('e1_roda'); t=@('create:shaft=8', 'create:cogwheel=4'); r=@(); titulo='Eixos e engrenagens'
         d=@('Eixos levam a rotação em linha reta; engrenagens mudam direção e velocidade.') }
      @{ k='e1_oculos'; x=3; y=1; deps=@('e1_liga'); t=@('create:goggles=1'); r=@(); titulo='Óculos do engenheiro'
         d=@('Mostram velocidade e estresse das máquinas. Rede sobrecarregada = tudo para.') }
      @{ k='e1_prensa'; x=4.5; y=1; deps=@('e1_oculos'); t=@('create:mechanical_press=1'); r=@(); titulo='Prensa mecânica'
         d=@('Faz chapas (sheets) de metal — usadas em quase todas as máquinas e armas.') }
      @{ k='e1_carcaca'; x=6; y=1; deps=@('e1_prensa'); t=@('create:andesite_casing=8'); r=@(); titulo='Carcaça de andesito'
         d=@('Base de várias máquinas, inclusive o montador de física dos veículos.') }
      @{ k='e1_cola'; x=6; y=-1; deps=@('e1_eixos'); t=@('create:super_glue=1'); r=@(); titulo='Super cola'
         d=@('Gruda blocos para que se movam juntos. Todo veículo começa aqui — veja a trilha §fBarcos§r.') }
      @{ k='e1_bancada'; x=0; y=3; deps=@('e1_liga'); t=@('tacz:gun_smith_table=1'); r=@('minecraft:iron_ingot=16'); titulo='Bancada de armas'
         d=@('Aqui você monta as armas do TaCZ. Na Era 1 saem:', '§fpistolas comuns (M1911, Glock, CZ75…), Kar98, Springfield, SKS, escopetas de cano duplo e M870§r.', '', 'As outras armas aparecem na bancada, mas pedem material de eras seguintes (latão, aço, alumínio). Veja a página Informação da bancada no EMI.') }
      @{ k='e1_arma'; x=1.5; y=3; deps=@('e1_bancada'); t=@('check'); r=@('minecraft:gunpowder=16'); titulo='Primeira arma'
         d=@('Monte uma arma da Era 1 e a munição dela (bancada de munição do TaCZ).', '', 'Marque quando tiver feito.') }
      @{ k='e1_canhao'; x=3; y=3; deps=@('e1_bancada'); t=@('createbigcannons:cannon_mount=1', 'createbigcannons:cast_iron_cannon_barrel=2', 'createbigcannons:cast_iron_cannon_chamber=1'); r=@(); titulo='Canhão de ferro fundido'
         d=@('A primeira artilharia (Create Big Cannons): suporte + câmara + canos de ferro fundido.', 'Canos são fundidos com ferro derretido em moldes.', '', $DICA_PONDER) }
      @{ k='e1_projetil'; x=4.5; y=3; deps=@('e1_canhao'); t=@('createbigcannons:solid_shot=4', 'createbigcannons:powder_charge=4'); r=@(); titulo='Fogo!'
         d=@('Projétil sólido + cargas de pólvora. A ordem de carregar o canhão está no Ponder.') }
      @{ k='e1_balao'; x=6; y=3; deps=@('e1_cola'); t=@('aeronautics:white_envelope=8', 'aeronautics:adjustable_burner=1'); r=@(); titulo='Dirigível simples'
         d=@('Envelopes de ar quente + queimador = balão. A trilha §fVoando§r ensina a montar.') }
      @{ k='e1_proxima'; x=8; y=1; deps=@('e1_cola', 'e1_carcaca'); t=@('create:steam_engine=1'); r=@('create:andesite_alloy=32', 'minecraft:copper_ingot=16'); titulo='Rumo à Era 2: Vapor'; forma='gear'; tam=1.5
         d=@('§6Marco da Era 2: Motor a Vapor.§r Ter um no inventário leva você para a Era 2.', '', 'O motor a vapor do Create precisa de um §ftanque de fluido§r com água, aquecido por um §fqueimador de blaze§r. Veja o Ponder.') }
     ) }
  @{ arquivo = 'c2_era2'; titulo = 'Era 2 — Vapor'; icone = 'create:steam_engine'
     subtitulo = 'Latão, mecanismos de precisão e armas automáticas.'
     quests = @(
      @{ k='e2_inicio'; x=0; y=0; deps=@('e1_proxima'); t=@('check'); r=@(); titulo='Bem-vindo à Era 2'; forma='hexagon'
         d=@('Agora você tem vapor: força de sobra para máquinas grandes.', 'O material desta era é o §6latão§r. As armas e veículos daqui pedem latão e mecanismo de precisão.') }
      @{ k='e2_queimador'; x=1.5; y=-1; deps=@('e2_inicio'); t=@('create:blaze_burner=1'); r=@(); titulo='Queimador de blaze'
         d=@('Calor para o misturador e para o motor a vapor. Capture um blaze no Nether com um queimador vazio.') }
      @{ k='e2_misturador'; x=3; y=-1; deps=@('e2_queimador'); t=@('create:mechanical_mixer=1', 'create:basin=1'); r=@(); titulo='Misturador mecânico'
         d=@('Misturador sobre uma bacia: liga metais e faz receitas com calor.') }
      @{ k='e2_latao'; x=4.5; y=-1; deps=@('e2_misturador'); t=@('create:brass_ingot=16'); r=@(); titulo='Latão'
         d=@('Cobre + zinco no misturador, aquecido. §6É o material da Era 2.§r') }
      @{ k='e2_tubo'; x=4.5; y=-2.5; deps=@('e2_latao'); t=@('create:electron_tube=4'); r=@(); titulo='Tubo eletrônico'
         d=@('Componente de máquinas de latão e de controles.') }
      @{ k='e2_mecanismo'; x=6; y=-1; deps=@('e2_latao'); t=@('create:precision_mechanism=2'); r=@(); titulo='Mecanismo de precisão'
         d=@('Feito por montagem em sequência (veja o Ponder). Toda arma da Era 2 do TaCZ pede um.') }
      @{ k='e2_trem'; x=6; y=-2.5; deps=@('e2_mecanismo'); t=@('create:track=32', 'create:controls=1'); r=@(); titulo='Trens'
         d=@('Trilhos e controles de trem: logística pesada entre bases (e fronts).') }
      @{ k='e2_armas'; x=1.5; y=1.5; deps=@('e2_latao'); t=@('check'); r=@(); titulo='Armas da Era 2'
         d=@('Na bancada de armas do TaCZ agora saem, com §f+6 latão e 1 mecanismo de precisão§r:', '§fsubmetralhadoras (Uzi, MP5, UMP45, Vector, P90), B93R, Desert Eagle, Taurus 500, M1014, SPAS-12, M700, M16A1, Type 81§r.') }
      @{ k='e2_autocanhao'; x=3; y=1.5; deps=@('e2_latao'); t=@('createbigcannons:cast_iron_autocannon_barrel=1', 'createbigcannons:cast_iron_autocannon_breech=1', 'createbigcannons:autocannon_ammo_container=1'); r=@(); titulo='Autocanhão'
         d=@('Canhão de tiro rápido. A caixa de munição e os cartuchos pedem latão.') }
      @{ k='e2_metralhadora'; x=4.5; y=1.5; deps=@('e2_latao'); t=@('create_the_air_wars:machinegun=1'); r=@(); titulo='Metralhadora de aeronave'
         d=@('Metralhadora da Air War para montar em aviões (pede latão).') }
      @{ k='e2_helice'; x=6; y=1.5; deps=@('e2_latao'); t=@('aeronautics:propeller_bearing=1', 'aeronautics:andesite_propeller=1'); r=@(); titulo='Aeronaves médias'
         d=@('Rolamento de hélice + hélice de andesito: propulsão para aeronaves maiores. Veja a trilha §fVoando§r.') }
      @{ k='e2_coque'; x=7.5; y=-1; deps=@('e2_mecanismo'); t=@('tfmg:coke_oven=1', 'tfmg:coal_coke=8'); r=@(); titulo='Coque'
         d=@('O forno de coque do TFMG transforma carvão em §fcoque§r — o combustível do alto-forno.') }
      @{ k='e2_altoforno'; x=9; y=0; deps=@('e2_coque'); t=@('tfmg:blast_furnace_output=1', 'tfmg:blast_furnace_reinforcement=8'); r=@(); titulo='Alto-forno'
         d=@('Saída + reforços do alto-forno do TFMG. Alimentado com minério de ferro e coque, ele produz §faço§r.', $DICA_PONDER) }
      @{ k='e2_proxima'; x=10.5; y=0; deps=@('e2_altoforno'); t=@('tfmg:steel_ingot=1'); r=@('tfmg:steel_ingot=8'); titulo='Rumo à Era 3: Aço'; forma='gear'; tam=1.5
         d=@('§6Marco da Era 3: Lingote de Aço.§r', '', '§cO único aço do servidor é o do TFMG.§r O aço de outros mods (Superb Warfare, etc.) foi removido.') }
     ) }
  @{ arquivo = 'c3_era3'; titulo = 'Era 3 — Petróleo e Aço'; icone = 'tfmg:steel_ingot'
     subtitulo = 'Refinaria, aço e a guerra moderna.'
     quests = @(
      @{ k='e3_inicio'; x=0; y=0; deps=@('e2_proxima'); t=@('check'); r=@(); titulo='Bem-vindo à Era 3'; forma='hexagon'
         d=@('Aço e petróleo: aqui começa a guerra moderna.', 'Os materiais desta era são o §6aço§r e o §6enxofre§r do TFMG.') }
      @{ k='e3_blocoaco'; x=1.5; y=-1.5; deps=@('e3_inicio'); t=@('tfmg:steel_block=4'); r=@(); titulo='Blocos de aço'
         d=@('Muito aço vai ser preciso: canhões, bancadas, bombas.') }
      @{ k='e3_pumpjack'; x=1.5; y=-3; deps=@('e3_inicio'); t=@('tfmg:pumpjack_base=1', 'tfmg:pumpjack_crank=1', 'tfmg:pumpjack_hammer=1'); r=@(); titulo='Petróleo'
         d=@('A bomba de petróleo (pumpjack) extrai petróleo de jazidas no subsolo.', $DICA_PONDER) }
      @{ k='e3_destilaria'; x=3; y=-3; deps=@('e3_pumpjack'); t=@('tfmg:steel_distillation_controller=1', 'tfmg:steel_distillation_output=2'); r=@(); titulo='Refinaria'
         d=@('A torre de destilação separa o petróleo em diesel, gasolina, querosene e outros.') }
      @{ k='e3_diesel'; x=4.5; y=-3; deps=@('e3_destilaria'); t=@('tfmg:diesel_bucket=1'); r=@(); titulo='Diesel'
         d=@('Combustível dos motores do TFMG e de veículos.') }
      @{ k='e3_motor'; x=6; y=-3; deps=@('e3_diesel'); t=@('tfmg:regular_engine=1'); r=@(); titulo='Motor a combustão'
         d=@('Força rotacional muito maior que a do vapor, queimando combustível.') }
      @{ k='e3_enxofre'; x=3; y=-1.5; deps=@('e3_destilaria'); t=@('tfmg:sulfur_dust=8'); r=@(); titulo='Enxofre'
         d=@('Sai da refinaria. §6Material da Era 3§r: armas, munição Mk.III e bombas pedem enxofre.') }
      @{ k='e3_armas'; x=1.5; y=1.5; deps=@('e3_inicio'); t=@('check'); r=@(); titulo='Armas da Era 3'
         d=@('Na bancada de armas do TaCZ, com §f+10 aço e 2 enxofre§r:', '§fAK-47, M4A1, M16A4, HK416, G36K, AUG, QBZ-95, QBZ-191, SCAR-L/H, FN FAL, G3, MK14, SPR15, RPK, M249, AA-12, AWP§r.') }
      @{ k='e3_canhao'; x=3; y=1.5; deps=@('e3_blocoaco'); t=@('createbigcannons:steel_cannon_barrel=1', 'createbigcannons:steel_cannon_chamber=1'); r=@(); titulo='Canhão de aço'
         d=@('Canos de aço aguentam cargas muito maiores que os de ferro.') }
      @{ k='e3_mk3'; x=4.5; y=1.5; deps=@('e3_enxofre'); t=@('cbc_enhanced_shells:he_shell_mk3=1'); r=@(); titulo='Munição Mk.III'
         d=@('Mk.III = Mk.II + 2 aço + enxofre. Vale para todos os tipos de munição Enhanced Shells.') }
      @{ k='e3_bombas'; x=6; y=1.5; deps=@('e3_enxofre'); t=@('projectexplosive:munitions_workbench=1', 'projectexplosive:small_bomb=1'); r=@(); titulo='Bombas pequenas'
         d=@('A bancada de munições (Project Explosive) pede aço e enxofre. Bombas pequenas: Era 3.', 'Bombas grandes saem da mesma bancada, mas exigem a Era 4.') }
      @{ k='e3_sbw'; x=1.5; y=3; deps=@('e3_blocoaco'); t=@('superbwarfare:blueprint_research_table=1'); r=@(); titulo='Superb Warfare'
         d=@('A mesa de pesquisa de projetos (pede aço) libera as armas do Superb Warfare.', 'Os veículos do Superb Warfare são da Era 4.') }
      @{ k='e3_foguete'; x=3; y=3; deps=@('e3_blocoaco'); t=@('cbcaeronauticsmissiles:rocket_motor=1'); r=@(); titulo='Motor de foguete'
         d=@('Base dos mísseis (Simulated Missiles). A guiagem vem na Era 4.') }
      @{ k='e3_propulsor'; x=4.5; y=3; deps=@('e3_diesel'); t=@('createpropulsion:thruster=1'); r=@(); titulo='Propulsor'
         d=@('Empurra aeronaves com combustível. Veja a trilha §fVoando§r.') }
      @{ k='e3_blindagem'; x=6; y=3; deps=@('e3_blocoaco'); t=@('s_a_b:steelblock=16'); r=@(); titulo='Blindagem de aço'
         d=@('Blocos de blindagem (Steel Armor Blocks) para veículos e bunkers.') }
      @{ k='e3_gerador'; x=8; y=-1.5; deps=@('e3_motor'); t=@('tfmg:generator=1'); r=@(); titulo='Gerador'
         d=@('Transforma rotação em §feletricidade§r. Comece a rede elétrica.') }
      @{ k='e3_eletrico'; x=9.5; y=-1.5; deps=@('e3_gerador'); t=@('tfmg:electric_motor=1', 'tfmg:cable_connector=4'); r=@(); titulo='Rede elétrica'
         d=@('Cabos ligam geradores a motores elétricos.', $DICA_PONDER) }
      @{ k='e3_aluminio'; x=9.5; y=0; deps=@('e3_eletrico'); t=@('tfmg:aluminum_ingot=8'); r=@(); titulo='Alumínio'
         d=@('Feito com eletricidade. §6Material da Era 4.§r') }
      @{ k='e3_proxima'; x=11; y=0; deps=@('e3_aluminio'); t=@('tfmg:circuit_board=1'); r=@('tfmg:aluminum_ingot=8'); titulo='Rumo à Era 4: Eletricidade'; forma='gear'; tam=1.5
         d=@('§6Marco da Era 4: Placa de Circuito.§r', '', 'Placa vazia → revestida → gravada → placa de circuito (veja a cadeia no EMI).') }
     ) }
  @{ arquivo = 'c4_era4'; titulo = 'Era 4 — Eletricidade'; icone = 'tfmg:circuit_board'
     subtitulo = 'Eletrônica, armas pesadas, mísseis guiados e veículos.'
     quests = @(
      @{ k='e4_inicio'; x=0; y=0; deps=@('e3_proxima'); t=@('check'); r=@(); titulo='Bem-vindo à Era 4'; forma='hexagon'
         d=@('Circuitos e alumínio: armas guiadas e máquinas de guerra pesadas.', 'Materiais desta era: §6alumínio§r, §6placa de circuito§r e §6motor elétrico pesado§r.') }
      @{ k='e4_motor'; x=1.5; y=-1.5; deps=@('e4_inicio'); t=@('tfmg:heavy_electric_motor=1'); r=@(); titulo='Motor elétrico pesado'
         d=@('Peça-chave de ICBM, veículos do Superb Warfare e da Fat Man.') }
      @{ k='e4_energia'; x=3; y=-1.5; deps=@('e4_motor'); t=@('tfmg:accumulator=1', 'tfmg:transformer=1'); r=@(); titulo='Rede elétrica forte'
         d=@('Acumuladores guardam energia; transformadores ajustam a tensão.') }
      @{ k='e4_blocoal'; x=4.5; y=-1.5; deps=@('e4_energia'); t=@('tfmg:aluminum_block=4'); r=@(); titulo='Blocos de alumínio'
         d=@('Bunkers à prova total e a Fat Man pedem muito alumínio.') }
      @{ k='e4_armas'; x=1.5; y=1.5; deps=@('e4_inicio'); t=@('check'); r=@(); titulo='Armas da Era 4'
         d=@('Na bancada de armas do TaCZ, com §f+8 alumínio, 2 placas de circuito e 6 aço§r:', '§fM107, M95, FN Evolys, minigun, RPG-7, M320, Desert Eagle dourada, Timeless 50§r.') }
      @{ k='e4_mk5'; x=3; y=1.5; deps=@('e4_inicio'); t=@('cbc_enhanced_shells:he_shell_mk5=1'); r=@(); titulo='Munição Mk.V'
         d=@('Mk.IV = Mk.III + 2 alumínio + aço. Mk.V = Mk.IV + placa de circuito + 2 alumínio.') }
      @{ k='e4_mk84'; x=4.5; y=1.5; deps=@('e4_inicio'); t=@('projectexplosive:big_bomb=1'); r=@(); titulo='Bomba Mk 84'
         d=@('A bomba grande da bancada de munições. Exige a Era 4 — sem ela, o item é confiscado.') }
      @{ k='e4_icbm'; x=6; y=1.5; deps=@('e4_motor'); t=@('projectexplosive:icbm=1', 'projectexplosive:airstrike_caller=1'); r=@(); titulo='ICBM e ataque aéreo'
         d=@('Míssil balístico e chamada de ataque aéreo: alumínio, circuito e motor pesado.') }
      @{ k='e4_veiculos'; x=1.5; y=3; deps=@('e4_motor'); t=@('superbwarfare:vehicle_assembling_table=1'); r=@(); titulo='Veículos de guerra'
         d=@('A mesa de montagem de veículos do Superb Warfare pede motor elétrico pesado: tanques, helicópteros e jatos.') }
      @{ k='e4_missil'; x=3; y=3; deps=@('e4_inicio'); t=@('cbcaeronauticsmissiles:guidance_computer=1'); r=@(); titulo='Míssil guiado'
         d=@('O computador de guiagem pede placa de circuito. Junte com o motor de foguete da Era 3.') }
      @{ k='e4_jato'; x=4.5; y=3; deps=@('e4_inicio'); t=@('create_the_air_wars:rocket_engine=1', 'create_the_air_wars:chip=2'); r=@(); titulo='Jatos e mísseis da Air War'
         d=@('Turbina de avião e chips: mísseis guiados (AIM-9X, Tomahawk…), câmeras e sonar da Air War.') }
      @{ k='e4_radar'; x=6; y=3; deps=@('e4_inicio'); t=@('create_radar:radar_bearing=1', 'create_radar:radar_dish_block=4'); r=@(); titulo='Radar'
         d=@('Veja aeronaves e mísseis chegando, e controle canhões automáticos.') }
      @{ k='e4_bunker'; x=7.5; y=-1.5; deps=@('e4_blocoal'); t=@('stronger_blocks:reinforced_stone_bricks_ub=8'); r=@(); titulo='Bunker à prova total'
         d=@('Bloco reforçado + alumínio + bloco de aço. §cLimite de 128 por jogador.§r') }
      @{ k='e4_defletor'; x=7.5; y=0; deps=@('e4_blocoal'); t=@('weather2:weather_deflector=1'); r=@(); titulo='Defletor de tempestades'
         d=@('Desvia tornados e tempestades da sua base.') }
      @{ k='e4_detector'; x=9; y=0; deps=@('e4_defletor'); t=@('projectexplosive:radiation_detector=1', 'projectexplosive:raw_uranium=4'); r=@(); titulo='Urânio'
         d=@('Minério de urânio fica no fundo do mundo. O detector de radiação ajuda a achar.') }
      @{ k='e4_proxima'; x=10.5; y=0; deps=@('e4_detector'); t=@('projectexplosive:uranium_ingot=1'); r=@(); titulo='Rumo à Era 5: Fim de jogo'; forma='gear'; tam=1.5
         d=@('§6Marco da Era 5: Lingote de Urânio.§r') }
     ) }
  @{ arquivo = 'c5_era5'; titulo = 'Era 5 — Fim de jogo'; icone = 'projectexplosive:nuclear_bomb'
     subtitulo = 'A Fat Man.'
     quests = @(
      @{ k='e5_inicio'; x=0; y=0; deps=@('e4_proxima'); t=@('check'); r=@(); titulo='Bem-vindo à Era 5'; forma='hexagon'
         d=@('A última era. A única arma nuclear que um jogador pode fabricar é a §cFat Man§r, e ela custa uma indústria inteira.') }
      @{ k='e5_estrela'; x=1.5; y=-1.5; deps=@('e5_inicio'); t=@('minecraft:nether_star=1'); r=@(); titulo='Estrela do Nether'
         d=@('Derrote o Wither.') }
      @{ k='e5_placas'; x=1.5; y=0; deps=@('e5_inicio'); t=@('tfmg:coated_circuit_board=2'); r=@(); titulo='Placas revestidas'
         d=@('Duas placas de circuito revestidas.') }
      @{ k='e5_metais'; x=1.5; y=1.5; deps=@('e5_inicio'); t=@('tfmg:steel_block=16', 'tfmg:aluminum_block=8'); r=@(); titulo='Metal em volume'
         d=@('16 blocos de aço e 8 blocos de alumínio.') }
      @{ k='e5_uranio'; x=3; y=1.5; deps=@('e5_metais'); t=@('projectexplosive:uranium_ingot=8'); r=@(); titulo='Núcleo de urânio'
         d=@('8 lingotes de urânio.') }
      @{ k='e5_crafter'; x=3; y=-1.5; deps=@('e5_estrela'); t=@('create:mechanical_crafter=49'); r=@(); titulo='Crafter Mecânico 7x7'
         d=@('49 crafters mecânicos em um quadrado 7x7. Veja o Ponder.') }
      @{ k='e5_fatman'; x=5; y=0; deps=@('e5_placas', 'e5_uranio', 'e5_crafter'); t=@('check'); r=@(); titulo='Fat Man'; forma='gear'; tam=2
         d=@('Monte a Fat Man no Crafter Mecânico 7x7:', '§f16 blocos de aço, 8 blocos de alumínio, 8 urânio, 2 placas revestidas, 1 motor elétrico pesado, 1 bomba Mk 84 e 1 Estrela do Nether§r (formato no EMI).', '', '§cSó a Fat Man feita assim é válida§r — a da bancada de munições é confiscada.', 'Lembre: explosões só quebram blocos no horário de guerra.') }
     ) }
 ) }
 @{ k = 'g_trilhas'; titulo = 'Trilhas'; capitulos = @(
  @{ arquivo = 't1_barco'; titulo = 'Barcos'; icone = 'simulated:steering_wheel'
     subtitulo = 'Do casco de madeira à primeira viagem (Era 1–2).'
     quests = @(
      @{ k='c2_montador'; x=0; y=0; deps=@('e1_cola'); t=@('simulated:physics_assembler=1'); r=@(); titulo='Montador de física'
         d=@('Transforma um monte de blocos num veículo de verdade, com física.', '', '1. Construa o casco.', '2. Coloque o montador encostado nele.', '3. Dê um sinal de redstone no montador.', '', $DICA_PONDER) }
      @{ k='c2_casco'; x=1.5; y=0; deps=@('c2_montador'); t=@('check'); r=@('minecraft:oak_planks=64'); titulo='Monte o casco'
         d=@('Construa um casco simples de madeira na água e monte com o montador de física.', 'Madeira é leve e flutua bem; pedra e metal pesam. Teste perto da margem.') }
      @{ k='c2_timao'; x=3; y=-1; deps=@('c2_casco'); t=@('simulated:steering_wheel=1'); r=@(); titulo='Timão'
         d=@('Coloque no barco e use para pilotar.') }
      @{ k='c2_helice'; x=3; y=1; deps=@('c2_casco'); t=@('aeronautics:propeller_bearing=1', 'aeronautics:wooden_propeller=1'); r=@(); titulo='Hélice'
         d=@('Rolamento de hélice + hélice de madeira empurram o barco quando recebem rotação.') }
      @{ k='c2_motor'; x=4.5; y=1; deps=@('c2_helice'); t=@('simulated:white_portable_engine=1'); r=@(); titulo='Motor portátil'
         d=@('Fonte de força que vai junto com o veículo. Veja no Ponder como alimentar.') }
      @{ k='c2_leme'; x=4.5; y=-1; deps=@('c2_timao'); t=@('simulated:swivel_bearing=1'); r=@(); titulo='Leme'
         d=@('O rolamento giratório deixa uma parte virar: leme ou hélice direcionável.') }
      @{ k='c2_acelerador'; x=6; y=0; deps=@('c2_motor', 'c2_leme'); t=@('simulated:throttle_lever=1'); r=@(); titulo='Alavanca de aceleração'
         d=@('Controla a força enviada à hélice.') }
      @{ k='c2_viagem'; x=7.5; y=0; deps=@('c2_acelerador'); t=@('check'); r=@('create:andesite_alloy=16', 'minecraft:iron_ingot=16'); titulo='Primeira viagem'
         d=@('Navegue até outro bioma e volte com o barco inteiro.') }
     ) }
  @{ arquivo = 't2_voo'; titulo = 'Voando'; icone = 'aeronautics:white_envelope'
     subtitulo = 'Balão (Era 1), aeronave (Era 2–3) e avião.'
     quests = @(
      @{ k='c3_envelope'; x=0; y=0; deps=@('c2_casco'); t=@('aeronautics:white_envelope=8'); r=@(); titulo='Envelope de ar quente'
         d=@('Blocos que seguram ar quente. Mais envelopes cheios = mais sustentação.') }
      @{ k='c3_queimador'; x=1.5; y=0; deps=@('c3_envelope'); t=@('aeronautics:adjustable_burner=1'); r=@(); titulo='Queimador de ar quente'
         d=@('Embaixo dos envelopes. Com redstone você controla a chama: mais forte sobe, mais fraca desce.') }
      @{ k='c3_balao'; x=3; y=0; deps=@('c3_queimador'); t=@('check'); r=@('minecraft:string=32'); titulo='Primeiro balão'
         d=@('Monte um balão com cesto, envelopes e queimador, e suba pelo menos 50 blocos.') }
      @{ k='c3_levitita'; x=3; y=-1.5; deps=@('c3_envelope'); t=@('aeronautics:levitite=4'); r=@(); titulo='Levitita'
         d=@('Material que flutua sozinho. Deixa aeronaves pesadas mais leves.') }
      @{ k='c3_paraquedas'; x=3; y=1.5; deps=@('c3_envelope'); t=@('create_parachute:parachute_block=1'); r=@(); titulo='Paraquedas'
         d=@('Sempre leve um. Aeronave cai, ainda mais em guerra.') }
      @{ k='c3_asas'; x=4.5; y=-1; deps=@('c3_balao'); t=@('createpropulsion:wing=4'); r=@(); titulo='Asas'
         d=@('Asas geram sustentação com velocidade: é o que separa um balão de um avião.') }
      @{ k='c3_helice'; x=4.5; y=1; deps=@('c3_balao', 'e2_latao'); t=@('aeronautics:andesite_propeller=1'); r=@(); titulo='Hélice de andesito'
         d=@('Hélice mais forte para empurrar aeronaves (Era 2).') }
      @{ k='c3_propulsor'; x=6; y=-1; deps=@('c3_asas', 'e3_diesel'); t=@('createpropulsion:thruster=1'); r=@(); titulo='Propulsor'
         d=@('Empurra a aeronave com combustível (Era 3). Veja no Ponder o que ele queima.') }
      @{ k='c3_oculos'; x=6; y=1; deps=@('c3_helice'); t=@('aeronautics:aviators_goggles=1'); r=@(); titulo='Óculos de aviador'
         d=@('Todo piloto precisa de um.') }
      @{ k='c3_voo'; x=7.5; y=0; deps=@('c3_propulsor', 'c3_oculos'); t=@('check'); r=@('create_parachute:parachute_block=1'); titulo='Primeiro voo'
         d=@('Decole, voe 500 blocos e pouse com a aeronave inteira.') }
     ) }
  @{ arquivo = 't3_navegacao'; titulo = 'Navegação e controle'; icone = 'simulated:navigation_table'
     subtitulo = 'Sensores e redstone para pilotar melhor (e sozinho).'
     quests = @(
      @{ k='c4_mesa'; x=0; y=0; deps=@('c2_viagem'); t=@('simulated:navigation_table=1'); r=@(); titulo='Mesa de navegação'
         d=@('Ajuda a manter o rumo em viagens longas. Veja no Ponder.') }
      @{ k='c4_altitude'; x=1.5; y=-1; deps=@('c4_mesa', 'c3_balao'); t=@('simulated:altitude_sensor=1'); r=@(); titulo='Sensor de altitude'
         d=@('Redstone conforme a altura. Ligue no queimador para o balão parar sozinho numa altitude.') }
      @{ k='c4_gimbal'; x=1.5; y=1; deps=@('c4_mesa'); t=@('simulated:gimbal_sensor=1'); r=@(); titulo='Sensor de inclinação'
         d=@('Detecta a inclinação do veículo. Use com redstone para estabilizar.') }
      @{ k='c4_velocidade'; x=3; y=-1; deps=@('c4_altitude'); t=@('simulated:velocity_sensor=1'); r=@(); titulo='Sensor de velocidade'
         d=@('Mede a velocidade e emite redstone. Bom para controlar o acelerador.') }
      @{ k='c4_doca'; x=3; y=1; deps=@('c4_gimbal'); t=@('simulated:docking_connector=1'); r=@(); titulo='Conector de atracação'
         d=@('Prende um veículo em outro (ou num porto) sem bater.') }
      @{ k='c4_controle'; x=4.5; y=0; deps=@('c4_velocidade', 'c4_doca'); t=@('create:linked_controller=1'); r=@(); titulo='Controle remoto'
         d=@('Sinais de redstone sem fio: controle o veículo de qualquer lugar a bordo.') }
      @{ k='c4_auto'; x=6; y=0; deps=@('c4_controle'); t=@('check'); r=@('minecraft:redstone=32'); titulo='Piloto automático'
         d=@('Faça um veículo manter altitude ou rumo sozinho, com sensores e redstone.') }
     ) }
  @{ arquivo = 't4_defesa'; titulo = 'Defesa da base'; icone = 'stronger_blocks:reinforced_stone_bricks'
     subtitulo = 'Claims, muralhas, armadilhas e bunkers.'
     quests = @(
      @{ k='d_claim'; x=0; y=0; deps=@('q0_time'); t=@('check'); r=@(); titulo='Base protegida'
         d=@('Reivindique os chunks da sua base pelo mapa (§eM§r, clique direito). Dentro do claim ninguém de fora quebra nada.', 'Explosões no horário de guerra quebram blocos em qualquer lugar — por isso as muralhas.') }
      @{ k='d_reforcado'; x=1.5; y=0; deps=@('d_claim'); t=@('stronger_blocks:reinforced_stone_bricks=32'); r=@(); titulo='Muralha reforçada'
         d=@('Blocos reforçados aguentam muito mais explosões (Era 1: pedra + pepita de ferro).') }
      @{ k='d_vidro'; x=1.5; y=-1.5; deps=@('d_reforcado'); t=@('stronger_blocks:reinforced_glass=8'); r=@(); titulo='Vidro reforçado'
         d=@('Janelas que não estouram na primeira bomba.') }
      @{ k='d_arame'; x=3; y=-1.5; deps=@('d_claim'); t=@('minetraps:barbed_wire=16'); r=@(); titulo='Arame farpado'
         d=@('Atrasa e fere quem tenta passar (MineTraps).') }
      @{ k='d_minas'; x=4.5; y=-1.5; deps=@('d_arame'); t=@('minetraps:explosive_mine=4', 'minetraps:bear_trap=2'); r=@(); titulo='Minas e armadilhas'
         d=@('Minas explosivas e armadilhas de urso no caminho do inimigo.') }
      @{ k='d_copycat'; x=3; y=1.5; deps=@('d_reforcado'); t=@('copycats:copycat_block=8'); r=@(); titulo='Camuflagem'
         d=@('Blocos copycat imitam qualquer bloco: esconda portas, canhões e entradas.') }
      @{ k='d_aco'; x=4.5; y=0; deps=@('d_reforcado', 'e3_blocoaco'); t=@('s_a_b:steelblock=32'); r=@(); titulo='Blindagem de aço'
         d=@('Blocos de blindagem de aço (Era 3).') }
      @{ k='d_ub'; x=6; y=0; deps=@('d_aco', 'e4_blocoal'); t=@('stronger_blocks:reinforced_stone_bricks_ub=16'); r=@(); titulo='Bunker à prova total'
         d=@('À prova de qualquer explosão (Era 4). §cLimite de 128 por jogador§r — use no núcleo da base.') }
     ) }
 ) }
)

$lang = [ordered]@{}
$lang['file.0000000000000001.title'] = 'Modpack Guerra'
New-Item -ItemType Directory -Force (Join-Path $raiz 'chapters'), (Join-Path $raiz 'lang') | Out-Null
Get-ChildItem (Join-Path $raiz 'chapters') -Filter *.snbt | Remove-Item

$gruposSnbt = @()
$ordem = 0
$nQuests = 0
foreach ($g in $grupos) {
  $gid = Id "grupo:$($g.k)"
  $lang["chapter_group.$gid.title"] = $g.titulo
  $gruposSnbt += "`t`t{ id: $(Str $gid) }"
  foreach ($c in $g.capitulos) {
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
      $extra = ''
      if ($q.forma) { $extra += "`n`t`t`tshape: $(Str $q.forma)" }
      if ($q.tam) { $extra += "`n`t`t`tsize: $(Num $q.tam)" }
      $qs += "`t`t{`n`t`t`tdependencies: [$deps]`n`t`t`tid: $(Str $qid)`n`t`t`trewards: [$($recompensas -join ', ')]$extra`n`t`t`ttasks: [$($tarefas -join ', ')]`n`t`t`tx: $(Num $q.x)`n`t`t`ty: $(Num $q.y)`n`t`t}"
      $nQuests++
    }
    $snbt = "{`n`tdefault_hide_dependency_lines: false`n`tdefault_quest_shape: `"`"`n`tfilename: $(Str $c.arquivo)`n`tgroup: $(Str $gid)`n`ticon: { count: 1, id: $(Str $c.icone) }`n`tid: $(Str $cid)`n`torder_index: $ordem`n`tquest_links: [ ]`n`tquests: [`n$($qs -join "`n")`n`t]`n}`n"
    [IO.File]::WriteAllText((Join-Path $raiz "chapters\$($c.arquivo).snbt"), $snbt, $utf8)
    $ordem++
  }
}
[IO.File]::WriteAllText((Join-Path $raiz 'chapter_groups.snbt'), "{`n`tchapter_groups: [`n$($gruposSnbt -join "`n")`n`t]`n}`n", $utf8)

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
Write-Host "Quests geradas: $($grupos.Count) grupos, $ordem capítulos, $nQuests quests em $raiz"
