package handler.actions;
import world.WorldPoint;
import world.GameObject;
import vo.SpellVO;
import service.SpellService;
import core.ObjectCreator;
import gameentities.UnitInteractionManager;
import world.GameWorld;
import error.Logger;
import handler.input.UnitCastingSpell;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UnitCastingSpellAction implements StrategyAction {
    @inject
    public var logger: Logger;
    @inject
    public var gameWorld: GameWorld;
    @inject
    public var interactionManager: UnitInteractionManager;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var spellService: SpellService;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function execute(handler:IOHandler):Void {
        var unitCastingSpell: UnitCastingSpell = cast handler;
        castSpell(unitCastingSpell, spellCastComplete);
    }

    @:async
    private function castSpell(unitCastingSpell: UnitCastingSpell): Void {
        var spell: SpellVO = @await spellService.getSpellById(unitCastingSpell.spellId);
        var gameObject: GameObject = cast gameWorld.getGameObjectById(unitCastingSpell.unitId + "");
        if(gameObject == null) {
            return;
        }
        var worldPoint: WorldPoint = objectCreator.createInstance(WorldPoint);
        worldPoint.x = unitCastingSpell.posX;
        worldPoint.z = unitCastingSpell.posZ;

        interactionManager.startCastingSpell(spell, gameObject, worldPoint);
    }

    private function spellCastComplete():Void {

    }

}
