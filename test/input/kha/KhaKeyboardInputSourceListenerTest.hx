package input.kha;

import mocks.MockGameInputTools;
import core.ObjectCreator;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class KhaKeyboardInputSourceListenerTest {

    private var keyboard: KhaKeyboardInputSourceListener;
    private var objectCreator: ObjectCreator;
    private var gameInputTools: MockGameInputTools;
    private var currentKeyboardTool: KeyboardTool;
    private var keyEvent: KeyEvent;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        gameInputTools = mock(MockGameInputTools);
        currentKeyboardTool = mock(KeyboardTool);

        keyEvent = new KeyEvent();

        objectCreator.createInstance(KeyEvent).returns(keyEvent);

        keyboard = new KhaKeyboardInputSourceListener();
        keyboard.objectCreator = objectCreator;
        keyboard.gameInputTools = gameInputTools;
        keyboard.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldCaptureKeyDownAndPassToTool(): Void {
        gameInputTools.keyboardTool.returns(currentKeyboardTool);

        keyboard.onKeyDown(MockKeyboardKey.A);

        currentKeyboardTool.onKeyDown(keyEvent).verify();
        Assert.areEqual(65, keyEvent.key);
    }

    @Test
    public function shouldCaptureKeyUpAndPassToTool(): Void {
        gameInputTools.keyboardTool.returns(currentKeyboardTool);

        keyboard.onKeyUp(MockKeyboardKey.A);

        currentKeyboardTool.onKeyUp(keyEvent).verify();
        Assert.areEqual(65, keyEvent.key);
    }

    @Test
    public function shouldDispose(): Void {
        keyboard.dispose();

        objectCreator.disposeInstance(keyEvent).verify();
        Assert.isNull(keyboard.objectCreator);
        Assert.isNull(keyboard.gameInputTools);
    }
}