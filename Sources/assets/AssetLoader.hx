package assets;
import core.BaseObject;
interface AssetLoader extends BaseObject {
    function loadImage(name: String, onSoundLoaded: ImageAsset->Void): Void;
    function loadSound(name: String, onSoundLoaded: SoundAsset->Void): Void;
}
