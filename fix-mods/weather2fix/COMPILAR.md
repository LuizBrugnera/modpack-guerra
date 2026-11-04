# Compilar o guerra-correcoes

Mod de correções do Modpack Guerra (modId `guerra_weather2fix`, mantido para compatibilidade):

- `NetworkingMixin`: Weather2 2.8.7 derrubava jogadores com "Failed to encode packet custom_payload".
- `DhChunkyMixin` + `DhChunkyAccessorAccess`: o Distant Horizons 3.3.3 derrubava o servidor no boot
  ("Chunky is not loaded") porque tentava se ligar ao Chunky antes de ele carregar.
  Agora a ligação é adiada até o Chunky estar pronto.

Rodar no Git Bash, na pasta `minecraft/` (precisa dos jars do DH e do Chunky em `servidor-teste/mods`):

```bash
JDK=tools/jdk-21.0.13+9/bin; L='servidor\libraries'; B=build-w2fix; rm -rf $B; mkdir -p $B
CP="$L\net\minecraft\server\1.21.1-20240808.144430\server-1.21.1-20240808.144430-srg.jar;$L\net\fabricmc\sponge-mixin\0.16.4+mixin.0.8.7\sponge-mixin-0.16.4+mixin.0.8.7.jar;$L\net\neoforged\fancymodloader\loader\4.0.45\loader-4.0.45.jar;servidor-teste\mods\DistantHorizons-3.3.3-1.21.1-fabric-neoforge.jar;servidor-teste\mods\Chunky-NeoForge-1.4.23.jar"
$JDK/javac --release 21 -proc:none -encoding UTF-8 -cp "$CP" -d $B $(find modpack-guerra/fix-mods/weather2fix/src -name "*.java")
cp -r modpack-guerra/fix-mods/weather2fix/resources/* $B/
$JDK/jar --create --file modpack-guerra/mods/guerra-correcoes-1.1.0.jar -C $B .
```

Depois: `packwiz refresh` e `git push`.
