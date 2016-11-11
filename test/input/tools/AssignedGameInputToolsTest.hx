package input.tools;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class AssignedGameInputToolsTest {

    private var inputTools: AssignedGameInputTools;
    private var pointingTool: PointingTool;
    private var keyboardTool: KeyboardTool;

    @Before
    public function setup():Void {
        pointingTool = mock(PointingTool);
        keyboardTool = mock(KeyboardTool);

        inputTools = new AssignedGameInputTools();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAssignPointingTool(): Void {
        inputTools.currentTool = pointingTool;
        Assert.areEqual(pointingTool, inputTools.currentTool);
    }

    @Test
    public function shouldAssignKeyboardTool(): Void {
        inputTools.keyboardTool = keyboardTool;
        Assert.areEqual(keyboardTool, inputTools.keyboardTool);
    }

    @Test
    public function shouldDeactivateOldToolAndActivateNewTool(): Void {
        inputTools.currentTool = pointingTool;
        pointingTool.deactivate().verify(0);
        pointingTool.activate(cast isNotNull).verify();
        Mockatoo.reset(pointingTool);

        var newTool: PointingTool = mock(PointingTool);
        inputTools.currentTool = newTool;

        pointingTool.deactivate().verify();
        newTool.activate(cast isNotNull).verify();
    }

    @Test
    public function shouldDeactivateOldKeyboardToolAndActivateNewKeyboardTool(): Void {
        inputTools.keyboardTool = keyboardTool;
        keyboardTool.deactivate().verify(0);
        keyboardTool.activate(cast isNotNull).verify();
        Mockatoo.reset(keyboardTool);

        var newTool: KeyboardTool = mock(KeyboardTool);
        inputTools.keyboardTool = newTool;

        keyboardTool.deactivate().verify();
        newTool.activate(cast isNotNull).verify();
    }
}