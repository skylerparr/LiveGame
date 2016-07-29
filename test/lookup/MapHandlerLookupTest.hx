package lookup;

import handler.input.UnitCastedSpell;
import handler.input.UnitCastingSpell;
import handler.input.HeroCreated;
import handler.IOCommands;
import handler.input.UnitMove;
import handler.input.UnitCreated;
import mocks.MockInputOutputStream;
import handler.input.PlayerConnected;
import handler.IOHandler;
import lookup.MapHandlerLookup;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class MapHandlerLookupTest {

    private var stream: MockInputOutputStream;
    private var lookup: MapHandlerLookup;

    @Before
    public function setup():Void {
        stream = mock(MockInputOutputStream);

        lookup = new MapHandlerLookup();
        lookup.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldLookupPlayerConnectedFromLookup(): Void {
        validateHandler(IOCommands.PLAYER_CONNECTED, PlayerConnected);
    }

    @Test
    public function shouldLookupUnitCreatedFromLookup(): Void {
        validateHandler(IOCommands.UNIT_CREATED, UnitCreated);
    }

    @Test
    public function shouldLookupUnitMoveFromLookup(): Void {
        validateHandler(IOCommands.UNIT_MOVE, UnitMove);
    }

    @Test
    public function shouldLookupHeroCreatedFromLookup(): Void {
        validateHandler(IOCommands.HERO_CREATED, HeroCreated);
    }

    @Test
    public function shouldLookupUnitCastingSpellFromLookup(): Void {
        validateHandler(IOCommands.UNIT_CASTING_SPELL, UnitCastingSpell);
    }

    @Test
    public function shouldLookupUnitCastedSpellFromLookup(): Void {
        validateHandler(IOCommands.UNIT_CASTED_SPELL, UnitCastedSpell);
    }

    @Test
    public function shouldReturnNullIfBytesAvailableIsZero(): Void {
        stream.readUnsignedByte().throws("EOF");
        var handler: IOHandler = lookup.getHandler(stream);

        Assert.isNull(handler);
    }

    @Test
    public function shouldDispose(): Void {
        lookup.dispose();

        Assert.isNull(lookup.map);
    }

    @IgnoreCover
    private function validateHandler(id:Int, handlerClass:Class<IOHandler>):Void {
        stream.bytesAvailable.returns(1);
        stream.readUnsignedByte().returns(id);
        var handler: IOHandler = lookup.getHandler(stream);

        Assert.areEqual(handlerClass, Type.getClass(handler));
    }
}