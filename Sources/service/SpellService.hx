package service;
import vo.SpellVO;
import core.BaseObject;
interface SpellService extends BaseObject {
    function getSpellById(id: Int, onComplete: SpellVO -> Void): Void;
}
