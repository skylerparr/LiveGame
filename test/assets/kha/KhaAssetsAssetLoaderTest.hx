package assets.kha;

import assets.Resource.ResourceStatus;
import mocks.MockKhaAssets;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class KhaAssetsAssetLoaderTest {

    private var assetLoader: KhaAssetsAssetLoader;
    private var assets: MockKhaAssets;
    private var data: Dynamic;

    @Before
    public function setup():Void {
        assets = mock(MockKhaAssets);
        data = {};

        assetLoader = new KhaAssetsAssetLoader();
        assetLoader.mockKhaAssets = assets;
        assetLoader.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldLoadImageAssetByName(): Void {
        assets.loadImage("foo", cast any).calls(function(args): Void {
            args[1](data);
        });

        var cbCalled: Bool = false;
        assetLoader.loadImage("foo", function(resource: Resource): Void {
            cbCalled = true;
            Assert.areEqual(ResourceStatus.OK, resource.status);
            Assert.areEqual(data, resource.data);
        });

        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldLoadSoundAssetByName(): Void {
        assets.loadSound("foo", cast any).calls(function(args): Void {
            args[1](data);
        });

        var cbCalled: Bool = false;
        assetLoader.loadSound("foo", function(resource: Resource): Void {
            cbCalled = true;
            Assert.areEqual(ResourceStatus.OK, resource.status);
            Assert.areEqual(data, resource.data);
        });

        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldLoadTextByName(): Void {
        assets.loadBlob("foo", cast any).calls(function(args): Void {
            args[1](data);
        });

        var cbCalled: Bool = false;
        assetLoader.loadText("foo", function(resource: Resource): Void {
            cbCalled = true;
            Assert.areEqual(ResourceStatus.OK, resource.status);
            Assert.areEqual(data, resource.data);
        });

        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldNotLoadTheSameTextAssetTwiceConcurrently(): Void {
        var cb: Dynamic->Void = null;
        assets.loadBlob("foo", cast any).calls(function(args): Void {
            cb = args[1];
        });

        var cbCount: Int = 0;
        assetLoader.loadText("foo", function(resource: Resource): Void {
            cbCount++;
        });
        assetLoader.loadText("foo", function(resource: Resource): Void {
            cbCount++;
        });

        Assert.areEqual(0, cbCount);
        assets.loadBlob("foo", cast any).verify();

        cb(data);
        Assert.areEqual(2, cbCount);
        assets.loadBlob("foo", cast any).verify(0);

        Assert.isFalse(assetLoader.currentlyLoadingMap.exists("foo"));
    }

    @Test
    public function shouldCancelLoadingOfText(): Void {
        var cb: Dynamic->Void = null;
        assets.loadBlob("foo", cast any).calls(function(args): Void {
            cb = args[1];
        });

        var cbCount: Int = 0;
        assetLoader.loadText("foo", function(resource: Resource): Void {
            cbCount++;
        });

        Assert.areEqual(0, cbCount);
        assets.loadBlob("foo", cast any).verify();

        assetLoader.cancelLoadText("foo");

        cb(data);

        Assert.areEqual(0, cbCount);
    }

    @Test
    public function shouldCancelLoadingOfImage(): Void {
        var cb: Dynamic->Void = null;
        assets.loadImage("foo", cast any).calls(function(args): Void {
            cb = args[1];
        });

        var cbCount: Int = 0;
        assetLoader.loadImage("foo", function(resource: Resource): Void {
            cbCount++;
        });

        Assert.areEqual(0, cbCount);
        assets.loadImage("foo", cast any).verify();

        assetLoader.cancelLoadImage("foo");

        cb(data);

        Assert.areEqual(0, cbCount);
    }

    @Test
    public function shouldCancelLoadingOfSound(): Void {
        var cb: Dynamic->Void = null;
        assets.loadSound("foo", cast any).calls(function(args): Void {
            cb = args[1];
        });

        var cbCount: Int = 0;
        assetLoader.loadSound("foo", function(resource: Resource): Void {
            cbCount++;
        });

        Assert.areEqual(0, cbCount);
        assets.loadSound("foo", cast any).verify();

        assetLoader.cancelLoadSound("foo");

        cb(data);

        Assert.areEqual(0, cbCount);
    }

    @Test
    public function shouldDispose(): Void {
        assetLoader.dispose();
        Assert.isNull(assetLoader.currentlyLoadingMap);
    }
}