package service;
import vo.mutable.MutableSpellVO;
import vo.SpellVO;
@IgnoreCover
class StaticSpellService implements SpellService {
    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function getSpellById(id:Int, onComplete:SpellVO->Void):Void {
        var spell: MutableSpellVO = new MutableSpellVO();
        spell.id = id;
        onComplete(spell);
    }
}
