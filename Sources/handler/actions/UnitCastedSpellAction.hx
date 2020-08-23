package handler.actions;
import world.GameObject;
import vo.SpellVO;
import world.WorldPoint;
import handler.input.UnitCastedSpell;
import service.SpellService;
import core.ObjectCreator;
import gameentities.UnitInteractionManager;
import world.GameWorldDisplay;
import error.Logger;
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UnitCastedSpellAction implements StrategyAction {
    @inject
    public var logger: Logger;
    @inject
    public var gameWorld: GameWorldDisplay;
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
        logger = null;
        gameWorld = null;
        interactionManager = null;
        objectCreator = null;
        spellService = null;
    }

    public function execute(handler:IOHandler):Void {
        var unitCastedSpell: UnitCastedSpell = cast handler;
        castSpell(unitCastedSpell, spellCastComplete);
    }

    @:async
    private function castSpell(unitCastedSpell: UnitCastedSpell): Void {
        var spell: SpellVO = @await spellService.getSpellById(unitCastedSpell.spellId);
        var gameObject: GameObject = cast gameWorld.getGameObjectById(unitCastedSpell.unitId + "");
        if(gameObject == null) {
            interactionManager.spellCasted(null, null, null, null);
            return;
        }
        var worldPoint: WorldPoint = objectCreator.createInstance(WorldPoint);
        worldPoint.x = unitCastedSpell.posX;
        worldPoint.z = unitCastedSpell.posZ;

        interactionManager.spellCasted(spell, gameObject, worldPoint, null);
    }

    private function spellCastComplete():Void {

    }

}