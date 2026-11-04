# Modpack Guerra — como entrar no servidor

Vale para **conta original** e **conta pirata**. Só o passo 2 muda.
Tempo total: uns 15 minutos (a maior parte é download).

**Você vai precisar:**
- A instância **`ModpackGuerra-Prism.zip`** (link no Passo 3)
- O **nome e a senha da rede do Radmin** (o admin manda)
- 8 GB de RAM livres para o jogo

---

## Passo 1 — Radmin VPN (conexão com o servidor)

1. Baixe e instale: https://www.radmin-vpn.com
2. Abra o Radmin VPN → botão **Ligar** (o ícone fica verde).
3. Menu **Rede → Entrar em uma rede existente**.
4. Digite o **nome da rede** e a **senha** que o admin passou → **Entrar**.
5. Na lista aparece a rede e o PC do admin com uma bolinha verde. Pronto.

> O Radmin precisa estar ligado toda vez que você for jogar.

---

## Passo 2 — Launcher

### ✅ Conta ORIGINAL
1. Baixe o **Prism Launcher**: https://prismlauncher.org/download → Windows → instalador (Setup).
2. Instale e abra. Na primeira tela, aceite o Java que ele sugerir (ou clique em **Baixar Java 21**).
3. Canto superior direito → **Contas → Gerenciar contas → Adicionar Microsoft**.
4. Faça login com a conta que tem o Minecraft → feche a janela.

### 🏴‍☠️ Conta PIRATA
1. Baixe o **PrismLauncher-Cracked** (é o Prism de código aberto, só sem a trava de conta original):
   https://github.com/Diegiwg/PrismLauncher-Cracked/releases/latest
   → arquivo **`PrismLauncher-Windows-MSVC-Setup-11.1.1.exe`**
   - O Windows pode mostrar "O Windows protegeu o computador": clique em **Mais informações → Executar assim mesmo**.
2. Instale e abra. Na primeira tela, aceite o Java que ele sugerir (ou clique em **Baixar Java 21**).
3. Canto superior direito → **Contas → Gerenciar contas → Adicionar offline**.
4. Digite o **nick** que você vai usar no servidor (sem espaço, sem acento) → **OK**.
5. Selecione essa conta e clique em **Definir como padrão**.

> A partir daqui os passos são **iguais** para os dois launchers.

---

## Passo 3 — Instalar o modpack

1. Baixe a instância pronta: **https://github.com/LuizBrugnera/modpack-guerra/releases/latest** → arquivo **`ModpackGuerra-Prism.zip`** (não precisa descompactar).
2. No launcher, clique em **Adicionar instância** (canto superior esquerdo).
3. No menu da esquerda, escolha **Importar**.
4. Clique em **Procurar** → selecione o `ModpackGuerra-Prism.zip` → **OK**.

Pronto: ela baixa **todos os mods sozinha** na primeira vez que você abrir o jogo e **se atualiza sozinha** toda vez que o admin mudar o pack. Você nunca mais precisa reimportar.

> Na primeira abertura aparece uma janelinha do *packwiz-installer* baixando os mods. Espere ela terminar.

<details>
<summary>Alternativa: importar o .mrpack (sem atualização automática)</summary>

1. Peça ao admin o `ModpackGuerra-0.1.0.mrpack` e importe do mesmo jeito.
2. Baixe à mão o `cbcaeronauticsmissiles-0.2.0.jar` (Create: Simulated Missiles) em https://www.curseforge.com/minecraft/mc-mods/create-simulated-missiles-create-aeronautics/files/8746555 e coloque em: botão direito na instância → **Pasta** → `minecraft` → `mods`.
3. A cada atualização do pack, importe o `.mrpack` novo.
</details>

---
## Passo 4 — Memória

1. Botão direito na instância → **Editar**.
2. **Configurações → Java** → marque **Memória**.
3. **Memória máxima: `8192`** MB (se o PC tiver só 8 GB no total, use `6144`).
4. Feche a janela.

---

## Passo 5 — Entrar no servidor

1. Dê dois cliques na instância **Modpack Guerra**. A primeira abertura demora (2–5 min).
2. **Multijogador → Adicionar servidor**.
   - Nome: `Guerra`
   - Endereço: **o IP do servidor no Radmin** (o admin passa)
3. **Pronto** → clique no servidor → **Entrar no servidor**.

### Primeiro acesso
- **Conta original:** entra direto.
- **Conta pirata:** você entra parado. Abra o chat (**T**) e crie sua senha:
  ```
  /register SUASENHA SUASENHA
  ```
  Nas próximas vezes:
  ```
  /login SUASENHA
  ```
  Esqueceu a senha? Peça ao admin para resetar (`auth remove SeuNick`).
  Trocar a senha: `/auth changepassword NOVA NOVA`

---

## Passo 6 — Primeiros ajustes no jogo
- **Voice chat:** aperte **V** → escolha o microfone → teste. Use os grupos de voz do seu time.
- **Teclas:** *Opções → Controles*. Create Aeronautics, TaCZ e voice chat adicionam muitos atalhos; resolva os que estiverem em vermelho.
- **Distância:** o pack já vem com Distant Horizons em 64 chunks (~1 km) e 4 threads, e o servidor limita a distância normal a 8. Ainda lagando? *Opções → Distant Horizons* → baixe para 32, e *Opções → Pacotes de shaders → Desligado*.

---

## Deu errado?

| Problema | Solução |
|---|---|
| "Mods incompatíveis" / lista de mods ao conectar | Feche e abra o jogo de novo (a instância se atualiza na abertura). Se usou o `.mrpack`: confira o jar do Simulated Missiles e importe o `.mrpack` novo. |
| "Tempo esgotado" / não conecta | Radmin desligado, ou o servidor está desligado. Confira a bolinha verde do admin no Radmin. |
| Jogo fecha sozinho ao abrir | Pouca memória: confira o Passo 4. |
| Fica parado ao entrar (pirata) | Você ainda não fez `/register` ou `/login`. |
| Pirata: erro de autenticação / "sessão inválida" ao conectar | Seu nick já pertence a uma conta original e o servidor tenta verificá-la na Mojang. Crie a conta offline com **outro nick**. |
| Outro problema | Botão direito na instância → **Pasta** → `minecraft/logs/latest.log` → mande para o admin. |

---

## Regras do servidor (resumo)
- Explosões só destroem blocos no **horário de guerra**: sexta e sábado, 20h–23h (Brasília). Fora disso elas ainda ferem, mas não quebram nada.
- Armas nucleares não são craftáveis: só aparecem em eventos.
- Blocos à prova total de explosão têm limite por jogador.
- **Não use o nick de outra pessoa.**
