package service;
import vo.MutableSpellVO;
import vo.MutableSpellVO;
import vo.SpellVO;
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
