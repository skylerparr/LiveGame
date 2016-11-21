package gameentities;
import constants.EventNames;
import util.Subscriber;
import world.ViewPort;
import world.GameObject;
class GameLoopViewPortTracker implements ViewPortTracker {

    @inject
    public var viewPort: ViewPort;
    @inject
    public var subscriber: Subscriber;

    public var gameObject: GameObject;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function trackToGameObject(gameObject:GameObject):Void {
        this.gameObject = gameObject;
        if(this.gameObject != null) {
            subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        }
    }

    public function untrackFromGameObject():Void {
        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
    }

    private function onUpdate():Void {
        viewPort.x = (viewPort.width * -0.5) + gameObject.x;
        viewPort.y = (viewPort.height * -0.5) + gameObject.z;
        if(viewPort.x < 0) {
            viewPort.x = 0;
        }
        if(viewPort.y < 0) {
            viewPort.y = 0;
        }
    }
}
