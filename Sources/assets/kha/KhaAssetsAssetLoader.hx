package assets.kha;
import assets.Resource.ResourceStatus;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class KhaAssetsAssetLoader implements AssetLoader {

    public var currentlyLoadingMap: Map<String, List<LoadDef>>;

    public function new() {
    }

    public function init():Void {
        currentlyLoadingMap = new Map<String, List<LoadDef>>();
    }

    public function dispose():Void {
    }

    public function loadImage(imageName:String, onComplete: Resource->Void):Void {
        loadResource(imageName, getAssets().loadImage, onComplete);
    }

    public function loadResource(key: String, loader: String->Dynamic->Void, onComplete: Resource->Void): Void {
        if(currentlyLoadingMap.exists(key)) {
            var loadDefs: List<LoadDef> = currentlyLoadingMap.get(key);
            loadDefs.add({key: key, callback: onComplete});
            return;
        }
        var loadDefs: List<LoadDef> = new List<LoadDef>();
        loadDefs.add({key: key, callback: onComplete});
        currentlyLoadingMap.set(key, loadDefs);

        doLoad(key, loader, function(): Void {});
    }

    @:async
    public function doLoad(key: String, loader: String->Dynamic->Void): Void {
        var data = @await loader(key);

        if(!currentlyLoadingMap.exists(key)) {
            return;
        }

        var resource: Resource = {status: ResourceStatus.OK, data: data};
        var loadDefs: List<LoadDef> = currentlyLoadingMap.get(key);
        for(loadDef in loadDefs) {
            loadDef.callback(resource);
        }
        currentlyLoadingMap.remove(key);
    }

    public function loadText(name:String, onComplete: Resource->Void):Void {
        loadResource(name, getAssets().loadBlob, onComplete);
    }

    public function loadSound(name:String, onComplete: Resource->Void):Void {
        loadResource(name, getAssets().loadSound, onComplete);
    }

    public function cancelLoadImage(name:String):Void {
    }

    public function cancelLoadSound(name:String):Void {
    }

    public function cancelLoadText(name:String):Void {
        currentlyLoadingMap.remove(name);
    }

    #if test
    public var mockKhaAssets: mocks.MockKhaAssets = new mocks.MockKhaAssets();

    public inline function getAssets():mocks.MockKhaAssets {
        return mockKhaAssets;
    }
    #else

    public inline function getAssets():kha.Assets {
        return kha.Assets;
    }
    #end
}

typedef LoadDef = {
    key: String,
    callback: Resource->Void
}