package input.tools;
class AssignedGameInputTools implements GameInputTools {
    @:isVar
    public var currentTool(get, set):PointingTool;

    @:isVar
    public var keyboardTool(get, set):KeyboardTool;

    public function get_currentTool():PointingTool {
        return currentTool;
    }

    public function set_currentTool(value:PointingTool) {
        if(currentTool != null) {
            currentTool.deactivate();
        }
        value.activate([]);
        return this.currentTool = value;
    }

    public function get_keyboardTool():KeyboardTool {
        return keyboardTool;
    }

    public function set_keyboardTool(value:KeyboardTool) {
        if(keyboardTool != null) {
            keyboardTool.deactivate();
        }
        value.activate([]);
        return this.keyboardTool = value;
    }

    public function new() {
    }

}
