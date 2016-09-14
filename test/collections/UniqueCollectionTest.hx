package collections;

import geom.Rectangle;
import collections.UniqueCollection;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class UniqueCollectionTest {

    private var collection: UniqueCollection<Dynamic>;

    @Before
    public function setup():Void {
        collection = new UniqueCollection<Dynamic>();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAddItemToCollection(): Void {
        Assert.areEqual(0, collection.length);

        var item = {};
        collection.add(item);

        Assert.areEqual(1, collection.length);
    }

    @Test
    public function shouldRemoveItemFromCollection(): Void {
        var item = {};
        collection.add(item);
        collection.remove(item);

        Assert.areEqual(0, collection.length);
    }

    @Test
    public function shouldNotAddTheSameItemTwice(): Void {
        Assert.areEqual(0, collection.length);

        var item = {};
        collection.add(item);
        collection.add(item);

        Assert.areEqual(1, collection.length);
    }

    @Test
    public function shouldEnforceInsertOrder(): Void {
        var item = {};
        var item2 = "";
        var item3 = new Rectangle();
        var array: Array<Dynamic> = [];
        array.push(item);
        array.push(item2);
        array.push(item3);

        collection.add(item);
        collection.add(item2);
        collection.add(item3);

        var iterated: Bool = false;
        var counter: Int = 0;
        for(item in collection) {
            iterated = true;
            Assert.areEqual(array[counter], item);
            counter++;
        }
        Assert.isTrue(iterated);

        iterated = false;
        counter = 0;
        collection.remove(item2);
        array.remove(item2);
        for(item in collection) {
            iterated = true;
            Assert.areEqual(array[counter], item);
            counter++;
        }
        Assert.isTrue(iterated);
    }

    @Test
    public function shouldClearCollection(): Void {
        var item = {};
        var item2 = "";
        var item3 = new Rectangle();

        collection.add(item);
        collection.add(item2);
        collection.add(item3);

        collection.clear();

        Assert.areEqual(0, collection.length);
        var iterated: Bool = false;
        for(item in collection) {
            iterated = true;
        }
        Assert.isFalse(iterated);
    }

    @Test
    public function shouldGetAsList(): Void {
        var item = {};
        var item2 = "";
        var item3 = new Rectangle();

        collection.add(item);
        collection.add(item2);
        collection.add(item3);

        Assert.areEqual(item, collection.asList().first());
    }
}