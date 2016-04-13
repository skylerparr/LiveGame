package assets;
import constants.Poses;
import util.MappedSubscriber;
import core.BaseObject;
import core.ObjectCreator;
import assets.Resource.ResourceStatus;
import error.ErrorManager;
import assets.ImageAsset;
import display.BitmapNode;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class AssetLoaderAssetLocator implements AssetLocator {
    private static inline var ASSETS_LOADED: String = "assetsLoaded";

    @inject
    public var assetLoader: AssetLoader;
    @inject
    public var errorManager: ErrorManager;
    @inject
    public var objectCreator: ObjectCreator;

    public var mappedSubscriber: MappedSubscriber;

    public var loadedMap: Map<String, ResourceCount>;
    public var currentlyBeingLoaded: List<String>;

    public function new() {
    }

    public function init():Void {
        loadedMap = new Map<String, ResourceCount>();
        mappedSubscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
        mappedSubscriber.unsubscribeAll(ASSETS_LOADED);
        objectCreator.disposeInstance(mappedSubscriber);
        for(loading in currentlyBeingLoaded) {
            assetLoader.cancelLoadImage(loading);
            assetLoader.cancelLoadText(loading);
            assetLoader.cancelLoadSound(loading);
        }
        loadedMap = null;
        mappedSubscriber = null;
        objectCreator = null;
        errorManager = null;
        assetLoader = null;
        currentlyBeingLoaded = null;
    }

    public function getAssetByName(name:String, onComplete:ImageAsset->Void):Void {
        fetchAsset(name, loadImage, onComplete);
    }

    private inline function fetchAsset(name, loadCall: Dynamic, onComplete: Dynamic->Void): Void {
        if(loadedMap.exists(name)) {
            var resourceCount: ResourceCount = loadedMap.get(name);
            resourceCount.count++;
            onComplete(resourceCount.resource.data);
            return;
        }
        if(currentlyBeingLoaded != null) {
            currentlyBeingLoaded.push(name);
        }
        loadCall(name, function(data: Dynamic): Void {
            if(loadedMap != null) {
                onComplete(data);
            }
        });
    }

    @:async
    private function loadImage(name:String):ImageAsset {
        var resource: Resource = @await assetLoader.loadImage(name);
        maintainAssetState(name, resource);
        return result(name, resource);
    }

    public function getSoundAssetByName(name:String, onComplete:SoundAsset -> Void):Void {
        fetchAsset(name, loadSound, onComplete);
    }

    @:async
    private function loadSound(name:String):SoundAsset {
        var resource: Resource = @await assetLoader.loadSound(name);
        maintainAssetState(name, resource);
        return result(name, resource);
    }

    private inline function result(name: String, resource: Resource): Dynamic {
        switch(resource.status) {
            case ResourceStatus.OK:
                return resource.data;
            case ResourceStatus.FAIL:
                errorManager.logError("Unable to load asset " + name);
                return null;
        }
        errorManager.logFatal("Unhandled loading status");
        throw ("Unhandled error");
        return null;
    }

    public function getLazyAsset(name:String, onComplete:ImageAsset->Void = null):BitmapNode {
        var bitmapNode: BitmapNode = objectCreator.createInstance(BitmapNode);
        loadImage(name, function(imageAsset: ImageAsset): Void {
            if(imageAsset != null) {
                bitmapNode.imageData = imageAsset.imageData;
            }
            if(onComplete != null) {
                onComplete(imageAsset);
            }
        });
        return bitmapNode;
    }

    public function getDataAssetByName(name:String, onComplete:String->Void):Void {
        fetchAsset(name, loadText, onComplete);
    }

    @:async
    private function loadText(name:String):String {
        var resource: Resource = @await assetLoader.loadText(name);
        maintainAssetState(name, resource);
        return result(name, resource);
    }

    private inline function maintainAssetState(name, resource): Void {
        if(loadedMap != null) {
            loadedMap.set(name, {count: 1, resource: resource});
            if(currentlyBeingLoaded != null) {
                currentlyBeingLoaded.pop();
                if(currentlyBeingLoaded.length == 0) {
                    mappedSubscriber.notify(ASSETS_LOADED, null);
                }
            }
        }
    }

    public function disposeAsset(name:String):Void {
        if(loadedMap.exists(name)) {
            var resourceCount: ResourceCount = loadedMap.get(name);
            resourceCount.count--;
            if(resourceCount.count == 0) {
                if(Std.is(resourceCount.resource.data, BaseObject)) {
                    resourceCount.resource.data.dispose();
                }
                loadedMap.remove(name);
            }
        }
    }

    public function subscribeAllAssetsLoaded(onComplete:Void->Void):Void {
        mappedSubscriber.subscribe(ASSETS_LOADED, onComplete);
        currentlyBeingLoaded = new List<String>();
    }

    public function unSubscribeAllAssetsLoaded(onComplete:Void->Void):Void {
        mappedSubscriber.unsubscribe(ASSETS_LOADED, onComplete);
        currentlyBeingLoaded = null;
    }

}

typedef ResourceCount = {
    count: Int,
    resource: Resource
}