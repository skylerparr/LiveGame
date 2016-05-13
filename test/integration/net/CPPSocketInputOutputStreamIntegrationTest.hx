package integration.net;

import haxe.io.Bytes;
import error.ErrorManager;
import core.ObjectCreator;
import util.MappedSubscriber;
import io.InputOutputStream;
import net.CPPSocketInputOutputStream;
import net.CPPTCPSocket;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class CPPSocketInputOutputStreamIntegrationTest {
#if integration

    private var socket: CPPTCPSocket;
    private var stream: CPPSocketInputOutputStream;

    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;
    private var errorManager: ErrorManager;


    @BeforeClass
    public function setupClass():Void {
        socket = new CPPTCPSocket();
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        errorManager = mock(ErrorManager);

        stream = new CPPSocketInputOutputStream();
        stream.socket = socket;
        stream.objectCreator = objectCreator;
        stream.errorManager = errorManager;
        stream.init();
        stream.subscribeToConnected(socketConnected);
        stream.connect("localhost", 1337);
    }

    @AfterClass
    public function tearDownClass():Void {
        stream.close();
    }

    @Test
    public function shouldSendBoolean(): Void {
        prependTestType("boolean");
        stream.writeBoolean(false);
        stream.writeBoolean(true);

        assertReceive();
    }

    @Test
    public function shouldWriteUnsignedByteToSocket(): Void {
        prependTestType("unsignedByte");
        stream.writeUnsignedByte(255);
        stream.writeUnsignedByte(256);
        stream.writeUnsignedByte(-50);

        assertReceive();
    }

    @Test
    public function shouldWriteIntegerToSocket(): Void {
        prependTestType("integer");
        stream.writeInt(0);
        stream.writeInt(39482);
        stream.writeInt(2147483647);
        stream.writeInt(-50);

        assertReceive();
    }

    @Test
    public function shouldWriteFloatToSocket(): Void {
        prependTestType("float");
        stream.writeFloat(0.0);
        stream.writeFloat(0.432);
        stream.writeFloat(124.432);
        stream.writeFloat(-34534.3245);

        assertReceive();
    }

    @Test
    public function shouldWriteDoubleToSocket(): Void {
        prependTestType("double");
        stream.writeDouble(0.0);
        stream.writeDouble(0.432);
        stream.writeDouble(13453453424.432);
        stream.writeDouble(-345334544.3245);

        assertReceive();
    }

    @Test
    public function shouldWriteUnsignedShortToSocket(): Void {
        prependTestType("unsignedShort");
        stream.writeUnsignedShort(438);
        stream.writeUnsignedShort(0);

        assertReceive();
    }

    @Test
    public function shouldReadBoolFromSocket(): Void {
        prependTestType("readBoolean");
        while(stream.bytesAvailable != 3) {
            stream.update();
        }
        Assert.areEqual(3, stream.bytesAvailable);
        Assert.isFalse(stream.readBoolean());
        Assert.isTrue(stream.readBoolean());
        Assert.isTrue(stream.readBoolean());

        stream.writeBoolean(true);
    }

    @Test
    public function shouldReadByteFromSocket(): Void {
        prependTestType("readByte");
//        while(stream.bytesAvailable != 3) {
//            stream.update();
//        }
//        Assert.areEqual(3, stream.bytesAvailable);
//        Assert.areEqual(15, stream.readByte());
//        Assert.areEqual(-54, stream.readByte());
//        Assert.areEqual(0, stream.readByte());

        stream.writeBoolean(true);
    }

    @IgnoreCover
    public function socketConnected(stream: InputOutputStream): Void {
        Assert.isTrue(cast(stream, CPPSocketInputOutputStream).connected);
    }

    @IgnoreCover
    public function prependTestType(testName: String): Void {
        socket.socket.output.writeInt32(testName.length);
        socket.socket.write(testName);
    }

    @IgnoreCover
    public function assertReceive(): Void {
        while(stream.bytesAvailable == 0) {
            stream.update();
        }
        Assert.isTrue(stream.readBoolean());
    }
#end
}