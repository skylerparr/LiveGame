package assets;
import core.BaseObject;
interface AssetLoader extends BaseObject {
    function loadImage(imageName: String, onComplete: Resource->Void): Void;
    function loadText(name: String, onComplete: Resource->Void): Void;
}
