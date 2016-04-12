package assets;

import error.ErrorManager;
import assets.Resource.ResourceStatus;
import mocks.MockImageAsset;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class AssetLoaderAssetLocatorTest {

    private var assetLocator: AssetLoaderAssetLocator;
    private var imageAsset: MockImageAsset;
    private var assetLoader: AssetLoader;
    private var errorManager: ErrorManager;

    @Before
    public function setup():Void {
        assetLoader = mock(AssetLoader);
        imageAsset = mock(MockImageAsset);
        errorManager = mock(ErrorManager);

        assetLocator = new AssetLoaderAssetLocator();
        assetLocator.assetLoader = assetLoader;
        assetLocator.errorManager = errorManager;
        assetLocator.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetAssetByName(): Void {
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: imageAsset});
        });
        var cbCalled: Bool = false;
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            Assert.areEqual(imageAsset, asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadImage("foo", cast any).verify();
    }

    @Test
    public function shouldReturnErrorWithMessageIfAssetUnableToLoad(): Void {
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.FAIL, data: "Unable to load resource"});
        });
        var cbCalled: Bool = false;
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            Assert.isNull(asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadImage("foo", cast any).verify();
        errorManager.logError(cast any).verify();
    }
}