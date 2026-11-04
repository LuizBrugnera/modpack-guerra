package guerra.weather2fix.mixin;

import guerra.weather2fix.ProtecaoBombas;
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.BlockGetter;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

// O Project Explosive trata dureza negativa como "inquebrável". Para um bloco protegido,
// a bomba passa a enxergar dureza -1: ela nem tenta quebrar nem transformar em destroço
// (assim o bloco não é duplicado como bloco caindo).
@Mixin(value = BlockBehaviour.BlockStateBase.class, remap = false)
public abstract class PeDurezaMixin {
    @Inject(method = "getDestroySpeed(Lnet/minecraft/world/level/BlockGetter;Lnet/minecraft/core/BlockPos;)F",
            at = @At("HEAD"), cancellable = true, remap = false)
    private void guerra$durezaParaBomba(BlockGetter nivel, BlockPos pos, CallbackInfoReturnable<Float> cir) {
        if (ProtecaoBombas.protegido((BlockState) (Object) this)) {
            cir.setReturnValue(-1.0f);
        }
    }
}
