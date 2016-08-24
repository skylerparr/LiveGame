package world;

import mocks.MockGameObject;
import mocks.MockDisplayNodeContainer;
import display.DisplayNode;
import gameentities.UnitFactory;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class UnitTypeEntityFactoryTest {

    private var entityFactory: UnitTypeEntityFactory;
    private var objectCreator: ObjectCreator;
    private var unitFactory: UnitFactory;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        unitFactory = mock(UnitFactory);

        entityFactory = new UnitTypeEntityFactory();
        entityFactory.objectCreator = objectCreator;
        entityFactory.unitFactory = unitFactory;
        entityFactory.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldReturnDisplayForEntity(): Void {
        var d: DisplayNode = mock(MockDisplayNodeContainer);
        var entity: MockGameObject = mock(MockGameObject);
        entity.type.returns("42");
        unitFactory.createUnitDisplayByUnitTypeId("42").returns(d);
        var display: DisplayNode = entityFactory.createViewForEntity(entity);
        unitFactory.createUnitDisplayByUnitTypeId("42").verify();
    }

    @Test
    public function shouldDisposeViewForEntity(): Void {
        var entity: MockGameObject = mock(MockGameObject);
        var d: DisplayNode = mock(MockDisplayNodeContainer);
        entityFactory.disposeViewForEntity(entity, d);
        objectCreator.disposeInstance(d).verify();
    }

    @Test
    public function shouldDispose(): Void {
        entityFactory.dispose();
        Assert.isNull(entityFactory.objectCreator);
        Assert.isNull(entityFactory.unitFactory);
    }
}