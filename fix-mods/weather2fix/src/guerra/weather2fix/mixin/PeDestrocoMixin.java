package guerra.weather2fix.mixin;

import guerra.weather2fix.ProtecaoBombas;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.item.FallingBlockEntity;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

// Dois caminhos de destroço do Project Explosive chamam FallingBlockEntity.fall sem olhar a
// dureza. Para bloco protegido, devolve um destroço "fantasma" que nunca entra no mundo:
// o bloco fica onde está e não é duplicado.
@Mixin(value = FallingBlockEntity.class, remap = false)
public abstract class PeDestrocoMixin {
    @Inject(method = "fall(Lnet/minecraft/world/level/Level;Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;)Lnet/minecraft/world/entity/item/FallingBlockEntity;",
            at = @At("HEAD"), cancellable = true, remap = false)
    private static void guerra$naoArrancar(Level nivel, BlockPos pos, BlockState estado, CallbackInfoReturnable<FallingBlockEntity> cir) {
        if (ProtecaoBombas.protegidoDeVirarDestroco(estado)) {
            cir.setReturnValue(EntityType.FALLING_BLOCK.create(nivel));
        }
    }
}
