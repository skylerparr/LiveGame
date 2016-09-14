package gameentities;

import handler.output.MoveSquadTo;
import vo.mutable.MutableSpellVO;
import vo.SpellVO;
import handler.output.UnitCastSpell;
import mocks.MockViewPort;
import util.MappedSubscriber;
import world.ViewPort;
import handler.output.UnitMoveTo;
import handler.IOHandler;
import mocks.MockStreamHandler;
import handler.StreamHandler;
import mocks.MockGameObject;
import world.GameObject;
import world.two.WorldPoint2D;
import world.WorldPoint;
import core.ObjectCreator;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class SingleHeroInteractionTest {

    private var heroInteraction: SingleHeroInteraction;
    private var objectCreator: ObjectCreator;
    private var streamHandler: MockStreamHandler;
    private var hero: MockGameObject;
    private var viewPortTracker: ViewPortTracker;

    @Before
    public function setup():Void {
        hero = mock(MockGameObject);
        hero.id.returns("42");
        viewPortTracker = mock(ViewPortTracker);
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(WorldPoint).returns(new WorldPoint2D());
        objectCreator.createInstance(UnitMoveTo).returns(new UnitMoveTo());
        objectCreator.createInstance(UnitCastSpell).returns(new UnitCastSpell());
        objectCreator.createInstance(MoveSquadTo).returns(new MoveSquadTo());
        streamHandler = mock(MockStreamHandler);

        heroInteraction = new SingleHeroInteraction();
        heroInteraction.objectCreator = objectCreator;
        heroInteraction.streamHandler = streamHandler;
        heroInteraction.viewPortTracker = viewPortTracker;
        heroInteraction.init();

        heroInteraction.hero = hero;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetHeroCurrentLocation(): Void {
        hero.x.returns(231);
        hero.z.returns(429);
        Assert.areEqual(231, heroInteraction.getCurrentLocation().x);
        Assert.areEqual(429, heroInteraction.getCurrentLocation().z);
    }

    @Test
    public function shouldReturnNullIfHeroIsNotAssigned(): Void {
        heroInteraction.hero = null;
        Assert.isNull(heroInteraction.getCurrentLocation());
    }

    @Test
    public function shouldPassUnitMoveToStreamHandler(): Void {
        streamHandler.send(cast any).calls(function(args): Void {
            var move: UnitMoveTo = cast args[0];
            Assert.areEqual(42, move.unitId);
            Assert.areEqual(324, move.posX);
            Assert.areEqual(532, move.posZ);
        });
        heroInteraction.moveTo(new WorldPoint2D(324, 532));
        streamHandler.send(cast instanceOf(IOHandler)).verify();
    }

    @Test
    public function shouldNotPassUnitMoveToStreamHandlerIfBusy(): Void {
        hero.busy.returns(true);
        heroInteraction.moveTo(new WorldPoint2D(324, 532));
        streamHandler.send(cast instanceOf(IOHandler)).verify(0);
    }

    @Test
    public function shouldAssignHeroToViewPortTracker(): Void {
        viewPortTracker.trackToGameObject(hero).verify();
    }

    @Test
    public function shouldSendCastSpellOnTargetUnitToStreamHandler(): Void {
        streamHandler.send(cast any).calls(function(args): Void {
            var castSpell: UnitCastSpell = cast args[0];
            Assert.areEqual(42, castSpell.unitId);
            Assert.areEqual(100, castSpell.spellId);
            Assert.areEqual(140, castSpell.targetUnitId);
            Assert.areEqual(0, castSpell.targetPosX);
            Assert.areEqual(0, castSpell.targetPosZ);
        });

        var spell: MutableSpellVO = mock(MutableSpellVO);
        spell.id.returns(100);
        var target: MockGameObject = mock(MockGameObject);
        target.get_id().returns("140");
        heroInteraction.castSpell(target, null, spell);

        streamHandler.send(cast instanceOf(IOHandler)).verify();
    }

    @Test
    public function shouldSendCastSpellOnTargetLocationToStreamHandler(): Void {
        streamHandler.send(cast any).calls(function(args): Void {
            var castSpell: UnitCastSpell = cast args[0];
            Assert.areEqual(42, castSpell.unitId);
            Assert.areEqual(100, castSpell.spellId);
            Assert.areEqual(0, castSpell.targetUnitId);
            Assert.areEqual(324, castSpell.targetPosX);
            Assert.areEqual(532, castSpell.targetPosZ);
        });

        var spell: MutableSpellVO = mock(MutableSpellVO);
        spell.id.returns(100);
        heroInteraction.castSpell(null, new WorldPoint2D(324, 532), spell);

        streamHandler.send(cast instanceOf(IOHandler)).verify();
    }

    @Test
    public function shouldNotSendCastSpellIfHeroIsBusy(): Void {
        var spell: MutableSpellVO = mock(MutableSpellVO);
        spell.id.returns(100);
        hero.busy.returns(true);
        heroInteraction.castSpell(null, new WorldPoint2D(324, 532), spell);

        streamHandler.send(cast any).verify(0);
    }

    @Test
    public function shouldSendMoveSquad(): Void {
        var targetLocation: WorldPoint = new WorldPoint2D(4823, 394);
        streamHandler.send(cast any).calls(function(args): Void {
            var handler: MoveSquadTo = cast args[0];
            Assert.areEqual(5, handler.unitId);
            Assert.areEqual(4823, handler.posX);
            Assert.areEqual(394, handler.posZ);
        });

        var unit: MockGameObject = mock(MockGameObject);
        unit.id.returns(5);
        heroInteraction.moveSquad(unit, targetLocation);

        streamHandler.send(cast instanceOf(MoveSquadTo)).verify();
    }

    @Test
    public function shouldNotSendMoveSquadIfHeroIsBusy(): Void {
        var targetLocation: WorldPoint = new WorldPoint2D(4823, 394);
        var unit: MockGameObject = mock(MockGameObject);
        hero.busy.returns(true);
        heroInteraction.moveSquad(unit, targetLocation);
        streamHandler.send(cast any).verify(0);
    }

    @Test
    public function shouldAssignUnit(): Void {
        var unit: MockGameObject = mock(MockGameObject);
        heroInteraction.assignUnit(unit);

        Assert.areEqual(unit, heroInteraction.units.first());
    }

    @Test
    public function shouldNotAssignSameUnitMoreThanOnce(): Void {
        var unit: MockGameObject = mock(MockGameObject);
        heroInteraction.assignUnit(unit);
        heroInteraction.assignUnit(unit);
        heroInteraction.assignUnit(unit);
        heroInteraction.assignUnit(unit);

        Assert.areEqual(1, heroInteraction.units.length);
        Assert.areEqual(unit, heroInteraction.units.first());
    }

    @Test
    public function shouldNotAssignIfGameObjectIsHero(): Void {
        heroInteraction.assignUnit(hero);
        Assert.areEqual(0, heroInteraction.units.length);
    }

}