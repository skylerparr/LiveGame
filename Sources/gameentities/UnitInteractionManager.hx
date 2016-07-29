package gameentities;
import vo.SpellVO;
import vo.SpellVO;
import animation.tween.TweenTarget;
import world.GameObject;
import world.WorldPoint;
import core.BaseObject;
interface UnitInteractionManager extends BaseObject {
    /**
     * The entity will move to location over specified period of time
     */
    function translateGameObjectTo(entity: GameObject, worldPoint: WorldPoint, time: UInt): Void;

    function startCastingSpell(spell: SpellVO, gameObject: GameObject, worldPoint: WorldPoint): Void;

    function spellCasted(spell: SpellVO, gameObject: GameObject, worldPoint: WorldPoint, targetGameObject: GameObject): Void;
}
