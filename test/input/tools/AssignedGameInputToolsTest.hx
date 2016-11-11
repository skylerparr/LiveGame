package input.tools;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class AssignedGameInputToolsTest {

    private var inputTools: AssignedGameInputTools;

    @Before
    public function setup():Void {
        inputTools = new AssignedGameInputTools();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function testExample():Void {
        Assert.isTrue(true);
    }
}