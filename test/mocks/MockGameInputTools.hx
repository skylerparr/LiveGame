package mocks;

import input.GameInputTools;
import input.PointingTool;
import input.KeyboardTool;
class MockGameInputTools implements GameInputTools {

    @:isVar
    public var currentTool(get, set):PointingTool;
    @:isVar
    public var keyboardTool(get, set):KeyboardTool;

    public function get_currentTool():PointingTool {
        return currentTool;
    }

    public function get_keyboardTool():KeyboardTool {
        return keyboardTool;
    }

    public function set_currentTool(value:PointingTool) {
        return this.currentTool = value;
    }

    public function set_keyboardTool(value:KeyboardTool) {
        return this.keyboardTool = value;
    }

    public function new() {
    }
}