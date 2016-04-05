package assets;
import core.BaseObject;
interface SoundAsset extends BaseObject {
    function play(): Void;
    function pause(): Void;
    function resume(): Void;
    function stop(): Void;
}
