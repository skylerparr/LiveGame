package util;
import display.LayerManager;
import core.BaseObject;
class Fps implements BaseObject{
    
    @inject
    public var layerManager: LayerManager;



    public function new() {
    }

    public function init():Void {
        drawFps();
    }

    public function dispose():Void {
    }

    private inline function drawFps():Void {

    }
}
