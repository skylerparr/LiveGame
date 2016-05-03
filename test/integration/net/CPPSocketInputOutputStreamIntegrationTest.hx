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
        var bytes = Bytes.alloc(4);
        bytes.set(0, 11);
        socket.socket.output.write(bytes);
//        socket.socket.write("sendBoolean");
        stream.writeBoolean(false);
        stream.writeBoolean(true);
    }

    @Test
    public function shouldWriteUnsignedByteToSocket(): Void {
    }

    @IgnoreCover
    public function socketConnected(stream: InputOutputStream): Void {
        Assert.isTrue(cast(stream, CPPSocketInputOutputStream).connected);
    }
#end
}