package vo.mutable;
class MutablePlayerVO implements PlayerVO {

    @:isVar
    public var id(get, set):Int;

    @:isVar
    public var name(get, set):String;

    @:isVar
    public var units(get, set):Map<Int, UnitVO>;

    public function new() {
        units = new Map<Int, UnitVO>();
    }

    public function set_id(value:Int) {
        return this.id = value;
    }

    public function get_id():Int {
        return id;
    }

    public function set_name(value:String) {
        return this.name = value;
    }

    public function get_name():String {
        return name;
    }

    public function get_units():Map<Int, UnitVO> {
        return units;
    }

    public function set_units(value:Map<Int, UnitVO>) {
        return this.units = value;
    }
}
