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

  // ---------- Clima: Deflector de tempestades = fim de jogo (Era 4+) ----------
  event.remove({ id: 'weather2:weather_deflector' })
  event.shaped('weather2:weather_deflector', ['SCS', 'MWM', 'SCS'], {
    S: ERA3.blocoAco, C: ERA4.circuito, M: ERA4.motor, W: 'weather2:weather_item'
  })
})
