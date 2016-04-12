package assets;
import core.BaseObject;
import display.BitmapNode;
interface AssetLocator extends BaseObject {
    /**
     * gets an asset by name, onComplete is called when the bitmap data is ready
     */
    function getAssetByName(name: String, onComplete: ImageAsset->Void): Void;

    /**
     * gets an asset by name, onComplete is called when the bitmap data is ready
     */
    function getSoundAssetByName(name: String, onComplete: SoundAsset->Void): Void;

    /**
     * loads the asset and returns bitmap, the bitmap data will be assigned when the asset is ready.
     * onComplete will be called when the asset is assigned.
     */
    function getLazyAsset(name: String, onComplete: ImageAsset->Void = null): BitmapNode;

    /**
     * loads the data asset on calls onComplete when the data is loaded
     */
    function getDataAssetByName(name: String, onComplete: String->Void): Void;

    /**
     * disposes of the asset by name.
     */
    function disposeAsset(name: String): Void;

    /**
     * subscribe to this to be notified when all assets in the queue have been loaded
     */
    function subscribeAllAssetsLoaded(onComplete: Void->Void): Void;

    /**
     * unsubscribe to the all assets loaded
     */
    function unSubscribeAllAssetsLoaded(onComplete: Void->Void): Void;

}
