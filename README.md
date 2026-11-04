# Modpack Guerra (NeoForge 1.21.1)

Modpack de guerra para servidor com amigos: Create + Create Aeronautics + Create Big Cannons + Project: Explosive, com a indústria do TFMG sustentando a logística.

- Minecraft 1.21.1 · NeoForge 21.1.265 · Java 21
- Gerenciado com [packwiz](https://packwiz.infra.link). Este repositório é a fonte única: servidor e clientes puxam os mods daqui.
- URL do pack: `https://raw.githubusercontent.com/LuizBrugnera/modpack-guerra/main/pack.toml`
- Atualizar o pack para todo mundo = `git push`. A instância do Prism e o `iniciar-servidor.bat` baixam a versão nova na próxima abertura.

## Estrutura

```
pack.toml / index.toml   definição do pack (packwiz)
mods/                    um .pw.toml por mod (com lado client/server/both)
kubejs/server_scripts/   eras.js, progressao.js, horario_guerra.js, armas_restritas.js, pregeracao.js
kubejs/client_scripts/   info_eras.js (notas no EMI)
kubejs/data/tacz/        receitas das armas do TaCZ por era (gerado)
scripts/                 gerar-quests.ps1, gerar-armas-tacz.ps1, gerar-exports.ps1
config/ defaultconfigs/  configs do servidor/cliente
docker-compose.yml       servidor em VPS (imagem itzg/minecraft-server)
JOGADORES.md             guia para os jogadores
PENDENCIAS.md            o que ficou de fora e o que falta testar
PROGRESSAO.md            eras, travas por material e quests
```

## Comandos úteis (dentro desta pasta)

```
packwiz mr add <slug>        # adicionar mod do Modrinth
packwiz cf add <slug>        # adicionar mod do CurseForge
packwiz update --all         # atualizar mods (faça backup do mundo antes!)
packwiz refresh              # recalcular o índice depois de editar arquivos
powershell -File scripts\gerar-exports.ps1 -PackUrl <url>   # .mrpack + instancia Prism + pacote do servidor
packwiz serve                # servir o pack em http://localhost:8080 para testes
```

O `packwiz.exe` e o Java 21 portátil ficam em `../tools/`.

## Admin

- `/era` mostra a era do jogador; `/era definir <jogador> <1-5>` (op) muda.
- `/guerra on | off | auto | status` — força ou libera o horário de guerra (padrão: sex/sáb 20h–23h, America/Sao_Paulo).
- Pré-geração do mapa (console): `chunky worldborder` e `chunky start`; `chunky progress` mostra o andamento. Pausa sozinha quando alguém entra e continua quando o servidor esvazia (`pregeracao.js`).
- ServerCore dinâmico (`config/servercore/config.yml`): quando o servidor pesa, reduz sozinho mobs, simulação e visão; `/servercore reload` aplica mudanças na config.
- Nunca atualizar CBC, Project Explosive ou Create Aeronautics no meio de uma guerra sem testar.
- `create-radars` e `cbc-firepower-components` estão fixados (`packwiz pin`) — ver PENDENCIAS.md.
