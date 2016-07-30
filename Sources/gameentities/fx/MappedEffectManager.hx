package gameentities.fx;
import world.WorldPoint;
import gameentities.fx.SpecialEffect;
import core.ObjectCreator;
class MappedEffectManager implements EffectManager {

    private var effectInc: UInt = 0;

    @inject
    public var objectCreator: ObjectCreator;

    private var mappedEffect: Map<String, SpecialEffect>;

    public function new() {
    }

    public function init():Void {
        mappedEffect = new Map<String, SpecialEffect>();
        effectInc = 0;
    }

    public function dispose():Void {
        for(effect in mappedEffect) {
            effect.end(onEffectEnd);
        }
        mappedEffect = null;
        objectCreator = null;
    }

    public function spawnEffect(effectClass:Class<SpecialEffect>, worldPoint: WorldPoint):String {
        var effect: SpecialEffect = objectCreator.createInstance(effectClass);
        effect.begin(worldPoint);
        var key: String = effectInc++ + "";
        mappedEffect.set(key, effect);
        return key;
    }

    public function endEffect(key:String):Void {
        var effect: SpecialEffect = mappedEffect.get(key);
        if(effect != null) {
            effect.end(onEffectEnd);
            mappedEffect.remove(key);
        }
    }

    private function onEffectEnd(specialEffect:SpecialEffect):Void {
        objectCreator.disposeInstance(specialEffect);
    }

}
