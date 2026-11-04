// Modpack Guerra — notas no EMI (aba "Informação" do item) explicando eras e regras do servidor.
// Fonte das regras: progressao.js, eras.js, armas_restritas.js e PROGRESSAO.md.

RecipeViewerEvents.addInformation('item', event => {
  const info = (itens, linhas) => { try { event.add(itens, linhas.map(l => Text.of(l))) } catch (e) { console.warn('[Info] ' + itens + ': ' + e) } }

  // ---- Marcos de era ----
  info('create:steam_engine', ['§6Marco da Era 2 — Vapor', 'Ter um Motor a Vapor no inventário leva você para a Era 2.', 'Libera: submetralhadoras e armas semiautomáticas do TaCZ, autocanhões, hélices, trens.', 'Digite /era para ver sua era.'])
  info('tfmg:steel_ingot', ['§6Marco da Era 3 — Petróleo e Aço', 'Ter um lingote de aço leva você para a Era 3.', '§cO único aço do servidor é o do TFMG (alto-forno). Aço de outros mods foi removido.', 'Libera: fuzis, metralhadoras e snipers do TaCZ, canhões de aço, Mk.III, bombas pequenas, Superb Warfare, foguetes.'])
  info('tfmg:circuit_board', ['§6Marco da Era 4 — Eletricidade', 'Ter uma placa de circuito leva você para a Era 4.', 'Libera: armas pesadas do TaCZ, Mk.IV–V, bombas Mk 84, ICBM, ataque aéreo, veículos do Superb Warfare, mísseis guiados, jatos, blocos à prova total.'])
  info('projectexplosive:uranium_ingot', ['§6Marco da Era 5 — Fim de jogo', 'Ter um lingote de urânio leva você para a Era 5.', 'Libera a receita da Fat Man no Crafter Mecânico 7x7.'])

  // ---- Armas do TaCZ ----
  const armas = ['§6Armas do TaCZ por era (bancada de armas):',
    '§fEra 1: §7pistolas comuns, Kar98, Springfield, SKS, escopetas de cano duplo e M870 (ferro e madeira).',
    '§fEra 2: §7submetralhadoras, Desert Eagle, Taurus 500, M1014, SPAS-12, M700, M16A1, Type 81 §8(+ latão e mecanismo de precisão)',
    '§fEra 3: §7fuzis de assalto, RPK, M249, AA-12, AWP §8(+ aço e enxofre do TFMG)',
    '§fEra 4: §7M107, M95, Evolys, minigun, RPG-7, M320 §8(+ alumínio, placa de circuito e aço)']
  info('tacz:gun_smith_table', armas)
  info('tacz:modern_kinetic_gun', armas)

  // ---- Canhões ----
  info(['createbigcannons:cast_iron_cannon_barrel', 'createbigcannons:cast_iron_cannon_chamber'], ['§6Era 1', 'Canhões de ferro fundido: a primeira artilharia.'])
  info(['createbigcannons:cast_iron_autocannon_breech', 'createbigcannons:autocannon_ammo_container'], ['§6Era 2', 'Autocanhões usam caixas e cartuchos de latão.'])
  info(['createbigcannons:steel_cannon_barrel', 'createbigcannons:built_up_steel_cannon_barrel', 'createbigcannons:steel_cannon_chamber', 'createbigcannons:steel_screw_breech'], ['§6Era 3', 'Canhões de aço exigem aço do TFMG derretido.'])
  info('cbc_enhanced_shells:he_shell_mk3', ['§6Era 3', 'Mk.III = Mk.II + 2 aço + enxofre (vale para todos os tipos de munição Enhanced).'])
  info('cbc_enhanced_shells:he_shell_mk4', ['§6Era 4', 'Mk.IV = Mk.III + 2 alumínio + aço.'])
  info('cbc_enhanced_shells:he_shell_mk5', ['§6Era 4', 'Mk.V = Mk.IV + placa de circuito + 2 alumínio.'])

  // ---- Bombas (Project Explosive) ----
  info('projectexplosive:munitions_workbench', ['§6Era 3', 'Receita pede aço e enxofre.', 'Bombas pequenas: Era 3. Bombas grandes (Mk 84): §cexigem a Era 4§r — sem ela, o item é confiscado.', '§cA Fat Man montada aqui é confiscada§r: a única forma legítima é o Crafter Mecânico 7x7.'])
  info(['projectexplosive:big_bomb', 'projectexplosive:big_bomb_frag', 'projectexplosive:icbm_big'], ['§6Era 4', '§cSem a Era 4 (placa de circuito), o item some do inventário.'])
  info(['projectexplosive:icbm', 'projectexplosive:airstrike_caller'], ['§6Era 4', 'Receita pede alumínio, placa de circuito e motor elétrico pesado.'])
  info('projectexplosive:nuclear_bomb', ['§6Era 5 — Fat Man', 'Só vale a feita no §eCrafter Mecânico 7x7§r do Create:', '16 blocos de aço, 8 blocos de alumínio, 8 urânio, 2 placas revestidas,', '1 motor elétrico pesado, 1 bomba Mk 84 e 1 Estrela do Nether.', '§cQualquer outra Fat Man é confiscada.'])
  info(['projectexplosive:icbm_nuclear', 'cbc_enhanced_shells:nuke_shell', 'cbc_enhanced_shells:nuke_shell_mk2', 'cbc_enhanced_shells:h_bomb_shell', 'cbc_enhanced_shells:h_bomb_mini_shell'], ['§cSó em eventos do servidor.', 'Não tem receita; jogadores que não são admin têm o item confiscado.'])

  // ---- Superb Warfare / mísseis / Air War ----
  info('superbwarfare:blueprint_research_table', ['§6Era 3', 'Pede aço: as armas do Superb Warfare começam na Era 3.'])
  info('superbwarfare:vehicle_assembling_table', ['§6Era 4', 'Pede motor elétrico pesado do TFMG: tanques, helicópteros e jatos são da Era 4.'])
  info('cbcaeronauticsmissiles:rocket_motor', ['§6Era 3', 'Motor de foguete dos mísseis (pede aço).'])
  info('cbcaeronauticsmissiles:guidance_computer', ['§6Era 4', 'Computador de guiagem pede placa de circuito: mísseis guiados são da Era 4.'])
  info('create_the_air_wars:machinegun', ['§6Era 2', 'Pede latão.'])
  info(['create_the_air_wars:explosive', 'create_the_air_wars:rocketengine'], ['§6Era 3', 'Pede aço: bombas e foguetes da Air War.'])
  info(['create_the_air_wars:chip', 'create_the_air_wars:rocket_engine'], ['§6Era 4', 'Pede placa de circuito: mísseis guiados, câmeras, sonar e turbina de avião.'])

  // ---- Defesa ----
  info(/^stronger_blocks:.*_ub$/, ['§6Era 4 — Bunker', 'Bloco à prova total: 2 blocos reforçados + alumínio + bloco de aço.', '§cLimite: 128 por jogador.'])
  info('weather2:weather_deflector', ['§6Era 4', 'Desvia tempestades e tornados da base.'])
})
