# Pendências — Modpack Guerra

Atualizado em 03/11/2026. Pack: MC 1.21.1, NeoForge 21.1.265.

## Mods da lista sem build 1.21.1 NeoForge (não substituídos)

| Mod | Situação | Possível alternativa (precisa de aprovação) |
|---|---|---|
| Frontier Cohorts | Não encontrado no Modrinth nem no CurseForge | Villager Recruits só tem 1.20.1 |
| Create Aeronautics Thrusters and Things | Não encontrado | Create: Simulated Thrusters / Create: Linked Thrusters (1.21.1) |
| Create: Sentry Mechanical Arm | Oficial só tem 1.20.1 Forge | Port não oficial chinês no CurseForge: "Create: Sentry Mechanical Arm_非官方移植" (1.21.1 NeoForge) |

Com isso também ficam sem efeito: claims de facção do Frontier Cohorts e "recrutamento custa munição e combustível".

## Trocas e versões fixadas (decididas na montagem)

- **TFMG → Create: TFMG Community Edition 1.3.3.** O KubeJS TFMG (essencial) só funciona com o CE desde a versão 1.1.0. O CE é um fork de correções do mesmo mod (mesmo ID `tfmg`).
- **TFMG Liquid Fuel Compat removido.** O TFMG CE se declara incompatível com ele (o servidor não sobe com os dois).
- **"Sable: Weighted – Create: TFMG"** não existe com esse nome; usado **Sable: Weighted**, que cobre "The Factory Must Grow" na lista dele.
- **CBC: Firepower Components fixado em 0.3.2** (`packwiz pin`). As versões 0.4.x exigem Drive-By-Wire ≥ 0.2.9 (o fork TFMG está em 0.2.7) e CBC Enhanced Shells 1.2.x (o pack usa 1.5.1).
- **Create: Radars fixado em 0.4.9.4** (`packwiz pin`). O Radars 5.x reescreveu o código e quebra o Firepower Components (crash no boot).
- **CoroUtil** adicionado: dependência obrigatória do Weather, Storms & Tornadoes.

## Opcionais (prioridade O) — não adicionados, testar um por vez (Lote 9)

- CBC Ballistics: NeoForge Port — CurseForge `cbc-ballistics-neoforge-port-1-21-1`
- CBC: Enhanced Shell Armor — Modrinth `cbcenhanced-shell-armor-create-big-cannons`
- [CBC] More Content — CurseForge `cbc-more-content` (marcado OUTDATED)
- Blastcraft — Modrinth `blastcraft` (verificar se puxa Electrodynamics)
- Reinforced Construction — Modrinth `reinforced-construction` (exige Fusion)
- Another Weather Mod — **não** usar junto com Weather, Storms & Tornadoes

Para adicionar: `packwiz mr add <slug>` ou `packwiz cf add <slug>` dentro de `modpack-guerra/`.

## Configs aplicadas

- **OPAC** (`config/openpartiesandclaims-server.toml`): `partyOwnedClaims = true`, `maxPlayerClaims = 64`, `claimBonusPerPartyMember = 16`, `maxPlayerClaimForceloads = 4`, `forceloadBonusPerPartyMember = 0`.
- **OPAC** (`defaultconfigs/openpartiesandclaims-default-player-config.toml`): `blocksByExplosions = true` — claims **não** bloqueiam explosões; quem protege fora do horário é o `horario_guerra.js` (vale para o mapa todo). Os jogadores não podem mudar essa opção. Em servidor novo, copiar este arquivo para `world/serverconfig/`.
- **Weather2**: chance de tornados F0–F5 reduzida (30/20/10/5/2/1 %) e `Storm_Tornado_grabBlocks = false` (o Weather2 não respeita claims). Religar na Era 3.
- **Guard Villagers TACZ Support**: `zombie_tacz_weapon_spawn_chance = 0.0` e `pillager_tacz_enabled = false`. Religar depois da Era 2 com chance baixa (ex.: 0.03).
- **CBC**: recuo padrão (`bigCannonRecoilScale = 1.0`), `damageRestriction = "ALL_DAMAGE"`.

## Configs ainda a ajustar (precisam de teste com jogadores)

- **CBC — projéteis sólidos**: AP shot / solid shot quebram blocos por **impacto**, não por explosão, então o horário de guerra **não** os bloqueia. Opções: aceitar, ou trocar `damageRestriction` para `NO_DAMAGE` fora das guerras (manual).
- **CBC**: o PDF pede separar dano de bloco e de entidade; nesta versão a config só tem `damageRestriction` (ALL_DAMAGE / NO_EXPLOSIVE_DAMAGE / NO_DAMAGE).
- **TaCZ**: fogo amigo entre membros do mesmo grupo — o TaCZ não tem opção própria; usar o PvP de party do OPAC.
- **Create Deep Seas**: profundidade por material em `config/submarine_hull.json`.
- **Guard Villagers TACZ Support**: não há opção para limitar as armas dos guardas no spawn natural por era; só as listas de zumbi/pillager.
- **Vila neutra** (reputação do grupo atacante com todas as vilas) — não implementado.
- **Project Explosive**: raio das bombas grandes — revisar depois do primeiro teste (`config/projectexplosive-common.toml`).

## Scripts KubeJS — o que testar

- `horario_guerra.js`: confirmar que explosões do **CBC** e do **Project Explosive** passam pelo evento de explosão do jogo (se algum usar explosão própria, ele não será bloqueado fora do horário).
- `progressao.js`: conferir as receitas no EMI (Mk.III–V, bancada de munição, ICBM, blocos `_ub`, Deflector).
- `armas_restritas.js`: bombas grandes exigem o estágio `era4` (ganho ao ter uma placa de circuito do TFMG); nucleares só para op.
- Limite de blocos à prova total: 128 por jogador (contador simples, não devolve ao quebrar).

## Infra

- Publicar o repositório (ex.: GitHub) para ter a URL pública do `pack.toml` (usada pelo servidor, pelo Prism e pelo docker-compose).
- Export CurseForge `.zip`: mods só do Modrinth vão como override/URL; conferir se o CurseForge App importa.
