package world;

import mocks.MockDisplayNodeContainer;
import display.BitmapNode;
import display.DisplayNode;
import mocks.MockGameObject;
import core.ObjectCreator;
import units.EntityFactory;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class TypeResolvedEntityFactoryTest {

    private var entityFactory: TypeResolvedEntityFactory;
    private var objectCreator: ObjectCreator;

    public function new() {

    }

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);

        entityFactory = new TypeResolvedEntityFactory();
        entityFactory.objectCreator = objectCreator;

        entityFactory.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldResolveTypeAndReturnDisplayAssociatedWithTheType(): Void {
        var gameObject: MockGameObject = new MockGameObject();
        entityFactory.mapTypeToType(MockGameObject, BitmapNode);

        var retNode: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        objectCreator.createInstance(BitmapNode).returns(retNode);

        var display: DisplayNode = entityFactory.createViewForEntity(gameObject);

        Assert.isNotNull(display);
        Assert.areEqual(retNode, display);
    }

    @Test
    public function shouldReturnNullIfNoTypeIsFound(): Void {
        var gameObject: MockGameObject = new MockGameObject();

        var retNode: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        objectCreator.createInstance(BitmapNode).returns(retNode);

        var display: DisplayNode = entityFactory.createViewForEntity(gameObject);

        Assert.isNull(display);
    }

    @Test
    public function shouldDisposeEntity(): Void {
        var gameObject: MockGameObject = new MockGameObject();

        var retNode: MockDisplayNodeContainer = mock(MockDisplayNodeContainer);
        objectCreator.createInstance(BitmapNode).returns(retNode);

        var display: DisplayNode = entityFactory.createViewForEntity(gameObject);

        entityFactory.disposeViewForEntity(gameObject, display);

        objectCreator.disposeInstance(display).verify();
    }
}
