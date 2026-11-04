# Progressão — Eras, travas e quests

Toda tecnologia de guerra consome recurso industrial: quem controla a refinaria e o aço controla a guerra.
O modelo é o dos packs de Create com progressão por material (estilo *Create: Above and Beyond*):
**cada arma e veículo pede o material da indústria da sua era**, então não dá para pular etapa.
O estágio de era do jogador serve para anunciar a subida, para o `/era` e para as regras de confisco.

## As 5 eras

| Era | Marco (subir de era) | Material da era | Libera na guerra |
|---|---|---|---|
| 1. Mecânica | — (todo jogador começa aqui) | ferro, liga de andesito | pistolas, rifles clássicos e escopetas do TaCZ; canhões de ferro fundido; barcos; balões |
| 2. Vapor | Motor a Vapor (`create:steam_engine`) | latão, mecanismo de precisão | submetralhadoras e semiautomáticas do TaCZ; autocanhões (munição de latão); metralhadora da Air War; hélices; trens |
| 3. Petróleo e Aço | Lingote de Aço (`tfmg:steel_ingot`) | aço e enxofre do TFMG | fuzis, metralhadoras e snipers do TaCZ; canhões de aço; Enhanced Mk.III; bombas pequenas; Superb Warfare (armas); motor de foguete; explosivos e foguetes da Air War; propulsores |
| 4. Eletricidade | Placa de Circuito (`tfmg:circuit_board`) | alumínio, placa de circuito, motor elétrico pesado | armas pesadas do TaCZ; Mk.IV–V; Mk 84; ICBM; ataque aéreo; veículos do Superb Warfare; mísseis guiados; chip e turbina da Air War; radar; bunker à prova total; defletor de tempestades |
| 5. Fim de jogo | Lingote de Urânio (`projectexplosive:uranium_ingot`) | volume de tudo | Fat Man (Crafter Mecânico 7x7) |

Subir de era = ter o marco no inventário (`kubejs/server_scripts/eras.js`). O servidor anuncia, toca um som e
diz o que foi liberado. Quem pega o marco de uma era mais alta ganha as anteriores junto.

Comandos: `/era` (qualquer jogador: era atual e lista) · `/era definir <jogador> <1-5>` (op).

## Onde cada trava está

| Trava | Arquivo |
|---|---|
| Aço só do TFMG (remove o aço de outros mods, inclusive o do Superb Warfare, que saía de ferro no alto-forno) | `progressao.js` |
| Bancada de munições: aço + enxofre | `progressao.js` |
| Enhanced Shells Mk.III/IV/V: aço+enxofre / alumínio+aço / circuito+alumínio | `progressao.js` |
| ICBM, ataque aéreo, defletor de tempestades, blocos `_ub`: alumínio/circuito/motor | `progressao.js` |
| Air War: metralhadora (latão), explosivo e motor de foguete pequeno (aço), chip e turbina (circuito) | `progressao.js` |
| Simulated Missiles: computador de guiagem (circuito); motor de foguete já pede aço | `progressao.js` / receita original |
| Superb Warfare: mesa de pesquisa (aço, original); mesa de veículos (motor elétrico pesado) | receita original / `progressao.js` |
| Armas do TaCZ por era (39 receitas sobrescritas) | `kubejs/data/tacz/recipe/gun/` ← `scripts/gerar-armas-tacz.ps1` |
| Bombas grandes exigem `era4`; nucleares só admin; Fat Man só a do 7x7; limite de 128 `_ub` | `armas_restritas.js` |
| Fat Man no Crafter Mecânico 7x7 | `progressao.js` |
| Notas no EMI (página Informação) | `kubejs/client_scripts/info_eras.js` |

### Armas do TaCZ

A receita original (ferro + madeira) fica para a Era 1. As outras ganham material extra:

| Era | Extra | Armas |
|---|---|---|
| 1 | — | m1911, cz75, glock_17, hk_mk23, m9a4, p320, rhino357, taurus943, lonetrail, springfield1873, kar98, db_short, db_long, m870, sks_tactical |
| 2 | +6 latão, +1 mecanismo de precisão | uzi, hk_mp5a5, ump45, vector45, p90, b93r, deagle, taurus500, m1014, spas_12, m700, m16a1, type_81 |
| 3 | +10 aço, +2 enxofre | ak47, m4a1, m16a4, hk416d, g36k, aug, qbz_95, qbz_191, scar_l, scar_h, fn_fal, hk_g3, mk14, spr15hb, rpk, m249, aa12, ai_awp |
| 4 | +8 alumínio, +2 placa de circuito, +6 aço | m107, m95, fn_evolys, minigun, rpg7, m320, deagle_golden, timeless50 |

Para mudar uma arma de era: editar as listas em `scripts/gerar-armas-tacz.ps1` e rodar o script.
Se o TaCZ atualizar o gunpack padrão, rodar de novo (o script lê as receitas originais em `servidor/tacz/`).

## Quests (FTB Quests)

Fonte: `scripts/gerar-quests.ps1` → `config/ftbquests/quests/`. 3 grupos, 10 capítulos, 110 quests:

- **Começo** — *Bem-vindo à Guerra*: o que é o servidor, como funcionam as eras, EMI, time e claims (OPAC), horário de guerra, regras de armamento, o mundo (borda, cidades, tornados, luas, corpo).
- **Eras** — um capítulo por era. Cada um tem a trilha da **indústria** (em cima) e a da **guerra** (embaixo), e termina numa quest-engrenagem **"Rumo à Era N"** cujo item é o marco da próxima era. O capítulo seguinte começa por ela.
- **Trilhas** — *Barcos*, *Voando*, *Navegação e controle* e *Defesa da base* (claims, muralhas, armadilhas, blindagem, bunker).

Quests de "faça X" que o jogo não detecta direito (montar uma arma do TaCZ, que é um item com dados) são de marcar (checkmark).

## Não testado em jogo

- Página Informação no EMI (script de cliente: só roda no jogo; erros aparecem no `logs/kubejs/client.log`).
- Receitas de armas do TaCZ na bancada (o servidor carrega as receitas novas; a tela da bancada não foi vista).
- Anúncio de era e `/era` com jogador (o comando registra; a mensagem dentro do jogo não foi vista).
