package guerra.weather2fix.mixin;

import guerra.weather2fix.ProtecaoBombas;
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

// setBlock, setBlockAndUpdate, removeBlock e destroyBlock passam todos por aqui.
@Mixin(value = Level.class, remap = false)
public abstract class PeLevelSetBlockMixin {
    @Inject(method = "setBlock(Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;II)Z",
            at = @At("HEAD"), cancellable = true, remap = false)
    private void guerra$protegerDaBomba(BlockPos pos, BlockState novo, int flags, int recursao, CallbackInfoReturnable<Boolean> cir) {
        Level nivel = (Level) (Object) this;
        if (nivel.isClientSide()) return; // as bombas só rodam no servidor
        BlockState atual = nivel.getBlockState(pos);
        if (ProtecaoBombas.bloquearTrocaNoLevel(pos.asLong(), atual, novo)) {
            cir.setReturnValue(false);
        }
    }
}
