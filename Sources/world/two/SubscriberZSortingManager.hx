package world.two;
import display.DisplayNodeContainer;
import display.DisplayNode;
import util.Subscriber;
class SubscriberZSortingManager implements ZSortingManager {

    @inject
    public var subscriber: Subscriber;
    @inject
    public var gameWorld: GameWorld;

    @:isVar
    public var updateEvent(get, set): String;

    private function get_updateEvent():String {
        return updateEvent;
    }

    private function set_updateEvent(value:String): String {
        if(updateEvent != null) {
            if(value == null) {
                if(subscriber != null) {
                    subscriber.unsubscribe(this.updateEvent, this.onUpdate);
                }
                this.updateEvent = value;
            }
            return updateEvent;
        }
        this.updateEvent = value;
        subscriber.subscribe(value, onUpdate);
        return value;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        updateEvent = null;
        subscriber = null;
        gameWorld = null;
    }

    public function onUpdate():Void {
        var displayContainer: DisplayNodeContainer = gameWorld.displayContainer;
        var entities: Array<WorldEntity> = [];
        while(displayContainer.numChildren > 0) {
            var display: DisplayNode = displayContainer.removeChildAt(0);
            var worldEntity: WorldEntity = gameWorld.getWorldEntityByDisplay(display);
            entities.push(worldEntity);
        }
        entities.sort(sortEntities);
        for(entity in entities) {
            var display: DisplayNode = gameWorld.getDisplayByGameObject(entity);
            if(display != null) {
                displayContainer.addChild(display);
            }
        }
    }

    private function sortEntities(a:WorldEntity, b:WorldEntity):Int {
        var aY: Float = a.footprint.footprint.y + a.z;
        var bY: Float = b.footprint.footprint.y + b.z;
        if(aY > bY) {
            return 1;
        } else if(aY < bY) {
            return -1;
        }
        return 0;
    }
}
