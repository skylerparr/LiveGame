package handler.actions;

import mocks.MockGameWorld;
import handler.input.UnitCastingSpell;
import world.two.WorldPoint2D;
import world.WorldPoint;
import mocks.MockGameObject;
import world.GameObject;
import vo.SpellVO;
import vo.mutable.MutableSpellVO;
import service.SpellService;
import handler.output.UnitCastSpell;
import core.ObjectCreator;
import world.GameWorld;
import gameentities.UnitInteractionManager;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class UnitCastingSpellActionTest {

    private var castingSpellAction: UnitCastingSpellAction;
    private var unitInteractionManager: UnitInteractionManager;
    private var gameWorld: MockGameWorld;
    private var objectCreator: ObjectCreator;
    private var spellService: SpellService;
    private var spell: MutableSpellVO;
    private var gameObject: MockGameObject;

    @Before
    public function setup():Void {
        unitInteractionManager = mock(UnitInteractionManager);
        gameWorld = mock(MockGameWorld);
        objectCreator = mock(ObjectCreator);
        spellService = mock(SpellService);
        gameObject = mock(MockGameObject);

        objectCreator.createInstance(WorldPoint).returns(new WorldPoint2D());

        gameWorld.getGameObjectById("12").returns(gameObject);
        spell = new MutableSpellVO();
        spell.id = 1;

        castingSpellAction = new UnitCastingSpellAction();
        castingSpellAction.objectCreator = objectCreator;
        castingSpellAction.gameWorld = gameWorld;
        castingSpellAction.interactionManager = unitInteractionManager;
        castingSpellAction.spellService = spellService;
        castingSpellAction.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldNotifyInteractionManagerSpellIsBeingCast(): Void {
        var castSpell: UnitCastingSpell = new UnitCastingSpell();
        castSpell.spellId = 1;
        castSpell.unitId = 12;
        castSpell.posX = 24;
        castSpell.posZ = 124;

        getSpell(1);

        castingSpellAction.execute(castSpell);

        unitInteractionManager.startCastingSpell(spell, gameObject, cast isNotNull).verify();
    }

    @Test
    public function shouldDispose(): Void {
        castingSpellAction.dispose();

        Assert.isNull(castingSpellAction.logger);
        Assert.isNull(castingSpellAction.gameWorld);
        Assert.isNull(castingSpellAction.interactionManager);
        Assert.isNull(castingSpellAction.objectCreator);
        Assert.isNull(castingSpellAction.spellService);
    }

    @IgnoreCover
    private function getSpell(id:Int): Void {
        spellService.getSpellById(id, cast isNotNull).calls(function(args): Void {
            args[1](spell);
        });
    }
}