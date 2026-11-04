# Compilar o guerra-correcoes

Mod de correções do Modpack Guerra (modId `guerra_weather2fix`, mantido para compatibilidade):

- `NetworkingMixin`: Weather2 2.8.7 derrubava jogadores com "Failed to encode packet custom_payload".
- `DhChunkyMixin` + `DhChunkyAccessorAccess`: o Distant Horizons 3.3.3 derrubava o servidor no boot
  ("Chunky is not loaded") porque tentava se ligar ao Chunky antes de ele carregar.
  Agora a ligação é adiada até o Chunky estar pronto. O Chunky é acessado por reflexão,
  porque ele não existe no cliente e uma referência direta derruba o jogo ao abrir.
- `ProtecaoBombas` + `Pe*Mixin` (Project Explosive 0.7.2-beta, código ofuscado no pacote `lil1llilol11`):
  - as bombas decidiam o que quebrar pela dureza, não pela resistência a explosão. Agora:
    resistência ≥ 100.000 (bunker `*_ub`) nenhuma bomba quebra; ≥ 1.000 (concreto armado, obsidiana,
    aço do CBC) só a nuclear quebra.
  - as bombas escrevem os blocos direto no mundo, então a proteção fora do horário de guerra não as pegava.
    O `horario_guerra.js` chama `ProtecaoBombas.definirPaz(...)` a cada segundo; em paz, toda troca de
    bloco feita pelo Project Explosive é barrada (a bomba explode e fere, mas não quebra nada).
  - Ganchos: `Level.setBlock`, `LevelChunk.setBlockState`, `BlockStateBase.getDestroySpeed` e
    `FallingBlockEntity.fall` (o último evita duplicar blocos como destroço). Só agem quando o
    Project Explosive está na pilha de chamadas (até 16 quadros).
  - **Se o Project Explosive for atualizado**, os nomes ofuscados mudam: conferir `PACOTE_PE` e
    `CLASSE_NUCLEAR` em `ProtecaoBombas.java` e testar de novo (ver PENDENCIAS.md).

Rodar no Git Bash, na pasta `minecraft/` (precisa do jar do DH em `servidor-teste/mods`):

```bash
JDK=tools/jdk-21.0.13+9/bin; L='servidor\libraries'; B=build-w2fix; rm -rf $B; mkdir -p $B
NF=servidor/libraries/net/neoforged/neoforge/21.1.265/neoforge-21.1.265-universal.jar
SLF=servidor/libraries/org/slf4j/slf4j-api/2.0.9/slf4j-api-2.0.9.jar
CP="$L\net\minecraft\server\1.21.1-20240808.144430\server-1.21.1-20240808.144430-srg.jar;$L\net\fabricmc\sponge-mixin\0.16.4+mixin.0.8.7\sponge-mixin-0.16.4+mixin.0.8.7.jar;$L\net\neoforged\fancymodloader\loader\4.0.45\loader-4.0.45.jar;$L\com\mojang\datafixerupper\8.0.16\datafixerupper-8.0.16.jar;$NF;$SLF;servidor-teste\mods\DistantHorizons-3.3.3-1.21.1-fabric-neoforge.jar"
$JDK/javac --release 21 -proc:none -encoding UTF-8 -cp "$CP" -d $B $(find modpack-guerra/fix-mods/weather2fix/src -name "*.java")
cp -r modpack-guerra/fix-mods/weather2fix/resources/* $B/
$JDK/jar --create --file modpack-guerra/mods/guerra-correcoes-1.2.0.jar -C $B .
```

Depois: `packwiz refresh` e `git push`.
