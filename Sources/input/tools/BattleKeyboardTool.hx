package input.tools;
import util.Subscriber;
import world.two.WorldPoint2D;
import world.WorldPoint;
import constants.EventNames;
import gameentities.HeroInteraction;
import util.MappedSubscriber;
import core.ObjectCreator;
class BattleKeyboardTool implements KeyboardTool {

    public static inline var MOVE_DISTANCE: Float = 100000;

    private static inline var VARIATION: Float = 3;

    private static inline var NORTH_KEY: String = "w";
    private static inline var SOUTH_KEY: String = "s";
    private static inline var WEST_KEY: String = "a";
    private static inline var EAST_KEY: String = "d";

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var heroInteraction: HeroInteraction;
    @inject
    public var subscriber: Subscriber;

    public var currentPressedKeys: Map<String, KeyEvent>;

    private var targetX: Float;
    private var targetZ: Float;
    private var targetChosen: Bool;
    private var subscribed: Bool;

    public function new() {
    }

    public function init():Void {
        targetX = 0;
        targetZ = 0;
        targetChosen = false;

        currentPressedKeys = new Map<String, KeyEvent>();
    }

    public function dispose():Void {
    }

    private function onUpdate():Void {
        var currentLocation: WorldPoint = heroInteraction.getCurrentLocation();
        if(currentLocation == null) {
            return;
        }

        if(currentLocation.x + VARIATION >= targetX && currentLocation.x - VARIATION <= targetX &&
                currentLocation.z + VARIATION >= targetZ && currentLocation.z - VARIATION <= targetZ) {
            targetChosen = false;
        }
        if(!targetChosen) {
            targetChosen = true;

            var targetLocation: WorldPoint = objectCreator.createInstance(WorldPoint2D);

            targetLocation.x = currentLocation.x;
            targetLocation.z = currentLocation.z;

            if(currentPressedKeys.exists(NORTH_KEY)) {
                targetLocation.z -= MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(SOUTH_KEY)) {
                targetLocation.z += MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(WEST_KEY)) {
                targetLocation.x -= MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(EAST_KEY)) {
                targetLocation.x += MOVE_DISTANCE;
            }

            targetX = targetLocation.x;
            targetZ = targetLocation.z;

            heroInteraction.moveTo(targetLocation);
        }

        if(!keysPressed()) {
            subscribed = false;
            subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        }
    }

    public function onKeyDown(keyEvent:KeyEvent):Void {
        var key: String = keyEvent.key;
        currentPressedKeys.set(keyEvent.key, keyEvent);
        resetTargetChosen(key);

        if(!subscribed) {
            subscribed = true;
            subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        }
    }

    public function onKeyUp(keyEvent:KeyEvent):Void {
        var key: String = keyEvent.key;
        currentPressedKeys.remove(key);
        resetTargetChosen(key);
    }

    private inline function resetTargetChosen(key: String): Void {
        switch key {
            case SOUTH_KEY:
                targetChosen = false;
            case NORTH_KEY:
                targetChosen = false;
            case WEST_KEY:
                targetChosen = false;
            case EAST_KEY:
                targetChosen = false;
        }
    }

    private inline function keysPressed(): Bool {
        var retVal: Bool = false;
        for(k in currentPressedKeys) {
            retVal = true;
            break;
        }
        return retVal;
    }

    public function activate(args:Array<Dynamic>):Void {
    }

    public function deactivate():Void {
    }
}
