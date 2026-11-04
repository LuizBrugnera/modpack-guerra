package guerra.weather2fix.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.gen.Accessor;

// Dá acesso ao campo privado que o DH usa para lembrar se já se ligou ao Chunky.
@Mixin(targets = "com.seibel.distanthorizons.core.wrapperInterfaces.modAccessor.AbstractChunkyAccessor", remap = false)
public interface DhChunkyAccessorAccess {
    @Accessor(value = "listenerBound", remap = false)
    void guerra$setListenerBound(boolean valor);
}
