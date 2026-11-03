# Modpack Guerra — como entrar no servidor

Vale para **conta original** e **conta pirata**. Só o passo 2 muda.
Tempo total: uns 15 minutos (a maior parte é download).

**Você vai precisar:**
- O arquivo **`ModpackGuerra-0.1.0.mrpack`** (o admin manda)
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

1. Clique em **Adicionar instância** (canto superior esquerdo).
2. No menu da esquerda, escolha **Importar**.
3. Clique em **Procurar** → selecione o `ModpackGuerra-0.1.0.mrpack` → **OK**.
4. Espere baixar (são ~60 mods, pode levar alguns minutos).

### Mod que precisa ser colocado à mão (1 arquivo)
O autor do *Sentry Mechanical Arm* não deixa launchers baixarem automaticamente:

1. Abra: https://www.curseforge.com/minecraft/mc-mods/create-sentry-mechanical-arm-1/files/8897599
2. Clique em **Download** e espere baixar o `sentrymechanicalarm-neoforge-1.21.1-1.3.7.jar`.
3. No launcher: clique com o **botão direito** na instância **Modpack Guerra** → **Pasta**.
4. Entre em **`minecraft`** → **`mods`** e **cole o arquivo** baixado ali.

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
- **PC fraco:** *Opções → Pacotes de shaders → Desligado*, e reduza o alcance do Distant Horizons.

---

## Deu errado?

| Problema | Solução |
|---|---|
| "Mods incompatíveis" / lista de mods ao conectar | Falta o jar do Sentry (Passo 3) ou o pack está desatualizado: reimporte o `.mrpack` novo. |
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
