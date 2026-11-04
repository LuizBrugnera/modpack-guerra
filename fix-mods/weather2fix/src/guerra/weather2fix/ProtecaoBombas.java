package guerra.weather2fix;

import net.minecraft.world.level.block.state.BlockState;

// Duas correções para as bombas do Project Explosive (0.7.2-beta). As duas só valem quando
// quem mexe no bloco é código do Project Explosive (pacote ofuscado "lil1llilol11"):
//
// 1) RESISTÊNCIA. O mod decide o que a bomba quebra pela DUREZA do bloco (getDestroySpeed),
//    não pela resistência a explosão: só bedrock e blocos de dureza negativa escapavam. Blocos
//    de bunker (stronger_blocks *_ub, resistência 160 mil a 1,6 milhão, dureza 16-20) e o
//    concreto armado do TFMG (1200 / 12) viravam pó. Regra do Modpack Guerra:
//      resistência >= 100.000 -> nenhuma bomba quebra (nem a nuclear)
//      resistência >=   1.000 -> bombas comuns não quebram; a nuclear quebra
//      abaixo disso           -> como o mod faz normalmente
//
// 2) HORÁRIO DE GUERRA. As bombas escrevem os blocos direto no mundo, sem passar pelo evento
//    de explosão que o horario_guerra.js usa para proteger as bases. Fora do horário, o
//    horario_guerra.js chama definirPaz(true) e aqui toda troca de bloco feita pelo mod é
//    barrada (cratera, destroço caindo, fogo, contaminação). A bomba explode do mesmo jeito
//    e fere quem estiver perto.
//    (Desligar as opções do próprio mod em tempo real não funciona: ele lê a config uma vez.)
public final class ProtecaoBombas {
    public static final float RESISTENCIA_BUNKER = 100_000f;
    public static final float RESISTENCIA_BLINDADO = 1_000f;

    private static final String PACOTE_PE = "lil1llilol11.";
    private static final String CLASSE_NUCLEAR = "lil1llilol11.lo1i1iloioil.lo1iioil1oo1i0io01l1i1lo";
    private static final StackWalker PILHA = StackWalker.getInstance();

    // Atualizado pelo horario_guerra.js. Começa em "guerra": se o script falhar, o comportamento
    // é o de antes (só a regra de resistência).
    private static volatile boolean pazAtiva = false;
    private static Boolean ultimoAvisado = null;

    private ProtecaoBombas() {}

    /** Chamado pelo horario_guerra.js a cada segundo e ao usar /guerra. */
    public static void definirPaz(boolean paz) {
        pazAtiva = paz;
        if (ultimoAvisado == null || ultimoAvisado != paz) {
            ultimoAvisado = paz;
            Weather2Fix.LOG.info("[Guerra] Bombas do Project Explosive: {}",
                paz ? "fora do horário de guerra, não mexem em blocos" : "horário de guerra, quebram blocos (respeitando a resistência)");
        }
    }

    public static boolean emPaz() { return pazAtiva; }

    // 0 = não é o Project Explosive, 1 = bomba comum, 2 = nuclear
    private static int quemChama() {
        return PILHA.walk(frames -> {
            int[] achou = {0};
            frames.limit(16).forEach(f -> {
                String c = f.getClassName();
                if (c.equals(CLASSE_NUCLEAR)) achou[0] = 2;
                else if (achou[0] == 0 && c.startsWith(PACOTE_PE)) achou[0] = 1;
            });
            return achou[0];
        });
    }

    /** Dureza: a bomba que está rodando agora pode quebrar este bloco? (regra de resistência) */
    public static boolean protegido(BlockState estado) {
        if (estado == null || estado.isAir()) return false;
        float r = estado.getBlock().getExplosionResistance();
        if (r < RESISTENCIA_BLINDADO) return false; // caminho rápido: quase todo bloco sai aqui
        int quem = quemChama();
        if (quem == 0) return false;
        if (quem == 2) return r >= RESISTENCIA_BUNKER;
        return true;
    }

    /** setBlock: barra a troca? Em paz, qualquer troca do mod; em guerra, só de bloco protegido. */
    public static boolean bloquearTroca(BlockState atual, BlockState novo) {
        if (atual == null || novo == null || atual.getBlock() == novo.getBlock()) return false;
        if (pazAtiva) return quemChama() != 0;
        return protegido(atual);
    }

    // Level.setBlock chama LevelChunk.setBlockState logo em seguida, para a mesma posição.
    // Quando a troca já foi liberada no Level, a checagem do chunk é pulada (a busca na pilha
    // é a parte cara). Guardado por thread, porque o cliente também mexe em blocos.
    private static final ThreadLocal<long[]> LIBERADO_NO_LEVEL = ThreadLocal.withInitial(() -> new long[]{Long.MIN_VALUE});

    /** Usado no Level.setBlock: barra a troca? Se liberar, avisa o chunk. */
    public static boolean bloquearTrocaNoLevel(long pos, BlockState atual, BlockState novo) {
        if (bloquearTroca(atual, novo)) return true;
        LIBERADO_NO_LEVEL.get()[0] = pos;
        return false;
    }

    /** Usado no LevelChunk.setBlockState: pula se o Level acabou de liberar esta posição. */
    public static boolean bloquearTrocaNoChunk(long pos, BlockState atual, BlockState novo) {
        long[] liberado = LIBERADO_NO_LEVEL.get();
        if (liberado[0] == pos) { liberado[0] = Long.MIN_VALUE; return false; }
        return bloquearTroca(atual, novo);
    }

    /** FallingBlockEntity.fall: o bloco não pode virar destroço (senão seria duplicado). */
    public static boolean protegidoDeVirarDestroco(BlockState estado) {
        if (estado == null || estado.isAir()) return false;
        if (pazAtiva) return quemChama() != 0;
        return protegido(estado);
    }
}
