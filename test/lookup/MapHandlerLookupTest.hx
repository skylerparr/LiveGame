package lookup;

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
        stream.bytesAvailable.returns(1);
        stream.readUnsignedByte().returns(1);
        var handler: IOHandler = lookup.getHandler(stream);

        Assert.areEqual(PlayerConnected, Type.getClass(handler));
    }

    @Test
    public function shouldLookupUnitCreatedFromLookup(): Void {
        stream.bytesAvailable.returns(1);
        stream.readUnsignedByte().returns(2);
        var handler: IOHandler = lookup.getHandler(stream);

        Assert.areEqual(UnitCreated, Type.getClass(handler));
    }

    @Test
    public function shouldLookupUnitMoveFromLookup(): Void {
        stream.bytesAvailable.returns(1);
        stream.readUnsignedByte().returns(3);
        var handler: IOHandler = lookup.getHandler(stream);

        Assert.areEqual(UnitMove, Type.getClass(handler));
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
}