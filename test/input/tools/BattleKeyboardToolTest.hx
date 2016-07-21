package input.tools;

import mocks.MockHeroInteraction;
import world.WorldPoint;
import world.two.WorldPoint2D;
import gameentities.HeroInteraction;
import constants.EventNames;
import core.ObjectCreator;
import util.MappedSubscriber;
import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class BattleKeyboardToolTest {

    private var keyboardTool: BattleKeyboardTool;
    private var subscriber: MappedSubscriber;
    private var objectCreator: ObjectCreator;
    private var heroInteraction: MockHeroInteraction;
    private var moveDistance: Float;

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator = mock(ObjectCreator);
        heroInteraction = mock(MockHeroInteraction);

        objectCreator.createInstance(WorldPoint2D).returns(new WorldPoint2D());

        moveDistance = BattleKeyboardTool.MOVE_DISTANCE;

        keyboardTool = new BattleKeyboardTool();
        keyboardTool.objectCreator = objectCreator;
        keyboardTool.heroInteraction = heroInteraction;
        keyboardTool.subscriber = subscriber;
        keyboardTool.init();
        keyboardTool.activate([]);
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldStoreKeyEventsOnKeyDown(): Void {
        var keyEvent = sendKeyDownEvent("w");
        Assert.areEqual(keyEvent, keyboardTool.currentPressedKeys.get("w"));

        var keyEvent2 = sendKeyDownEvent("d");
        Assert.areEqual(keyEvent2, keyboardTool.currentPressedKeys.get("d"));
    }

    @Test
    public function shouldRemoveKeyOnKeyUp(): Void {
        sendKeyDownEvent("w");
        sendKeyUpEvent("w");
        Assert.isNull(keyboardTool.currentPressedKeys.get("w"));

        sendKeyDownEvent("d");
        sendKeyUpEvent("d");
        Assert.isNull(keyboardTool.currentPressedKeys.get("d"));
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToSouthLocationOnUpdate(): Void {
        sendKeyDownEvent("s");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(100, 100 + moveDistance));
        mockHeroLocation(100, 100);
        runGameLoop(1);

        heroInteraction.moveTo(cast isNotNull).verify();
    }

    @Test
    public function shouldNotCrashIfHeroIsNotAssigned(): Void {
        sendKeyDownEvent("s");

        heroInteraction.getCurrentLocation().returns(null);
        mockHeroLocation(100, 100);
        runGameLoop(1);

        heroInteraction.moveTo(cast any).verify(0);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToCurrentLocationIfSouthKeyIsDepressed(): Void {
        sendKeyDownEvent("s");

        mockHeroLocation(100, 100);
        mockHeroLocation(100, 120);
        mockHeroLocation(100, 140);
        runGameLoop(3);

        sendKeyUpEvent("s");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(100, 140));
        subscriber.notify(EventNames.ENTER_GAME_LOOP, null);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToCurrentLocationIfNorthKeyIsDepressed(): Void {
        sendKeyDownEvent("w");

        mockHeroLocation(100, 200);
        mockHeroLocation(100, 180);
        mockHeroLocation(100, 160);
        runGameLoop(3);

        sendKeyUpEvent("w");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(100, 160));
        subscriber.notify(EventNames.ENTER_GAME_LOOP, null);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToNorthLocationOnUpdate(): Void {
        sendKeyDownEvent("w");

        mockHeroLocation(100, 200);
        mockHeroLocation(100, 190);
        mockHeroLocation(100, 130);
        mockHeroLocation(100, 202 - moveDistance);
        runGameLoop(4);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotNotifyHeroInteractionToMoveHeroIfHeroIsNotAtTargetLocation(): Void {
        sendKeyDownEvent("s");

        mockHeroLocation(100, 100);
        mockHeroLocation(100, 130);
        mockHeroLocation(100, 160);
        mockHeroLocation(100, 190);
        runGameLoop(4);

        heroInteraction.moveTo(cast isNotNull).verify(1);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveIfHeroIsAtTargetLocation(): Void {
        sendKeyDownEvent("s");

        mockHeroLocation(100, 100);
        mockHeroLocation(100, 130);
        mockHeroLocation(100, 160);
        mockHeroLocation(100, 190);
        mockHeroLocation(100, 99 + moveDistance);
        mockHeroLocation(100, 102 + (moveDistance * 2));
        mockHeroLocation(100, 130 + (moveDistance * 2));
        runGameLoop(7);

        heroInteraction.moveTo(cast isNotNull).verify(3);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToWestLocationOnUpdate(): Void {
        sendKeyDownEvent("a");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(200 - moveDistance, 100));
        mockHeroLocation(200, 100);
        runGameLoop(1);

        heroInteraction.moveTo(cast isNotNull).verify();
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToCurrentLocationIfWestKeyIsDepressed(): Void {
        sendKeyDownEvent("a");

        mockHeroLocation(200, 100);
        mockHeroLocation(180, 100);
        mockHeroLocation(160, 100);
        runGameLoop(3);
        sendKeyUpEvent("a");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(160, 100));
        subscriber.notify(EventNames.ENTER_GAME_LOOP, null);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveWestIfHeroIsAtTargetLocation(): Void {
        sendKeyDownEvent("a");

        mockHeroLocation(200, 100);
        mockHeroLocation(190, 100);
        mockHeroLocation(160, 100);
        mockHeroLocation(130, 100);
        mockHeroLocation(201 - moveDistance, 100);
        mockHeroLocation(199 - moveDistance, 100);
        mockHeroLocation(160 - moveDistance, 100);
        runGameLoop(7);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToEastLocationOnUpdate(): Void {
        sendKeyDownEvent("d");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(100 + moveDistance, 100));
        mockHeroLocation(100, 100);
        runGameLoop(1);

        heroInteraction.moveTo(cast isNotNull).verify();
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveHeroToCurrentLocationIfEastKeyIsDepressed(): Void {
        sendKeyDownEvent("d");

        mockHeroLocation(100, 100);
        mockHeroLocation(220, 100);
        mockHeroLocation(240, 100);
        runGameLoop(3);
        sendKeyUpEvent("d");

        heroInteraction.moveTo(cast isNotNull).calls(moveToValidation(240, 100));
        subscriber.notify(EventNames.ENTER_GAME_LOOP, null);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionToMoveEastIfHeroIsAtTargetLocation(): Void {
        sendKeyDownEvent("d");

        mockHeroLocation(100, 100);
        mockHeroLocation(130, 100);
        mockHeroLocation(160, 100);
        mockHeroLocation(190, 100);
        mockHeroLocation(199 + moveDistance, 100);
        mockHeroLocation(101 + moveDistance, 100);
        mockHeroLocation(120 + moveDistance, 100);
        runGameLoop(7);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @Test
    public function shouldNotNotifyHeroInteractionIfNoKeysPressed(): Void {
        mockHeroLocation(100, 100);
        runGameLoop(7);
        heroInteraction.moveTo(cast any).verify(0);
    }

    @Test
    public function shouldNotifyHeroInteractionIfKeysPressedThenStopIfNoKeysPressed(): Void {
        sendKeyDownEvent("d");
        mockHeroLocation(100, 100);
        runGameLoop(1);
        sendKeyUpEvent("d");
        mockHeroLocation(100, 100);
        runGameLoop(7);
        heroInteraction.moveTo(cast any).verify(2);
    }

    @Test
    public function shouldNotifyHeroInteractionIfKeyIsPressed(): Void {
        sendKeyDownEvent("d");
        mockHeroLocation(100, 100);
        runGameLoop(1);
        sendKeyDownEvent("w");
        mockHeroLocation(90, 100);
        runGameLoop(1);

        heroInteraction.moveTo(cast isNotNull).verify(2);
    }

    @IgnoreCover
    private inline function mockHeroLocation(x:Float, z:Float):Void {
        var worldPoint: WorldPoint2D = new WorldPoint2D(x, z);
        heroInteraction.getCurrentLocation().returns(worldPoint);
    }

    @IgnoreCover
    private function moveToValidation(expectedX: Float, expectedZ: Float):Dynamic->Void {
        return function(args) {
            var wp: WorldPoint = args[0];
            Assert.areEqual(expectedX, wp.x);
            Assert.areEqual(expectedZ, wp.z);
        }
    }

    @IgnoreCover
    private function sendKeyDownEvent(key:String):KeyEvent {
        var keyEvent: KeyEvent = new KeyEvent();
        keyEvent.key = key;
        keyboardTool.onKeyDown(keyEvent);
        return keyEvent;
    }

    @IgnoreCover
    private function sendKeyUpEvent(key:String):KeyEvent {
        var keyEvent: KeyEvent = new KeyEvent();
        keyEvent.key = key;
        keyboardTool.onKeyUp(keyEvent);
        return keyEvent;
    }

    @IgnoreCover
    private function runGameLoop(numTimes:Int):Void {
        for(i in 0...numTimes) {
            subscriber.notify(EventNames.ENTER_GAME_LOOP, null);
        }
    }
}