package guerra.weather2fix.mixin;

import net.minecraft.nbt.CompoundTag;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.ModifyVariable;

// O Weather2 manda para o cliente o mesmo CompoundTag que o servidor continua alterando.
// O Netty serializa o pacote em outra thread e, se o tag mudar no meio, dá
// ConcurrentModificationException e o jogador cai com
// "Failed to encode packet 'clientbound/minecraft:custom_payload'".
// Aqui o pacote passa a levar uma cópia, feita na thread do servidor.
@Mixin(targets = "weather2.WeatherNetworkingv2", remap = false)
public class NetworkingMixin {
    @ModifyVariable(
        method = {"serverSendToClientAll", "serverSendToClientPlayer", "serverSendToClientNear", "serverSendToClientsInDimension"},
        at = @At("HEAD"), argsOnly = true, ordinal = 0, remap = false)
    private CompoundTag guerra$copiar(CompoundTag tag) {
        return tag == null ? null : tag.copy();
    }
}
