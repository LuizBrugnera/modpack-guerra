# Compilar o guerra-weather2fix

Rodar no Git Bash, na pasta `minecraft/`:

```bash
JDK=tools/jdk-21.0.13+9/bin; L='servidor\libraries'; B=build-w2fix; mkdir -p $B
CP="$L\net\minecraft\server\1.21.1-20240808.144430\server-1.21.1-20240808.144430-srg.jar;$L\net\fabricmc\sponge-mixin\0.16.4+mixin.0.8.7\sponge-mixin-0.16.4+mixin.0.8.7.jar;$L\net\neoforged\fancymodloader\loader\4.0.45\loader-4.0.45.jar"
$JDK/javac --release 21 -proc:none -cp "$CP" -d $B $(find modpack-guerra/fix-mods/weather2fix/src -name "*.java")
cp -r modpack-guerra/fix-mods/weather2fix/resources/* $B/
$JDK/jar --create --file modpack-guerra/mods/guerra-weather2fix-1.0.0.jar -C $B .
```

Depois: `packwiz refresh` e `git push`.
