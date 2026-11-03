# Modpack Guerra (NeoForge 1.21.1)

Modpack de guerra para servidor com amigos: Create + Create Aeronautics + Create Big Cannons + Project: Explosive, com a indústria do TFMG sustentando a logística.

- Minecraft 1.21.1 · NeoForge 21.1.265 · Java 21
- Gerenciado com [packwiz](https://packwiz.infra.link). Este repositório é a fonte única: servidor e clientes puxam os mods daqui.

## Estrutura

```
pack.toml / index.toml   definição do pack (packwiz)
mods/                    um .pw.toml por mod (com lado client/server/both)
kubejs/server_scripts/   progressao.js, horario_guerra.js, armas_restritas.js
config/ defaultconfigs/  configs do servidor/cliente
docker-compose.yml       servidor em VPS (imagem itzg/minecraft-server)
JOGADORES.md             guia para os jogadores
PENDENCIAS.md            o que ficou de fora e o que falta testar
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

- `/guerra on | off | auto | status` — força ou libera o horário de guerra (padrão: sex/sáb 20h–23h, America/Sao_Paulo).
- Nunca atualizar CBC, Project Explosive ou Create Aeronautics no meio de uma guerra sem testar.
- `create-radars` e `cbc-firepower-components` estão fixados (`packwiz pin`) — ver PENDENCIAS.md.
