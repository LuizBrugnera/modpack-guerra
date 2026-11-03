// Modpack Guerra — itens restritos que a bancada do Project Explosive monta por lógica interna
// (não dá para trocar a receita). Regras:
//  - Nucleares: só admin (op) pode ter. Para eventos, um admin entrega/usa.
//  - Bombas grandes (Mk 84) e ICBM grande: só quem já chegou na Era 4
//    (estágio 'era4', ganho ao ter uma placa de circuito do TFMG no inventário).
//  - Blocos à prova total (_ub): limite de colocação por jogador.

const NUCLEARES = [
  'projectexplosive:nuclear_bomb', 'projectexplosive:icbm_nuclear',
  'cbc_enhanced_shells:nuke_shell', 'cbc_enhanced_shells:nuke_shell_mk2',
  'cbc_enhanced_shells:h_bomb_shell', 'cbc_enhanced_shells:h_bomb_mini_shell'
]
const ERA4_ITENS = [
  'projectexplosive:big_bomb', 'projectexplosive:big_bomb_armed', 'projectexplosive:big_bomb_head',
  'projectexplosive:big_bomb_frag', 'projectexplosive:big_bomb_frag_head', 'projectexplosive:icbm_big'
]
const GATILHO_ERA4 = 'tfmg:circuit_board'
const LIMITE_UB = 128

PlayerEvents.inventoryChanged(event => {
  const player = event.player
  const item = event.item
  if (!player || item.isEmpty()) return
  const id = item.id

  if (id === GATILHO_ERA4 && !player.stages.has('era4')) {
    player.stages.add('era4')
    player.tell(Text.of('§6[Progressão] Era 4 (Eletricidade) liberada: bombas grandes e ICBM grande.'))
    return
  }
  if (player.hasPermissions(2)) return

  if (NUCLEARES.includes(id)) {
    item.setCount(0)
    player.tell(Text.of('§c[Guerra] Armas nucleares só existem em eventos do servidor.'))
  } else if (ERA4_ITENS.includes(id) && !player.stages.has('era4')) {
    item.setCount(0)
    player.tell(Text.of('§c[Progressão] Bombas grandes exigem a Era 4 (fabrique uma placa de circuito do TFMG).'))
  }
})

BlockEvents.placed(event => {
  const player = event.player
  if (!player || player.hasPermissions(2)) return
  const id = event.block.id
  if (!id.startsWith('stronger_blocks:') || !id.endsWith('_ub')) return
  const usados = player.persistentData.getInt('blocos_ub')
  if (usados >= LIMITE_UB) {
    player.tell(Text.of(`§c[Bunker] Limite de ${LIMITE_UB} blocos à prova total atingido.`))
    event.cancel()
    return
  }
  player.persistentData.putInt('blocos_ub', usados + 1)
})
