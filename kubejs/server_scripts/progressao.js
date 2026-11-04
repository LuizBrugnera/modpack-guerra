// Modpack Guerra — árvore de progressão.
// Cada tier de arma exige o material do tier da indústria (TFMG).
// IDs conferidos nos jars: CBC 5.11.7, CBC Enchanced Shells 1.5.1, Project: Explosive 0.7.2,
// TFMG Community Edition 1.3.3, Stronger Blocks 1.5.0, Weather2 2.8.7.

// Materiais por era
const ERA3 = { aco: 'tfmg:steel_ingot', enxofre: 'tfmg:sulfur_dust', blocoAco: 'tfmg:steel_block' }
const ERA4 = { aluminio: 'tfmg:aluminum_ingot', circuito: 'tfmg:circuit_board', motor: 'tfmg:heavy_electric_motor' }

// Tipos de munição do CBC Enchanced Shells que têm Mk.I–V
const TIPOS_SHELL = [
  'aa_missile', 'ap_shell', 'ap_shot', 'bag_of_grapeshot', 'bunker_buster_shell', 'cluster_missile',
  'cluster_shell', 'disintegration_shell', 'drop_mortar_shell', 'gravitational_shell', 'heavy_missile',
  'he_shell', 'mortar_stone', 'plasma_shell', 'powder_charge', 'shell_holder', 'shrapnel_shell',
  'singularity_shell', 'small_missile_fragmentation', 'small_missile_he', 'small_missile_incendiary',
  'smoke_shell', 'solid_shot', 'vortex_shell'
]

ServerEvents.recipes(event => {
  // ---------- Era 3: aço só do TFMG ----------
  // O aço do CBC (canhões de aço, autocanhões de aço) vem do aço derretido, que só entra
  // pelo tag c:ingots/steel. Removemos qualquer outra fonte de lingote de aço fora do TFMG/CBC.
  event.remove({ output: '#c:ingots/steel', not: [{ mod: 'tfmg' }, { mod: 'createbigcannons' }] })

  // ---------- Era 3: bancada de bombas do Project Explosive exige aço e enxofre ----------
  // As bombas pequenas/grandes são montadas nessa bancada (lógica interna do mod).
  event.remove({ id: 'projectexplosive:munitions_workbench' })
  event.shaped('projectexplosive:munitions_workbench', ['SSS', 'ECE', 'P P'], {
    S: ERA3.aco, E: ERA3.enxofre, C: 'minecraft:crafting_table', P: '#minecraft:planks'
  })

  // ---------- Enhanced Shells: Mk.III (Era 3), Mk.IV e Mk.V (Era 4) ----------
  // Substitui os upgrades originais (diamante, esmeralda, netherite…) por materiais industriais.
  event.remove({ id: /^cbc_enhanced_shells:.*_mk[345]$/ })
  TIPOS_SHELL.forEach(t => {
    const p = n => `cbc_enhanced_shells:${t}_mk${n}`
    event.shapeless(p(3), [p(2), ERA3.aco, ERA3.aco, ERA3.enxofre])
    event.shapeless(p(4), [p(3), ERA4.aluminio, ERA4.aluminio, ERA3.aco])
    event.shapeless(p(5), [p(4), ERA4.circuito, ERA4.aluminio, ERA4.aluminio])
  })

  // ---------- Era 4: ICBM e chamada de ataque aéreo ----------
  event.remove({ id: 'projectexplosive:icbm' })
  event.shaped('projectexplosive:icbm', ['ACA', 'SXS', 'AMA'], {
    A: ERA4.aluminio, C: ERA4.circuito, S: ERA3.blocoAco, X: 'minecraft:spyglass', M: ERA4.motor
  })
  event.remove({ id: 'projectexplosive:airstrike_caller' })
  event.shaped('projectexplosive:airstrike_caller', ['BCB', 'AEA', 'ADA'], {
    B: 'minecraft:blaze_rod', C: ERA4.circuito, A: ERA4.aluminio, E: 'minecraft:ender_eye', D: 'minecraft:diamond'
  })

  // ---------- Era 5: nucleares nunca craftáveis (só admin/evento) ----------
  event.remove({ output: 'cbc_enhanced_shells:nuke_shell' })
  event.remove({ output: 'cbc_enhanced_shells:nuke_shell_mk2' })
  event.remove({ output: 'cbc_enhanced_shells:h_bomb_shell' })
  event.remove({ output: 'cbc_enhanced_shells:h_bomb_mini_shell' })
  event.remove({ output: 'projectexplosive:nuclear_bomb' })
  event.remove({ output: 'projectexplosive:icbm_nuclear' })

  // Fat Man (projectexplosive:nuclear_bomb): única forma legítima = Crafter Mecânico 7x7 (Era 5).
  // A bancada de munição do mod também monta a Fat Man (lógica interna, sem receita editável):
  // essas saem SEM a marca 'guerra_autorizada' e são confiscadas por armas_restritas.js.
  event.recipes.create.mechanical_crafting(
    Item.of('projectexplosive:nuclear_bomb[minecraft:custom_data={guerra_autorizada:1b}]'),
    [
      '  SSS  ',
      ' SAUAS ',
      'SAUMUAS',
      'SUCNCUS',
      'SAUBUAS',
      ' SAUAS ',
      '  SSS  '
    ],
    {
      S: ERA3.blocoAco,                    // 16 blocos de aço
      A: 'tfmg:aluminum_block',            // 8 blocos de alumínio
      U: 'projectexplosive:uranium_ingot', // 8 lingotes de urânio
      C: 'tfmg:coated_circuit_board',      // 2 placas de circuito revestidas
      M: ERA4.motor,                       // 1 motor elétrico pesado
      B: 'projectexplosive:big_bomb',      // 1 bomba Mk 84 (Era 4)
      N: 'minecraft:nether_star'           // 1 estrela do Nether
    }
  )

  // ---------- Bunkers: blocos "à prova total" (_ub) só na Era 4, caros ----------
  // Os reforçados normais (pedra + pepita de ferro) continuam liberados cedo.
  // bloco à prova total ← bloco reforçado normal
  const UB = {
    reinforced_cobblestone_ub: 'reinforced_cobblestone',
    reinforced_deepslate_ub: 'reinforced_cobbled_deepslate',
    reinforced_stone_bricks_ub: 'reinforced_stone_bricks',
    reinforced_smooth_stone_ub: 'reinforced_smooth_stone',
    reinforced_polished_deepslate_ub: 'reinforced_polished_deepslate',
    reinforced_deepslate_bricks_ub: 'reinforced_deepslatebricks',
    reinforced_glass_ub: 'reinforced_glass'
  }
  event.remove({ id: /^stronger_blocks:.*_ub.*$/ })
  Object.keys(UB).forEach(ub => {
    event.shaped(Item.of(`stronger_blocks:${ub}`, 2), ['RAR', 'ASA', 'RAR'], {
      R: `stronger_blocks:${UB[ub]}`, A: ERA4.aluminio, S: ERA3.blocoAco
    })
  })

  // ---------- Mods de guerra adicionados depois: cada peça-chave pede o material da era ----------
  // (as receitas que já usam #c:ingots/steel ficam na Era 3 sozinhas: o único aço é o do TFMG/CBC.
  //  Ex.: bancada de pesquisa do Superb Warfare, motor de foguete dos mísseis.)
  // Era 2 — metralhadora da Air War pede latão
  event.replaceInput({ output: 'create_the_air_wars:machinegun' }, 'minecraft:iron_ingot', 'create:brass_ingot')
  // Era 3 — explosivo e motor de foguete pequeno da Air War pedem aço (bombas e mísseis)
  event.replaceInput({ output: 'create_the_air_wars:explosive' }, 'create_the_air_wars:titaniumingot', ERA3.aco)
  event.replaceInput({ output: 'create_the_air_wars:rocketengine' }, 'create_the_air_wars:titaniumingot', ERA3.aco)
  // Era 4 — eletrônica: chip da Air War (mísseis guiados, câmeras, sonar), turbina dos aviões,
  // computador de guiagem dos mísseis e bancada de veículos do Superb Warfare
  event.replaceInput({ output: 'create_the_air_wars:chip' }, 'minecraft:copper_ingot', ERA4.circuito)
  event.replaceInput({ output: 'create_the_air_wars:rocket_engine' }, 'create:display_link', ERA4.circuito)
  event.replaceInput({ output: 'cbcaeronauticsmissiles:guidance_computer' }, 'create:electron_tube', ERA4.circuito)
  event.replaceInput({ output: 'superbwarfare:vehicle_assembling_table' }, '#c:storage_blocks/iron', ERA4.motor)

  // ---------- Clima: Deflector de tempestades = fim de jogo (Era 4+) ----------
  event.remove({ id: 'weather2:weather_deflector' })
  event.shaped('weather2:weather_deflector', ['SCS', 'MWM', 'SCS'], {
    S: ERA3.blocoAco, C: ERA4.circuito, M: ERA4.motor, W: 'weather2:weather_item'
  })
})
