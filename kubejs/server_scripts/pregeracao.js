// Pré-geração do mapa com o Chunky, sem atrapalhar quem está jogando.
//
// O Chunky gera ~18 chunks/s neste pack e deixa o servidor pesado enquanto roda.
// Por isso: quando alguém entra, a pré-geração pausa; quando o último sai, ela continua.
// (Com "continueOnRestart" no config do Chunky, ela também volta depois de reiniciar.)
//
// Para começar (uma vez, no console do servidor):
//   chunky worldborder      -> usa a borda do mundo como área
//   chunky start
// Ver andamento: chunky progress    Cancelar de vez: chunky cancel

PlayerEvents.loggedIn(event => {
  event.server.runCommandSilent('chunky pause')
})

PlayerEvents.loggedOut(event => {
  // Neste evento o jogador que está saindo ainda conta na lista.
  if (event.server.getPlayerCount() <= 1) {
    event.server.runCommandSilent('chunky continue')
  }
})
