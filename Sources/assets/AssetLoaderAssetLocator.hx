package assets;
import assets.Resource.ResourceStatus;
import error.ErrorManager;
import assets.ImageAsset;
import display.BitmapNode;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class AssetLoaderAssetLocator implements AssetLocator {

    @inject
    public var assetLoader: AssetLoader;
    @inject
    public var errorManager: ErrorManager;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function getAssetByName(name:String, onComplete:ImageAsset->Void):Void {
        loadImage(name, onComplete);
    }

    @:async
    private function loadImage(name:String):ImageAsset {
        var resource: Resource = @await assetLoader.loadImage(name);
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

    public function getSoundAssetByName(name:String, onComplete:SoundAsset -> Void):Void {
    }

    public function getLazyAsset(name:String, onComplete:ImageAsset->Void = null):BitmapNode {
        return null;
    }

    public function getDataAssetByName(name:String, onComplete:String->Void):Void {
    }

    public function disposeAsset(name:String):Void {
    }

    public function subscribeAllAssetsLoaded(onComplete:Void->Void):Void {
    }

    public function unSubscribeAllAssetsLoaded(onComplete:Void->Void):Void {
    }

}
