package guerra.weather2fix.mixin;

import guerra.weather2fix.ProtecaoBombas;
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.chunk.LevelChunk;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

// A bomba nuclear e os destroços escrevem direto no chunk, sem passar pelo Level.
@Mixin(value = LevelChunk.class, remap = false)
public abstract class PeChunkSetBlockMixin {
    @Inject(method = "setBlockState(Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;Z)Lnet/minecraft/world/level/block/state/BlockState;",
            at = @At("HEAD"), cancellable = true, remap = false)
    private void guerra$protegerDaBomba(BlockPos pos, BlockState novo, boolean movendo, CallbackInfoReturnable<BlockState> cir) {
        LevelChunk chunk = (LevelChunk) (Object) this;
        if (chunk.getLevel().isClientSide()) return; // as bombas só rodam no servidor
        BlockState atual = chunk.getBlockState(pos);
        if (ProtecaoBombas.bloquearTrocaNoChunk(pos.asLong(), atual, novo)) {
            cir.setReturnValue(null); // null = nada mudou
        }
    }
}
