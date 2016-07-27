package vo;
class MutableSpellVO implements SpellVO {

    @:isVar
    public var id(get, set):Int;

    public function set_id(value:Int): Int {
        return this.id = value;
    }

    public function get_id():Int {
        return id;
    }

    public function new() {
    }
}
