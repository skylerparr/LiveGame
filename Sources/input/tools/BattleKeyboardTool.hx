package input.tools;
import vo.mutable.MutableSpellVO;
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

    private static inline var NORTH_KEY: Int = 87;
    private static inline var SOUTH_KEY: Int = 83;
    private static inline var WEST_KEY: Int = 65;
    private static inline var EAST_KEY: Int = 68;

    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var heroInteraction: HeroInteraction;
    @inject
    public var subscriber: Subscriber;

    public var currentPressedKeys: Map<Int, KeyEvent>;

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
        currentPressedKeys = new Map<Int, KeyEvent>();
    }

    public function dispose():Void {
    }

    private function onUpdate():Void {
        handleUnitMove();

        spawnMinion(49, 2);
        spawnMinion(64, 3);

        if(!keysPressed()) {
            subscribed = false;
            subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        }
    }

    private inline function spawnMinion(key: Int, id: Int): Void {
        if(currentPressedKeys.exists(key)) {
            var spell: MutableSpellVO = new MutableSpellVO();
            spell.id = id;
            heroInteraction.castSpell(null, null, spell);
            currentPressedKeys.remove(key);
        }
    }

    public function onKeyDown(keyEvent:KeyEvent):Void {
        var key: Int = keyEvent.key;
        currentPressedKeys.set(key, keyEvent);
        targetChosen = true;
        if(moveKeyPressed()) {
            resetTargetChosen(key);
        }

        if(!subscribed) {
            subscribed = true;
            subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        }
    }

    public function onKeyUp(keyEvent:KeyEvent):Void {
        var key: Int = keyEvent.key;
        if(isMoveKey(key)) {
            resetTargetChosen(key);
        }
        currentPressedKeys.remove(key);
    }

    private inline function handleUnitMove(): Void {
        var currentLocation: WorldPoint = heroInteraction.getCurrentLocation();
        if(currentLocation == null) {
            return;
        }

        if(moveKeyPressed() && currentLocation.x + VARIATION >= targetX && currentLocation.x - VARIATION <= targetX &&
                currentLocation.z + VARIATION >= targetZ && currentLocation.z - VARIATION <= targetZ) {
            targetChosen = false;
        }
        if(!targetChosen) {
            targetChosen = true;

            var targetLocation: WorldPoint = objectCreator.createInstance(WorldPoint2D);

            targetLocation.x = currentLocation.x;
            targetLocation.z = currentLocation.z;

            if(currentPressedKeys.exists(WEST_KEY)) {
                targetLocation.x -= MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(EAST_KEY)) {
                targetLocation.x += MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(NORTH_KEY)) {
                targetLocation.z -= MOVE_DISTANCE;
            }
            if(currentPressedKeys.exists(SOUTH_KEY)) {
                targetLocation.z += MOVE_DISTANCE;
            }

            targetX = targetLocation.x;
            targetZ = targetLocation.z;

            heroInteraction.moveTo(targetLocation);
        }
    }

    private inline function moveKeyPressed(): Bool {
        return currentPressedKeys.exists(WEST_KEY) ||
            currentPressedKeys.exists(EAST_KEY) ||
            currentPressedKeys.exists(NORTH_KEY) ||
            currentPressedKeys.exists(SOUTH_KEY);
    }

    private inline function isMoveKey(key: Int): Bool {
        var retVal: Bool = false;
        switch key {
            case SOUTH_KEY:
                retVal = true;
            case NORTH_KEY:
                retVal = true;
            case WEST_KEY:
                retVal = true;
            case EAST_KEY:
                retVal = true;
        }
        return retVal;
    }

    private inline function resetTargetChosen(key: Int): Void {
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
