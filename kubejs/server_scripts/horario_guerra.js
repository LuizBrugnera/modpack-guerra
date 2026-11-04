// Modpack Guerra — horário de guerra.
// Fora do horário, explosões ainda ferem entidades, mas NÃO quebram blocos.
// Admin: /guerra on | off | auto | status

const JANELAS = [
  { dia: 5, inicio: 20, fim: 23 }, // sexta 20h–23h
  { dia: 6, inicio: 20, fim: 23 }  // sábado 20h–23h
]
const FUSO = 'America/Sao_Paulo'

function horaLocal() {
  try {
    const ZonedDateTime = Java.loadClass('java.time.ZonedDateTime')
    const ZoneId = Java.loadClass('java.time.ZoneId')
    const t = ZonedDateTime.now(ZoneId.of(FUSO))
    // DayOfWeek: 1 = segunda … 7 = domingo → converter para 0 = domingo … 6 = sábado
    return { dia: t.getDayOfWeek().getValue() % 7, hora: t.getHour() }
  } catch (e) {
    const d = new Date() // fallback: fuso da máquina do servidor
    return { dia: d.getDay(), hora: d.getHours() }
  }
}

function dentroDaJanela() {
  const agora = horaLocal()
  return JANELAS.some(j => agora.dia === j.dia && agora.hora >= j.inicio && agora.hora < j.fim)
}

// modo salvo no mundo: 'auto' (segue as janelas), 'on' (guerra forçada), 'off' (paz forçada)
function modo(server) {
  const m = server.persistentData.getString('guerra_modo')
  return m ? m : 'auto'
}

function emGuerra(server) {
  const m = modo(server)
  if (m === 'on') return true
  if (m === 'off') return false
  return dentroDaJanela()
}

LevelEvents.afterExplosion(event => {
  if (!emGuerra(event.level.server)) event.removeAllAffectedBlocks()
})

// As bombas do Project Explosive não passam pelo evento de explosão acima: escrevem os blocos
// direto no mundo. A proteção delas fica no mod de correções (guerra-correcoes, classe
// ProtecaoBombas), que precisa saber se é guerra ou paz. Atualiza a cada segundo e no /guerra.
let GUERRA_PROTECAO_BOMBAS = null
try {
  GUERRA_PROTECAO_BOMBAS = Java.loadClass('guerra.weather2fix.ProtecaoBombas')
} catch (e) {
  console.warn('[Guerra] ProtecaoBombas indisponível (bombas do Project Explosive sem proteção de horário): ' + e)
}

function avisarProtecaoBombas(server) {
  if (GUERRA_PROTECAO_BOMBAS) GUERRA_PROTECAO_BOMBAS.definirPaz(!emGuerra(server))
}

ServerEvents.tick(event => {
  if (event.server.tickCount % 20 === 0) avisarProtecaoBombas(event.server)
})

ServerEvents.commandRegistry(event => {
  const Commands = event.commands

  const definir = novo => ctx => {
    const server = ctx.source.server
    server.persistentData.putString('guerra_modo', novo)
    avisarProtecaoBombas(server)
    const txt = novo === 'on' ? '§c[Guerra] Modo GUERRA forçado: explosões quebram blocos.'
      : novo === 'off' ? '§a[Guerra] Modo PAZ forçado: explosões não quebram blocos.'
      : '§e[Guerra] Modo automático: segue o horário (sex/sáb 20h–23h).'
    server.tell(Text.of(txt))
    return 1
  }

  try {
  event.register(
    Commands.literal('guerra')
      .requires(src => src.hasPermission(2))
      .then(Commands.literal('on').executes(definir('on')))
      .then(Commands.literal('off').executes(definir('off')))
      .then(Commands.literal('auto').executes(definir('auto')))
      .then(Commands.literal('status').executes(ctx => {
        const server = ctx.source.server
        const ativo = emGuerra(server)
        ctx.source.sendSystemMessage(Text.of(
          `[Guerra] modo=${modo(server)} | agora: ${ativo ? '§cGUERRA (blocos quebram)' : '§aPAZ (blocos protegidos)'}`
        ))
        return 1
      }))
  )
  } catch (e) { console.error('[Guerra] falha ao registrar /guerra: ' + e) }
})
