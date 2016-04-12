package mocks;

import input.GameInputTools;
import input.PointingTool;
import input.KeyboardTool;
class MockGameInputTools implements GameInputTools {

    public var currentTool(get, null):PointingTool;
    public var keyboardTool(get, null):KeyboardTool;

    public function get_currentTool():PointingTool {
        return currentTool;
    }

    public function get_keyboardTool():KeyboardTool {
        return keyboardTool;
    }

    public function new() {
    }
}