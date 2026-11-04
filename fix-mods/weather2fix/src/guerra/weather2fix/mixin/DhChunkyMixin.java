package guerra.weather2fix.mixin;

import org.popcraft.chunky.ChunkyProvider;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

// O Distant Horizons 3.3.3 tenta se ligar ao Chunky no primeiro chunk carregado,
// mas no NeoForge o Chunky só fica pronto depois que o servidor termina de abrir.
// Resultado: "IllegalStateException: Chunky is not loaded" e o servidor cai no boot.
// Aqui, se o Chunky ainda não estiver pronto, a ligação é adiada para o próximo chunk.
@Mixin(targets = "com.seibel.distanthorizons.neoforge.wrappers.modAccessor.ChunkyAccessor", remap = false)
public class DhChunkyMixin {
    @Inject(method = "bindOnGenerationProgressEvent", at = @At("HEAD"), cancellable = true, remap = false)
    private void guerra$esperarChunky(CallbackInfo ci) {
        try {
            ChunkyProvider.get();
        } catch (IllegalStateException naoCarregado) {
            ((DhChunkyAccessorAccess) (Object) this).guerra$setListenerBound(false);
            ci.cancel();
        }
    }
}
