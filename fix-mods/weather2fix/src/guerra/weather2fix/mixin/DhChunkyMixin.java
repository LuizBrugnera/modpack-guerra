package guerra.weather2fix.mixin;

import java.lang.reflect.InvocationTargetException;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

// O Distant Horizons 3.3.3 tenta se ligar ao Chunky no primeiro chunk carregado,
// mas no NeoForge o Chunky só fica pronto depois que o servidor termina de abrir.
// Resultado: "IllegalStateException: Chunky is not loaded" e o servidor cai no boot.
// Aqui, se o Chunky ainda não estiver pronto, a ligação é adiada para o próximo chunk.
//
// O Chunky é acessado por reflexão de propósito: ele só existe no servidor, e o DH
// carrega esta classe também no cliente. Uma referência direta ao Chunky aqui
// derruba o cliente ao abrir (ClassNotFoundException dentro do Mixin).
@Mixin(targets = "com.seibel.distanthorizons.neoforge.wrappers.modAccessor.ChunkyAccessor", remap = false)
public class DhChunkyMixin {
    @Inject(method = "bindOnGenerationProgressEvent", at = @At("HEAD"), cancellable = true, remap = false)
    private void guerra$esperarChunky(CallbackInfo ci) {
        try {
            Class<?> provider = Class.forName("org.popcraft.chunky.ChunkyProvider", true, this.getClass().getClassLoader());
            provider.getMethod("get").invoke(null);
        } catch (InvocationTargetException naoCarregado) {
            // ChunkyProvider.get() lançou "Chunky is not loaded": tenta de novo no próximo chunk.
            ((DhChunkyAccessorAccess) (Object) this).guerra$setListenerBound(false);
            ci.cancel();
        } catch (Throwable semChunky) {
            // Chunky não instalado (cliente): não mexe em nada.
        }
    }
}
