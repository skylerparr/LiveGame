package gameentities.fx;

import world.two.WorldPoint2D;
import world.WorldPoint;
import core.ObjectCreator;
import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class MappedEffectManagerTest {

    private var effectManager: MappedEffectManager;
    private var objectCreator: ObjectCreator;
    private var specialEffect: SpecialEffect;
    private var worldPoint: WorldPoint;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        specialEffect = mock(SpecialEffect);

        worldPoint = new WorldPoint2D();
        objectCreator.createInstance(SpecialEffect).returns(specialEffect);

        effectManager = new MappedEffectManager();
        effectManager.objectCreator = objectCreator;
        effectManager.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSpawnSpecialEffect(): Void {
        var key: String = effectManager.spawnEffect(SpecialEffect, worldPoint);

        Assert.areEqual("1", key);
        specialEffect.begin(worldPoint).verify();
    }

    @Test
    public function shouldEndSpecialEffect(): Void {
        var key: String = effectManager.spawnEffect(SpecialEffect, worldPoint);

        specialEffect.end(cast isNotNull).calls(endSpecialEffect);
        effectManager.endEffect(key);

        Assert.isFalse(effectManager.mappedEffect.exists(key));
        specialEffect.end(cast isNotNull).verify();
        objectCreator.disposeInstance(specialEffect);
    }

    @Test
    public function shouldNotCallEndIfEffectNotFound(): Void {
        effectManager.endEffect("foo");
        specialEffect.end(cast any).verify(0);
    }

    @Test
    public function shouldDispose(): Void {
        var key: String = effectManager.spawnEffect(SpecialEffect, worldPoint);

        effectManager.dispose();
        objectCreator.disposeInstance(specialEffect).verify();
        Assert.isNull(effectManager.objectCreator);
        Assert.isNull(effectManager.mappedEffect);
    }

    private function endSpecialEffect(args):Void {
        args[0](specialEffect);
    }
}