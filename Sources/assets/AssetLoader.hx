package assets;
import core.BaseObject;
interface AssetLoader extends BaseObject {
    function loadImage(name: String, onComplete: Resource->Void): Void;
    function loadSound(name: String, onComplete: Resource->Void): Void;
    function loadText(name: String, onComplete: Resource->Void): Void;

    function cancelLoadImage(name: String): Void;
    function cancelLoadSound(name: String): Void;
    function cancelLoadText(name: String): Void;
}
