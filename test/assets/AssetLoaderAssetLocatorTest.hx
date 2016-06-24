package assets;

import mocks.MockTextAsset;
import assets.kha.KhaTextAsset;
import util.MappedSubscriber;
import util.MappedSubscriber;
import mocks.MockBitmapNode;
import core.ObjectCreator;
import display.BitmapNode;
import mocks.MockSoundAsset;
import error.Logger;
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
    private var soundAsset: MockSoundAsset;
    private var textAsset: MockTextAsset;
    private var assetLoader: AssetLoader;
    private var errorManager: Logger;
    private var objectCreator: ObjectCreator;
    private var bitmapNode: MockBitmapNode;
    private var imageData: Dynamic;
    private var subscriber: MappedSubscriber;

    @Before
    public function setup():Void {
        assetLoader = mock(AssetLoader);

        imageData = {};
        imageAsset = mock(MockImageAsset);

        soundAsset = mock(MockSoundAsset);
        textAsset = new MockTextAsset();
        errorManager = mock(Logger);
        objectCreator = mock(ObjectCreator);
        bitmapNode = mock(MockBitmapNode);

        subscriber = mock(MappedSubscriber);
        subscriber.init().callsRealMethod();
        subscriber.subscribe(cast any, cast any).callsRealMethod();
        subscriber.notify(cast any, cast any).callsRealMethod();
        subscriber.unsubscribe(cast any, cast any).callsRealMethod();
        subscriber.init();
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        objectCreator.createInstance(SoundAsset).returns(soundAsset);
        objectCreator.createInstance(ImageAsset).returns(imageAsset);
        objectCreator.createInstance(TextAsset).returns(textAsset);

        assetLocator = new AssetLoaderAssetLocator();
        assetLocator.assetLoader = assetLoader;
        assetLocator.errorManager = errorManager;
        assetLocator.objectCreator = objectCreator;
        assetLocator.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetAssetByName(): Void {
        mockImage();
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

    @Test
    public function shouldGetSoundAssetByName(): Void {
        assetLoader.loadSound("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: {}});
        });
        var cbCalled: Bool = false;
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            Assert.areEqual(soundAsset, asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadSound("foo", cast any).verify();
    }

    @Test
    public function shouldReturnNullWithLogToErrorManager(): Void {
        assetLoader.loadSound("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.FAIL, data: "Unable to load resource"});
        });
        var cbCalled: Bool = false;
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            Assert.isNull(asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadSound("foo", cast any).verify();
        errorManager.logError(cast any).verify();
    }

    @Test
    public function shouldLoadImageAssetLazilyAndCallsCallback(): Void {
        imageAsset.data.returns(imageData);

        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });

        var cbCalled: Bool = false;
        objectCreator.createInstance(BitmapNode).returns(bitmapNode);
        var returnNode: BitmapNode = assetLocator.getLazyAsset("foo", function(asset: ImageAsset): Void {
            Assert.areEqual(imageData, asset.data);
            Assert.areEqual(imageAsset, asset);
            cbCalled = true;
        });

        Assert.areEqual(bitmapNode, returnNode);

        bitmapNode.set_imageData(imageData).verify(0);

        loadedImageCallback({status: ResourceStatus.OK, data: imageAsset});

        Assert.isTrue(cbCalled);
        bitmapNode.set_imageData(imageData).verify();
    }

    @Test
    public function shouldNotAssignImageDataIfAssetLoadFails(): Void {
        imageAsset.data.returns(null);

        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });

        var cbCalled: Bool = false;
        objectCreator.createInstance(BitmapNode).returns(bitmapNode);
        var returnNode: BitmapNode = assetLocator.getLazyAsset("foo", function(asset: ImageAsset): Void {
            Assert.isNull(asset);
            cbCalled = true;
        });

        Assert.areEqual(bitmapNode, returnNode);

        bitmapNode.set_imageData(imageData).verify(0);

        loadedImageCallback({status: ResourceStatus.FAIL, data: "error message"});

        Assert.isTrue(cbCalled);
        bitmapNode.set_imageData(imageData).verify(0);
    }

    @Test
    public function shouldNotCallOnCompleteIfCallbackIsNull(): Void {
        imageAsset.data.returns(imageData);

        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });

        objectCreator.createInstance(BitmapNode).returns(bitmapNode);
        var returnNode: BitmapNode = assetLocator.getLazyAsset("foo");

        Assert.areEqual(bitmapNode, returnNode);

        bitmapNode.set_imageData(imageData).verify(0);

        loadedImageCallback({status: ResourceStatus.OK, data: imageAsset});

        bitmapNode.set_imageData(imageData).verify();
    }

    @Test
    public function shouldGetTextAssetByName(): Void {
        assetLoader.loadText("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: "bar"});
        });
        var cbCalled: Bool = false;
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            Assert.areEqual("bar", asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadText("foo", cast any).verify();
    }

    @Test
    public function shouldReturnErrorWithMessageIfAssetUnableToLoadText(): Void {
        assetLoader.loadText("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.FAIL, data: "Unable to load resource"});
        });
        var cbCalled: Bool = false;
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            Assert.isNull(asset);
            cbCalled = true;
        });

        Assert.isTrue(cbCalled);
        assetLoader.loadText("foo", cast any).verify();
        errorManager.logError(cast any).verify();
    }

    @Test
    public function shouldOnlyLoadSameImageAssetOnce(): Void {
        mockImage();
        var cbCount: Int = 0;
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            cbCount++;
        });

        Assert.areEqual(2, cbCount);
        assetLoader.loadImage("foo", cast any).verify();
    }

    @Test
    public function shouldOnlyLoadSameSoundAssetOnce(): Void {
        assetLoader.loadSound("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: {}});
        });

        var cbCount: Int = 0;
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            cbCount++;
        });

        Assert.areEqual(2, cbCount);
        assetLoader.loadSound("foo", cast any).verify();
    }

    @Test
    public function shouldOnlyLoadSameTextAssetOnce(): Void {
        assetLoader.loadText("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: "bar"});
        });
        var cbCount: Int = 0;
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            cbCount++;
            Assert.areEqual("bar", asset);
        });
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            cbCount++;
            Assert.areEqual("bar", asset);
        });

        Assert.areEqual(2, cbCount);
        assetLoader.loadText("foo", cast any).verify();
    }

    @Test
    public function shouldDisposeImageAssetIfHasBeenFullyDisposed(): Void {
        mockImage();
        var cbCount: Int = 0;
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getAssetByName("foo", function(asset: ImageAsset): Void {
            cbCount++;
        });

        assetLocator.disposeAsset("foo");
        imageAsset.dispose().verify(0);

        assetLocator.disposeAsset("foo");
        imageAsset.dispose().verify();

        Assert.isFalse(assetLocator.loadedMap.exists("foo"));
    }

    @Test
    public function shouldDisposeSoundAssetIfHasBeenFullyDisposed(): Void {
        assetLoader.loadSound("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: {}});
        });
        var cbCount: Int = 0;
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("foo", function(asset: SoundAsset): Void {
            cbCount++;
        });

        assetLocator.disposeAsset("foo");
        soundAsset.dispose().verify(0);

        assetLocator.disposeAsset("foo");
        soundAsset.dispose().verify();

        Assert.isFalse(assetLocator.loadedMap.exists("foo"));
    }

    @Test
    public function shouldDisposeDataAssetIfHasBeenFullyDisposed(): Void {
        assetLoader.loadText("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: "bar"});
        });
        var cbCount: Int = 0;
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            cbCount++;
        });
        assetLocator.getDataAssetByName("foo", function(asset: String): Void {
            cbCount++;
        });

        assetLocator.disposeAsset("foo");
        assetLocator.disposeAsset("foo");

        Assert.isFalse(assetLocator.loadedMap.exists("foo"));
    }

    @Test
    public function shouldSubscribeToAllAssetsLoaded(): Void {
        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("image", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });
        var loadedSoundCallback: Resource->Void = null;
        assetLoader.loadSound("sound", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedSoundCallback = args[1];
        });
        var loadedTextCallback: Resource->Void = null;
        assetLoader.loadText("text", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedTextCallback = args[1];
        });

        var cbCalled: Bool = false;
        var cb: Void->Void = function(): Void {
            cbCalled = true;
        }
        assetLocator.subscribeAllAssetsLoaded(cb);

        var cbCount: Int = 0;
        assetLocator.getAssetByName("image", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("sound", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getDataAssetByName("text", function(text: String): Void {
            cbCount++;
        });

        loadedSoundCallback({status: ResourceStatus.OK, data: soundAsset});
        Assert.isFalse(cbCalled);
        loadedImageCallback({status: ResourceStatus.OK, data: imageAsset});
        Assert.isFalse(cbCalled);
        loadedTextCallback({status: ResourceStatus.OK, data: "hello world"});
        Assert.isTrue(cbCalled);
    }

    @Test
    public function shouldUnsubscribeFromAllAssetsLoaded(): Void {
        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("image", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });
        var loadedSoundCallback: Resource->Void = null;
        assetLoader.loadSound("sound", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedSoundCallback = args[1];
        });
        var loadedTextCallback: Resource->Void = null;
        assetLoader.loadText("text", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedTextCallback = args[1];
        });

        var cbCalled: Bool = false;
        var cb: Void->Void = function(): Void {
            cbCalled = true;
        }
        assetLocator.subscribeAllAssetsLoaded(cb);

        var cbCount: Int = 0;
        assetLocator.getAssetByName("image", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("sound", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getDataAssetByName("text", function(text: String): Void {
            cbCount++;
        });

        loadedSoundCallback({status: ResourceStatus.OK, data: soundAsset});
        Assert.isFalse(cbCalled);
        loadedImageCallback({status: ResourceStatus.OK, data: imageAsset});
        Assert.isFalse(cbCalled);
        assetLocator.unSubscribeAllAssetsLoaded(cb);
        loadedTextCallback({status: ResourceStatus.OK, data: "hello world"});
        Assert.isFalse(cbCalled);
    }

    @Test
    public function shouldRemoveAllReferencesOnDispose(): Void {
        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("image", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });
        var loadedSoundCallback: Resource->Void = null;
        assetLoader.loadSound("sound", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedSoundCallback = args[1];
        });
        var loadedTextCallback: Resource->Void = null;
        assetLoader.loadText("text", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedTextCallback = args[1];
        });

        var cbCalled: Bool = false;
        var cb: Void->Void = function(): Void {
            cbCalled = true;
        }
        assetLocator.subscribeAllAssetsLoaded(cb);

        var cbCount: Int = 0;
        assetLocator.getAssetByName("image", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("sound", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getDataAssetByName("text", function(text: String): Void {
            cbCount++;
        });

        assetLocator.dispose();

        subscriber.unsubscribeAll("assetsLoaded").verify();
        objectCreator.disposeInstance(subscriber).verify();
        assetLoader.cancelLoadImage("image").verify();
        assetLoader.cancelLoadSound("sound").verify();
        assetLoader.cancelLoadText("text").verify();
        Assert.isNull(assetLocator.assetLoader);
        Assert.isNull(assetLocator.errorManager);
        Assert.isNull(assetLocator.objectCreator);
        Assert.isNull(assetLocator.mappedSubscriber);
        Assert.isNull(assetLocator.loadedMap);
        Assert.isNull(assetLocator.currentlyBeingLoaded);
    }

    @Test
    public function shouldNotErrorIfFinishLoadingOnDispose(): Void {
        var loadedImageCallback: Resource->Void = null;
        assetLoader.loadImage("image", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedImageCallback = args[1];
        });
        var loadedSoundCallback: Resource->Void = null;
        assetLoader.loadSound("sound", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedSoundCallback = args[1];
        });
        var loadedTextCallback: Resource->Void = null;
        assetLoader.loadText("text", cast any).calls(function(args: Array<Dynamic>): Void {
            loadedTextCallback = args[1];
        });

        var cbCalled: Bool = false;
        var cb: Void->Void = function(): Void {
            cbCalled = true;
        }
        assetLocator.subscribeAllAssetsLoaded(cb);

        var cbCount: Int = 0;
        assetLocator.getAssetByName("image", function(asset: ImageAsset): Void {
            cbCount++;
        });
        assetLocator.getSoundAssetByName("sound", function(asset: SoundAsset): Void {
            cbCount++;
        });
        assetLocator.getDataAssetByName("text", function(text: String): Void {
            cbCount++;
        });

        assetLocator.dispose();

        loadedSoundCallback({status: ResourceStatus.OK, data: soundAsset});
        loadedImageCallback({status: ResourceStatus.OK, data: imageAsset});
        loadedTextCallback({status: ResourceStatus.OK, data: "hello world"});

        Assert.isTrue(true);
    }

    @IgnoreCover
    private function mockImage():Void {
        assetLoader.loadImage("foo", cast any).calls(function(args: Array<Dynamic>): Void {
            args[1]({status: ResourceStatus.OK, data: {}});
        });
    }
}