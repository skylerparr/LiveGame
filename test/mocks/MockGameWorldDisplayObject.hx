package mocks;

import display.DisplayNode;
import world.WorldEntityDisplay;
class MockGameWorldDisplayObject extends MockGameObject implements WorldEntityDisplay {

    @:isVar
    public var display(get, set):DisplayNode;

    public function set_display(value:DisplayNode): DisplayNode {
        return this.display = value;
    }

    public function get_display():DisplayNode {
        return display;
    }

}