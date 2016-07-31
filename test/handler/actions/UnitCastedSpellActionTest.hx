package handler.actions;

import handler.input.UnitCastedSpell;
import world.GameObject;
import world.two.WorldPoint2D;
import world.WorldPoint;
import vo.mutable.MutableSpellVO;
import mocks.MockGameWorld;
import gameentities.UnitInteractionManager;
import service.SpellService;
import core.ObjectCreator;
import world.GameWorld;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class UnitCastedSpellActionTest {

    private var unitCastedSpellAction: UnitCastedSpellAction;
    private var gameWorld: MockGameWorld;
    private var objectCreator: ObjectCreator;
    private var spellService: SpellService;
    private var interactionManager: UnitInteractionManager;
    private var spell: MutableSpellVO;
    private var gameObject: GameObject;
    private var unitCastedSpell: UnitCastedSpell;

    @Before
    public function setup():Void {
        gameObject = mock(GameObject);
        gameWorld = mock(MockGameWorld);
        objectCreator = mock(ObjectCreator);
        spellService = mock(SpellService);
        interactionManager = mock(UnitInteractionManager);

        objectCreator.createInstance(WorldPoint).returns(new WorldPoint2D());

        gameWorld.getGameObjectById("12").returns(gameObject);
        spell = new MutableSpellVO();
        spell.id = 1;

        unitCastedSpell = new UnitCastedSpell();

        unitCastedSpellAction = new UnitCastedSpellAction();
        unitCastedSpellAction.gameWorld = gameWorld;
        unitCastedSpellAction.objectCreator = objectCreator;
        unitCastedSpellAction.spellService = spellService;
        unitCastedSpellAction.interactionManager = interactionManager;
        unitCastedSpellAction.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldNotifyUnitInteractionManagerThatSpellWasCasted(): Void {
        unitCastedSpell.unitId = 12;
        unitCastedSpell.spellId = 1;
        unitCastedSpell.posX = 14;
        unitCastedSpell.posZ = 24;

        getSpell(1);

        unitCastedSpellAction.execute(unitCastedSpell);

        interactionManager.spellCasted(spell, gameObject, cast isNotNull, null).verify();
    }

    @IgnoreCover
    private function getSpell(id:Int): Void {
        spellService.getSpellById(id, cast isNotNull).calls(function(args): Void {
            args[1](spell);
        });
    }
}