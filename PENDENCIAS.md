# Pendências — Modpack Guerra

Atualizado em 03/11/2026. Pack: MC 1.21.1, NeoForge 21.1.265.

## Decisões aplicadas (03/11/2026)

- **Thrusters and Things → Create Aeronautics: Gadgets & Gizmos** (renomeado; CurseForge 1537945). Adicionado pelo **Modrinth** (download automático liberado), **fixado na 1.2.10** (última 1.x estável, "Performance Hotfix"). O jar é "bundled" e a 1.2.10 não declara a *Gadgets & Gizmos Library* (essa biblioteca saiu junto com a 2.0.0). **Teste futuro:** 2.0.0 (lançada em 03/11/2026, exige rever dependências).
- ~~**Create: Sentry Mechanical Arm**~~ → **removido em 03/11/2026** a pedido do admin (exigia download manual: o autor bloqueou a API do CurseForge).
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
- `create-simulated-missiles-create-aeronautics`: o autor bloqueou download por API. O `.pw.toml` aponta direto para o CDN do CurseForge (`url = mediafilez.forgecdn.net/...`), então o packwiz-installer baixa sozinho. Ao atualizar, trocar `url`, `hash` e `file-id` à mão (o `packwiz update` voltaria para o modo API). Fica fora do `.mrpack` (quem usa o .mrpack baixa à mão). O Sentry Mechanical Arm, que tinha o mesmo problema, foi removido.
- Simulated Missiles 0.2.0 exige Create: Radars `[0.4.9.4, 0.5.0)` — combina com o pin atual do Radars.

## Infra

- Publicar o repositório (ex.: GitHub) para ter a URL pública do `pack.toml` (usada pelo servidor, pelo Prism e pelo docker-compose).
- **docker-compose (VPS)**: os mods bloqueados na API agora têm URL direta no `.pw.toml`, então o packwiz-installer da imagem itzg deve baixar tudo sozinho (não testado em VPS).

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
- Adicionados (Modrinth): Create: Steel armor blocks 1.4.3, CBC: Terminal Ballistics 0.3.5, Create:Parachute 1.1.5, Corpse 1.1.22, Create: Copycats+ 3.0.9, Sable Pathfinder 1.4.0, ~~First Aid New 1.3.5~~ (removido em 04/11), Fracture Point 3.0.0-PT1-fix (dep. Curios), TaCZ Armor Scaling 0.5.4, MineTraps 3.0.2, Aeronautics Camera Sync 1.4.0, ModernFix 5.27.27, FerriteCore 7.0.3. CurseForge: FTB Quests 2101.1.38 (+ FTB Library, FTB Teams; Architectury veio do Modrinth).
- **TaCZ Armor Scaling**: fixado na 0.5.4 (a "0.5.4-customgun" é para outro mod de armas). Exige o **Custom BattleRoyale** (o código saiu dele) — entrou como dependência; os erros de "example.json" dele no log são dos arquivos de exemplo e não afetam nada. Só servidor. **Vem desligado**: para ativar, como op: `/armorscaling damageScaling true` e `/armorscaling durabilityScaling true` (config em `config/armorscaling/`). Não testado.
- **Otimizações**: ModernFix e FerriteCore em servidor e cliente (`side = both`), configs padrão. A opção "dynamic resources" do ModernFix (economiza RAM no cliente) ficou desligada: pode quebrar texturas de alguns mods; testar antes de ligar.
- Receitas quebradas nos próprios mods (o mod carrega, só essas receitas não existem): Terminal Ballistics `copycat_armor_layer`, `framed_collapsible_copycat_armor_block`, `armor_upgrader`; Steel armor blocks `glassarmor`. Dá para recriar via KubeJS se fizerem falta.
- Não testado em jogo: Corpse com OPAC, armadilhas do MineTraps em claims.

## HUD
- ~~First Aid~~: **removido em 04/11/2026** a pedido do admin (junto com a config do HUD).

## Quests (FTB Quests)
- 4 capítulos, 32 quests, em português: 1. Primeiros passos no Create → 2. Seu primeiro barco → 3. Voando: balão e avião → 4. Navegação e controle. Textos originais (não copiados de outros modpacks).
- Fonte: `scripts/gerar-quests.ps1` gera `config/ftbquests/quests/`. Editar lá e rodar de novo; os IDs são fixos (hash da chave), então o progresso dos jogadores se mantém. Editar pelo editor do jogo grava só na pasta local — copie de volta para o repo se usar.
- Testado: servidor carrega "4 chapters, 32 quests" sem avisos; todos os itens das tarefas existem. Não conferido na tela do jogo (layout/textos).

## Instância do Prism: comando de pré-lançamento (corrigido 03/11/2026)
- O primeiro zip tinha `PreLaunchCommand=cmd /c "...atualizar-mods.bat" "$INST_JAVA"`. O Prism lê o `instance.cfg` como INI (QSettings): apaga as aspas e cola os argumentos → "A sintaxe do nome do arquivo... está incorreta" e o jogo não abre.
- Agora: `PreLaunchCommand="\"$INST_JAVA\" -jar packwiz-installer-bootstrap.jar <URL>"` (valor inteiro entre aspas, aspas internas com `\"`), como na documentação do packwiz. O `.bat` saiu: os mods bloqueados na API já têm URL direta.
- Quem importou o zip antigo: reimportar o zip novo, ou em *Editar instância → Configurações → Comandos personalizados → Pré-lançamento* colar `"$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/LuizBrugnera/modpack-guerra/main/pack.toml`.

## Lote 3 de 04/11/2026
- **Create Aeronautics: Offroad** já estava no pack: vem dentro do `create-aeronautics-bundled` (rodas, pneus, broca). Nada a adicionar.
- **CBC: Advanced Technologies** 0.1.4c (Modrinth `create-big-cannons-advanced-technologies`) + **CBC AT crash fix** fixado na **1.0.1**: o CBC AT foi compilado contra um CBC antigo e crasha ao disparar no CBC 5.11.7; a 1.0.1 corrige só isso. As versões 1.1.x do fix exigem Create: Radars ≥ 5.0, que não dá para usar (Simulated Missiles exige < 0.5 e o Firepower Components crasha com 5.x) — o servidor nem sobe.
- **Superb Warfare** 0.8.9.2 (+ Kotlin for Forge) e **SBW Aeronautics compat** 1.15.0. Incompatível com "Iris/Oculus & GeckoLib Compat" (não está no pack).
- **"SW x CA Compat"**: não encontrado no Modrinth, CurseForge nem na web. O único compat Superb Warfare + Aeronautics é o SBW Aeronautics compat (adicionado). Se for outro, falta o link.
- Receita quebrada no próprio CBC AT: `cbc_at:cutting/twin_autocannon_barrel_cast_mould`.
- Não testado em jogo: veículos/armas do Superb Warfare em estruturas do Aeronautics, disparo dos canhões do CBC AT (o fix é exatamente para isso), equilíbrio Superb Warfare × TaCZ.

## Varinha de construção — 04/11/2026
- Pedido: "mod de magic wand para facilitar a construção". Não existe mod de construção chamado "Magic Wand" para 1.21.1 (os que existem são de magia, Bukkit ou versões antigas). Adicionado o **Building Wands** 3.0.5 (nicguzzo, Apache-2.0; deps Architectury e Cloth Config, já no pack): varinhas de pedra/ferro/diamante/netherite que colocam e removem fileiras de blocos em vários modos.
- Testado: servidor de teste sobe com ele. Não testado: varinha dentro de claims do OPAC.

## Cidades e mapa — 04/11/2026
- **The Lost Cities** 1.21-8.4.6: `config/lostcities/common.toml` com `dimensionsWithProfiles = ["minecraft:overworld=default"]` — cidades abandonadas (com estragos de explosão) no overworld normal. Perfis possíveis em `config/lostcities/profiles/` (rarecities, largecities, nodamage, onlycities…). Só vale para terreno novo: o mundo do servidor foi recriado (o antigo ficou em `servidor/world-antigo-2026-11-04`).
- **Borda do mundo**: 16.000 × 16.000 blocos (1000 × 1000 chunks), centro 0,0 — `/worldborder set 16000` (fica salvo no mundo). O servidor só gera os chunks visitados; a borda limita até onde o mundo cresce.
- Ao recriar o mundo, zeram: claims do OPAC, progresso das quests, times do FTB Teams. Contas do MixAuth (`servidor/mixauth`) e ops continuam.

## Rework de progressão e quests — 04/11/2026
- Novo sistema de eras (`eras.js`), armas do TaCZ por era (39 receitas em `kubejs/data/tacz/`), travas de material nos mods novos (Air War, Simulated Missiles, Superb Warfare), notas no EMI (`info_eras.js`) e quests refeitas: 10 capítulos, 110 quests. Tudo descrito em **PROGRESSAO.md**.
- Testado no servidor de teste: 5/5 scripts sem erro; receitas das armas e das travas conferidas pelos ingredientes; FTB Quests carrega 10 capítulos/110 quests; `/era` e `/guerra` respondem.
- Não testado: notas no EMI (script de cliente), tela da bancada de armas, anúncio de era com jogador.
- Servidor de teste e servidor real rodando juntos na mesma máquina: o de teste usava a mesma porta do voice chat (24454) e morria logo depois de subir; trocada para 24464 em `servidor-teste/config/voicechat/`.

## Quests "Unnamed" — corrigido 04/11/2026
- Causa 1: as chaves do `lang/en_us.snbt` iam **com aspas** (`"quest.ID.title": …`). O FTB Quests grava e lê sem aspas; com aspas, elas entram no nome da chave e nada casa.
- Causa 2: **IDs negativos**. O ID é um long do Java; os gerados por hash que começavam com 8–F eram negativos, e o FTB Quests troca esses IDs ao carregar (e regrava os arquivos), então as traduções deixavam de casar e os capítulos perdiam o grupo. Agora `gerar-quests.ps1` zera o bit mais alto.
- Também: as tarefas de marcar ganharam nome (antes apareciam como "Unnamed" na lista de tarefas), subtítulos nas quests principais, e "Primeira arma" agora detecta qualquer arma/munição do TaCZ (`match_components: "none"`).
- Verificado no servidor de teste pela API do FTB Quests: 3 grupos, 10 capítulos, 110 quests e 21 tarefas de marcar, todos com título; 110 descrições; depois de desligar, o FTB só reformata os arquivos e mantém os 276 IDs.
- Os IDs mudaram em relação à versão anterior: o progresso de quests de quem já tinha começado zera (o mundo é novo, então não afeta ninguém).

## Esteiras — 04/11/2026
- **Create: Bits 'n' Tracks Community Edition** 3.0.1 (esteiras de tanque com física do Sable) e **Create: Tracks+** 1.0.6b7 (esteiras estilo Trackwork; modid `tracks`).
- O BnT CE pede **Create: Bits 'n' Bobs** 2.3.5, que por sua vez exige **Strut Your Stuff (Struts)** e **Azimuth API** — o Modrinth não lista esses dois como dependência; sem eles o servidor nem sobe (adicionados: struts 1.3.1, azimuth 1.4.10).
- Testado: servidor de teste sobe com os cinco. Não testado em jogo: as duas esteiras no mesmo veículo.

## Mods de prioridade alta e carregamento de chunks — 04/11/2026
- Adicionados (pesquisa em 18 modpacks do gênero): **TACZ Aeronautics compat** 1.8.0, **CBC: Equally Opposite** 0.1.3 (recuo dos canhões nos veículos), **CBC: Going Ballistic** 0.3.2, **Create: Tweaked Controllers** 1.2.7, **Create Aeronautics: Compatibility** 1.1.3, **Sable: Physics Compat** 1.3.0, **Copycats+ aeronautics weight** 1.1.1, **Lootr** 1.11.38 (loot por jogador nas cidades), **Clumps**, **Create: Threaded Trains**, e só no servidor **Chunky** 1.4.23 e **ServerCore** 1.5.19.
- **Causa do carregamento lento de chunks:** o mundo novo tinha só 4 regiões geradas; cada lugar visitado era gerado na hora (Lost Cities + dezenas de mods de estrutura), e o Distant Horizons do servidor ainda gerava chunks completos num raio de 64 em volta de cada jogador (`SURFACE_THEN_CHUNKS`). Nos dias de jogo isso aparecia como atrasos de 2 a 4,5 s.
- **Correções:**
  - Pré-geração com o Chunky (~18 chunks/s; o mapa inteiro de 1 milhão de chunks leva ~15 h). `kubejs/server_scripts/pregeracao.js` pausa quando alguém entra e continua quando o último sai; `config/chunky/config.json` com `continueOnRestart: true`. Para começar: `chunky worldborder` e `chunky start` no console.
  - DH: `generatorPlan = "SURFACE_ONLY"` (só o esboço rápido do terreno onde não foi pré-gerado; onde foi, o DH usa o terreno real).
  - ServerCore dinâmico (`config/servercore/config.yml`): acima de 40 MSPT, reduz mobs → distância de tick (6→3) → simulação (6→4) → visão (8→6), e volta quando alivia.
  - `servidor/server.properties`: `sync-chunk-writes=false`.
- **Crash do DH 3.3.3 com o Chunky:** o DH tentava se ligar ao Chunky no primeiro chunk carregado, antes de o Chunky carregar ("IllegalStateException: Chunky is not loaded"), e o servidor caía no boot. Corrigido no nosso mod de correções, que virou `guerra-correcoes-1.1.0.jar` (código em `fix-mods/weather2fix/`): a ligação fica para depois que o Chunky estiver pronto. Com isso o DH também pausa a geração dele enquanto o Chunky roda.- **Crash do cliente com a 1.1.0 (corrigido na 1.1.1):** a mixin citava a classe do Chunky diretamente. O Chunky só existe no servidor, e o DH carrega a classe de compatibilidade também no cliente, então o Mixin não achava `ChunkyProvider` e derrubava o jogo ao abrir. Agora o Chunky é acessado por reflexão. Testado no servidor de teste sem o Chunky (abre e o DH pula a compatibilidade) e com o Chunky (liga e pausa a geração do DH).
