// Modpack Guerra — eras de progressão (estágio por jogador: era1 … era5).
// A trava de verdade está nas receitas (cada arma pede o material da indústria da era, ver
// progressao.js e kubejs/data/tacz). O estágio serve para: anunciar a subida de era, o /era
// e as regras de armas_restritas.js (bombas grandes exigem era4).
// Sobe de era quem tiver no inventário o item-marco da era. Detalhes em PROGRESSAO.md.

const ERA_LISTA = [
  { n: 1, nome: 'Mecânica', marco: null, marcoNome: '',
    libera: 'Create básico, pistolas/rifles clássicos/escopetas do TaCZ, canhões de ferro fundido do CBC, barcos e balões' },
  { n: 2, nome: 'Vapor', marco: 'create:steam_engine', marcoNome: 'Motor a Vapor (Create)',
    libera: 'submetralhadoras e armas semiautomáticas do TaCZ (latão + mecanismo de precisão), autocanhões (cartucho de latão), hélices e aeronaves médias, trens' },
  { n: 3, nome: 'Petróleo e Aço', marco: 'tfmg:steel_ingot', marcoNome: 'Lingote de Aço (TFMG)',
    libera: 'fuzis de assalto, metralhadoras e snipers do TaCZ, canhões de aço do CBC, Enhanced Shells Mk.III, bombas pequenas (bancada de munições), pesquisa de armas do Superb Warfare, foguetes do CBC AT, motor de foguete dos mísseis, propulsores' },
  { n: 4, nome: 'Eletricidade', marco: 'tfmg:circuit_board', marcoNome: 'Placa de Circuito (TFMG)',
    libera: 'armas pesadas do TaCZ (RPG, minigun, .50), Shells Mk.IV–V, bombas grandes Mk 84, ICBM, ataque aéreo, veículos do Superb Warfare, mísseis guiados, jatos da Air War, blocos à prova total, defletor de tempestades' },
  { n: 5, nome: 'Fim de jogo', marco: 'projectexplosive:uranium_ingot', marcoNome: 'Lingote de Urânio (Project Explosive)',
    libera: 'Fat Man (bomba nuclear) no Crafter Mecânico 7x7' }
]

function eraDoJogador(player) {
  let atual = 1
  ERA_LISTA.forEach(e => { if (player.stages.has('era' + e.n)) atual = Math.max(atual, e.n) })
  return atual
}

function eraInfo(n) { return ERA_LISTA[Math.max(1, Math.min(5, n)) - 1] }

// Define a era exata (sobe ou desce). anunciar = avisa o servidor inteiro.
function eraDefinir(player, n, anunciar) {
  const antes = eraDoJogador(player)
  ERA_LISTA.forEach(e => {
    if (e.n <= n) { if (!player.stages.has('era' + e.n)) player.stages.add('era' + e.n) }
    else if (player.stages.has('era' + e.n)) player.stages.remove('era' + e.n)
  })
  if (anunciar && n > antes) {
    const e = eraInfo(n)
    player.server.tell(Text.of(`§6§l[Era] §e${player.username} §6entrou na Era ${n}: ${e.nome}!`))
    player.tell(Text.of(`§7Agora você pode fabricar: §f${e.libera}`))
    if (n < 5) player.tell(Text.of(`§7Próxima era: §f${eraInfo(n + 1).nome}§7 — consiga um(a) §f${eraInfo(n + 1).marcoNome}§7. Digite §e/era§7 para ver tudo.`))
    player.server.runCommandSilent(`playsound minecraft:ui.toast.challenge_complete master ${player.username}`)
  }
}

PlayerEvents.loggedIn(event => {
  const player = event.player
  if (!player.stages.has('era1')) {
    player.stages.add('era1')
    player.tell(Text.of('§6[Era] §eBem-vindo à Era 1: Mecânica.§7 Cada era libera armas e veículos novos. Abra o livro de quests (tecla §eL§7) ou digite §e/era§7.'))
  }
})

PlayerEvents.inventoryChanged(event => {
  const player = event.player
  const item = event.item
  if (!player || item.isEmpty()) return
  const id = item.id
  for (let i = 1; i < ERA_LISTA.length; i++) {
    const e = ERA_LISTA[i]
    if (e.marco === id && eraDoJogador(player) < e.n) { eraDefinir(player, e.n, true); return }
  }
})

function eraMostrar(src, player) {
  const n = eraDoJogador(player)
  src.sendSystemMessage(Text.of(`§6§l[Era] §eVocê está na Era ${n}: ${eraInfo(n).nome}`))
  ERA_LISTA.forEach(e => {
    const cor = e.n <= n ? '§a✔' : '§8✖'
    const marco = e.marco ? ` §8(marco: ${e.marcoNome})` : ''
    src.sendSystemMessage(Text.of(`${cor} §fEra ${e.n} — ${e.nome}${marco}\n   §7${e.libera}`))
  })
}

// Classes carregadas uma vez só, com nomes únicos (o Rhino reclama de "redeclaration of var"
// quando um const com o mesmo nome é criado de novo dentro do evento).
let ERA_ARG_JOGADOR = null
let ERA_ARG_NUMERO = null
try {
  ERA_ARG_JOGADOR = Java.loadClass('net.minecraft.commands.arguments.EntityArgument')
  ERA_ARG_NUMERO = Java.loadClass('com.mojang.brigadier.arguments.IntegerArgumentType')
} catch (e) { console.warn('[Era] argumentos de comando indisponíveis: ' + e) }

ServerEvents.commandRegistry(event => {
  const Commands = event.commands
  try {
    let raiz = Commands.literal('era').executes(ctx => {
      const p = ctx.source.getPlayer()
      if (!p) { ctx.source.sendSystemMessage(Text.of('Use dentro do jogo.')); return 0 }
      eraMostrar(ctx.source, p)
      return 1
    })
    if (ERA_ARG_JOGADOR && ERA_ARG_NUMERO) {
      raiz = raiz.then(Commands.literal('definir').requires(src => src.hasPermission(2))
        .then(Commands.argument('jogador', ERA_ARG_JOGADOR.player())
          .then(Commands.argument('era', ERA_ARG_NUMERO.integer(1, 5)).executes(ctx => {
            const alvo = ERA_ARG_JOGADOR.getPlayer(ctx, 'jogador')
            const n = ERA_ARG_NUMERO.getInteger(ctx, 'era')
            eraDefinir(alvo, n, true)
            ctx.source.sendSystemMessage(Text.of(`§e[Era] ${alvo.username} agora está na Era ${n}.`))
            return 1
          }))))
    }
    event.register(raiz)
  } catch (e) { console.error('[Era] falha ao registrar /era: ' + e) }
})
