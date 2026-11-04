# Pendências — Modpack Guerra

Atualizado em 03/11/2026. Pack: MC 1.21.1, NeoForge 21.1.265.

## Decisões aplicadas (03/11/2026)

- **Thrusters and Things → Create Aeronautics: Gadgets & Gizmos** (renomeado; CurseForge 1537945). Adicionado pelo **Modrinth** (download automático liberado), **fixado na 1.2.10** (última 1.x estável, "Performance Hotfix"). O jar é "bundled" e a 1.2.10 não declara a *Gadgets & Gizmos Library* (essa biblioteca saiu junto com a 2.0.0). **Teste futuro:** 2.0.0 (lançada em 03/11/2026, exige rever dependências).
- **Create: Sentry Mechanical Arm** → port aprovado `create-sentry-mechanical-arm-1` (1.3.7). O autor **bloqueou download pela API do CurseForge**: o packwiz não baixa sozinho. Solução: o `iniciar-servidor.bat` e a instância do Prism baixam o jar direto do CDN do CurseForge antes do packwiz rodar. O `.mrpack` sai **sem** ele (o jogador baixa à mão) — embutir o jar seria redistribuir o mod.
- **Frontier Cohorts**: removido do pack e da especificação. Não usar ports do Villager Recruits (licença ARR). Removida a regra "recrutamento custa munição e combustível".
- **Rise of Villages** (Modrinth, 2.0.0-ep10, + NavaroneeCore): adicionado como **exército provisório** (recrutas, arqueiros, cavalaria). Ele tem território próprio ao comprar uma vila — ver config abaixo para manter o território só no OPAC.
- **Guard Villagers**: datapack em `kubejs/data/guardvillagers/loot_table/entities/guard_armor.json`. Nesta versão (2.4.12) não existe `guard_main_hand`: a mão principal fica no pool `mainhand` da tabela `guard_armor`, que foi sobrescrito só com armas TaCZ da Era 1–2 (M1911, CZ75, Glock 17, Rhino .357, Springfield 1873, Kar98k, escopetas de cano duplo, M870, SKS). Armadura e mão secundária continuam as originais. Armas vêm sem munição: os guardas buscam em baús (Guard Villagers TACZ Support).
- **Exports**: sem export CurseForge. Só `.mrpack` + instância do Prism (com packwiz-installer).

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
- **Weather2**: chance de tornados F0–F5 reduzida (30/20/10/5/2/1 %). `Storm_Tornado_grabBlocks = true` (religado em 03/11 a pedido): arranca principalmente blocos de madeira, folhas, cercas e plantas (regras "Refined" + "StrengthGrabbing": não arranca terra, grama, areia nem troncos). Antes de arrancar, o Weather2 dispara um evento de quebra de bloco, então o OPAC deve proteger claims — não testado. Não respeita o horário de guerra. Jogador em Criativo não é puxado.
- **Distant Horizons** (`config/DistantHorizons.toml`): distância dos LODs 256 → 64 chunks, threads 8 → 4; no servidor, atualização em tempo real 256 → 64 chunks e pedidos de geração/sincronização 4096 → 1024. O `serverId` foi tirado do arquivo (o DH gera um novo). Distância normal: o servidor já limita em 8 (`view-distance`), simulação em 6.
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

## Mods bloqueados na API do CurseForge
- `create-sentry-mechanical-arm-1` e `create-simulated-missiles-create-aeronautics`: o autor bloqueou download por API. Os `.pw.toml` apontam direto para o CDN do CurseForge (`url = mediafilez.forgecdn.net/...`), então o packwiz-installer baixa sozinho. Ao atualizar esses dois, trocar `url`, `hash` e `file-id` à mão (o `packwiz update` voltaria para o modo API).
- Simulated Missiles 0.2.0 exige Create: Radars `[0.4.9.4, 0.5.0)` — combina com o pin atual do Radars.

## Infra

- Publicar o repositório (ex.: GitHub) para ter a URL pública do `pack.toml` (usada pelo servidor, pelo Prism e pelo docker-compose).
- **docker-compose (VPS)**: a imagem itzg roda o packwiz-installer, que falha no Sentry Arm (download bloqueado). Antes de usar em VPS, colocar o jar em `data/mods/` manualmente.

## Testes de 03/11/2026 (servidor dedicado, sem jogadores)

- **Crash corrigido:** a Shaolib 0.1.0 (dependência do CBC Military Supplement 3.x) derrubava o servidor no primeiro impacto de projétil do CBC (`NoClassDefFoundError: com/verr1/synaxis/...`). Solução: **CBC Military Supplement fixado na 2.1.4** (sem Shaolib; mantém torpedos, tubos e carga de profundidade). Após a troca, disparos não derrubam mais o servidor.
- **Descoberta:** o CBC calcula a penetração de projéteis sólidos como uma *explosão do jogo* (`handleCustomExplosion`). Logo, o `horario_guerra.js` provavelmente também bloqueia esse dano fora do horário. **Confirmar no jogo.**
- **OPAC × projétil sólido do CBC: INCONCLUSIVO.** O projétil invocado por `/summon` não quebrou nem a parede de controle (fora de claim, modo guerra), então o teste por comando não serve. O OPAC não tem integração com o CBC no código. **Teste manual pendente:** montar um canhão real, fazer um claim com uma conta e disparar contra uma parede dentro e fora do claim, com `/guerra on`.
- **Datapack dos guardas: não verificado** (os guardas de teste morreram de queda antes da leitura). Teste no jogo: `/summon guardvillagers:guard ~ ~ ~` e ver a arma na mão.
- MixAuth, Rise of Villages, Gadgets & Gizmos 1.2.10 e Sentry Arm: carregam sem erro.

## Modo pirata

- `online-mode=false` + **MixAuth** (só servidor): conta original entra verificada pela Mojang (mesmo UUID de sempre); conta pirata usa `/register` e `/login`.
- **Whitelist desligada**: em modo offline ela bloquearia contas piratas (UUID diferente). A proteção fica na rede fechada do Radmin + senha do MixAuth.
## Fat Man (bomba nuclear do Project Explosive) — 03/11/2026

- A bancada de munição do mod monta a Fat Man barato e a receita dela é fixa no código (mod ofuscado). Essas bombas continuam **confiscadas**.
- **Receita nova (Era 5):** Crafter Mecânico do Create **7x7** — 16 blocos de aço TFMG, 8 blocos de alumínio TFMG, 8 lingotes de urânio, 2 placas de circuito revestidas, 1 motor elétrico pesado, 1 bomba Mk 84 e 1 Estrela do Nether. A bomba sai com `custom_data {guerra_autorizada:1b}` e só essa passa pelo confisco.
- **Testar no jogo:** a receita aparece no EMI; uma Fat Man da bancada some do inventário de quem não é op; a do crafter fica.
- ICBM nuclear e shells nucleares do Enhanced Shells continuam só para admin.
## Correção própria: Weather2 derrubava jogadores — 03/11/2026
- Sintoma: `Connection Lost — Failed to encode packet 'clientbound/minecraft:custom_payload'`.
- Causa (log do cliente): `Failed encoding custom payload weather2:nbt_client: ConcurrentModificationException`. O Weather2 2.8.7 (última versão, licença ARR) envia o mesmo `CompoundTag` que continua alterando; o Netty serializa em outra thread e quebra. Pode acontecer no servidor dedicado também, a qualquer momento com tempestade ativa.
- Correção: mod próprio `mods/guerra-weather2fix-1.0.0.jar` (código em `fix-mods/weather2fix/`, MIT). Um mixin faz `WeatherNetworkingv2.serverSendToClient*` enviar uma cópia do tag. O jar do Weather2 não foi alterado.
- Verificado: servidor sobe; a classe exportada pelo Mixin mostra a cópia nos 4 métodos de envio. A corrida em si é aleatória e não dá para reproduzir sob demanda: observar se a queda volta.
- Se uma versão nova do Weather2 corrigir o bug, remover o jar. Se o Weather2 renomear os métodos, o servidor não sobe (mixin obrigatório) — o erro aponta para `guerra_weather2fix`.
- Recompilar: ver comando em `fix-mods/weather2fix/COMPILAR.md`.

## Lote de 03/11/2026 (pedido do admin)
- Adicionados (Modrinth, 1.21.1 NeoForge): Create: Simulated Missiles 0.2.0 (CurseForge, via CDN), Create Propulsion: Simulated 1.1.5, Create Aeronautics: Toolgun 0.3.7, Better Villages 3.3.1 (só servidor; dep. Library Ferret), Born in Chaos 1.7.6, Create: The Air War 5.00.
- Luas: o Moon Bundle usa o Enhanced Celestials **1** e o Chaos Moon 2 usa o Enhanced Celestials **2** (reescrita). Decisão: tudo no EC2 — Chaos Moon 2 + as versões "2" das luas do bundle: Horde, Spider, Black, Hunter's, Miner's e Peaceful Moon 2 (deps: EC2 Core, CorgiLib, Data Anchor). O Moon Bundle **não** entrou.
- Testado: servidor de teste sobe com tudo, sem erros novos. Não testado em jogo: frequência das luas (Peaceful Moon impede spawn de hostis por uma noite; Black Moon dá cegueira), estruturas do Born in Chaos/Better Villages e itens da Air War/Propulsion.

## Lote 2 de 03/11/2026
- Adicionados (Modrinth): Create: Steel armor blocks 1.4.3, CBC: Terminal Ballistics 0.3.5, Create:Parachute 1.1.5, Corpse 1.1.22, Create: Copycats+ 3.0.9, Sable Pathfinder 1.4.0, First Aid New 1.3.5, Fracture Point 3.0.0-PT1-fix (dep. Curios), TaCZ Armor Scaling 0.5.4, MineTraps 3.0.2, Aeronautics Camera Sync 1.4.0, ModernFix 5.27.27, FerriteCore 7.0.3. CurseForge: FTB Quests 2101.1.38 (+ FTB Library, FTB Teams; Architectury veio do Modrinth).
- **TaCZ Armor Scaling**: fixado na 0.5.4 (a "0.5.4-customgun" é para outro mod de armas). Exige o **Custom BattleRoyale** (o código saiu dele) — entrou como dependência; os erros de "example.json" dele no log são dos arquivos de exemplo e não afetam nada. Só servidor. **Vem desligado**: para ativar, como op: `/armorscaling damageScaling true` e `/armorscaling durabilityScaling true` (config em `config/armorscaling/`). Não testado.
- **Otimizações**: ModernFix e FerriteCore em servidor e cliente (`side = both`), configs padrão. A opção "dynamic resources" do ModernFix (economiza RAM no cliente) ficou desligada: pode quebrar texturas de alguns mods; testar antes de ligar.
- Receitas quebradas nos próprios mods (o mod carrega, só essas receitas não existem): Terminal Ballistics `copycat_armor_layer`, `framed_collapsible_copycat_armor_block`, `armor_upgrader`; Steel armor blocks `glassarmor`. Dá para recriar via KubeJS se fizerem falta.
- Não testado em jogo: First Aid New com dano do TaCZ (não há compat instalado), Corpse com OPAC, armadilhas do MineTraps em claims.

## Quests (FTB Quests)
- 4 capítulos, 32 quests, em português: 1. Primeiros passos no Create → 2. Seu primeiro barco → 3. Voando: balão e avião → 4. Navegação e controle. Textos originais (não copiados de outros modpacks).
- Fonte: `scripts/gerar-quests.ps1` gera `config/ftbquests/quests/`. Editar lá e rodar de novo; os IDs são fixos (hash da chave), então o progresso dos jogadores se mantém. Editar pelo editor do jogo grava só na pasta local — copie de volta para o repo se usar.
- Testado: servidor carrega "4 chapters, 32 quests" sem avisos; todos os itens das tarefas existem. Não conferido na tela do jogo (layout/textos).
