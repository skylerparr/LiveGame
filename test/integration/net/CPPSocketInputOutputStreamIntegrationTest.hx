package integration.net;

import haxe.io.Bytes;
import error.ErrorManager;
import core.ObjectCreator;
import util.MappedSubscriber;
import io.InputOutputStream;
import net.CPPSocketInputOutputStream;
import net.CPPTCPSocket;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
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
    }

    @Test
    public function shouldWriteUnsignedByteToSocket(): Void {
        prependTestType("unsignedByte");
        stream.writeUnsignedByte(255);
        stream.writeUnsignedByte(256);
        stream.writeUnsignedByte(-50);
    }

    @Test
    public function shouldWriteIntegerToSocket(): Void {
        prependTestType("integer");
        stream.writeInt(0);
        stream.writeInt(39482);
        stream.writeInt(2147483647);
        stream.writeInt(-50);
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
#end
}