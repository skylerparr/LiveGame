package net;

import haxe.io.Bytes;
import haxe.io.Output;
import io.InputOutputStream;
import error.ErrorManager;
import util.MappedSubscriber;
import core.ObjectCreator;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class CPPSocketInputOutputStreamTest {

    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;
    private var socket: TCPSocket;
    private var output: Output;
    private var socketStream: CPPSocketInputOutputStream;
    private var errorManager: ErrorManager;

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        socket = mock(TCPSocket);
        output = mock(Output);
        socket.output.returns(output);
        errorManager = mock(ErrorManager);

        socketStream = new CPPSocketInputOutputStream();
        socketStream.objectCreator = objectCreator;
        socketStream.socket = socket;
        socketStream.errorManager = errorManager;
        socketStream.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSubscribeToSocketConnected(): Void {
        var cbCalled: Bool = false;
        socketStream.subscribeToConnected(function(stream: InputOutputStream): Void {
            cbCalled = true;
            Assert.areEqual(socketStream, stream);
        });

        connectToSocket();

        Assert.isTrue(cbCalled);
        Assert.isTrue(socketStream.connected);
        socket.connect(cast any, 1337).verify();
    }

    @Test
    public function shouldCloseFromSocket(): Void {
        connectToSocket();
        socketStream.close();

        socket.close().verify();
    }

    @Test
    public function shouldNotCloseSocketThatIsNotConnected(): Void {
        socketStream.close();
        socket.close().verify(0);
    }

    @Test
    public function shouldNotCallConnectedCallbackIfConnectFails(): Void {
        var cbCalled: Bool = false;
        socketStream.subscribeToConnected(function(stream: InputOutputStream): Void {
            cbCalled = true;
        });
        socket.connect(cast any, 1337).throws(new Error("foo"));

        connectToSocket();
        Assert.isFalse(cbCalled);
        errorManager.logError(cast any).verify();
    }

    @Test
    public function shouldNotWriteBooleanToSocketThatIsNotConnected(): Void {
        socketStream.writeBoolean(true);
        output.write(cast any).verify(0);
    }

    @Test
    public function shouldWriteBooleanTrueToSocket(): Void {
        connectToSocket();
        output.write(cast any).calls(function(args: Array<Dynamic>): Void {
            Assert.areEqual(1, args[0].get(0));
        });
        socketStream.writeBoolean(true);
        output.write(cast any).verify();
    }

    @Test
    public function shouldWriteBooleanFalseToSocket(): Void {
        connectToSocket();
        output.write(cast any).calls(function(args): Void {
            Assert.areEqual(0, args[0].get(0));
        });
        socketStream.writeBoolean(false);
        output.write(cast any).verify();
    }

    @Test
    public function shouldWriteSignedIntToConnectedSocket(): Void {
        connectToSocket();
        socketStream.writeInt(8392);
        output.writeInt32(8392).verify();
    }

    @Test
    public function shouldWriteByteToConnectedSocket(): Void {
        connectToSocket();
        output.write(cast any).calls(function(args): Void {
            Assert.areEqual(127, args[0].get(0));
        });
        socketStream.writeUnsignedByte(127);
        output.write(cast any).verify();
    }

    @Test
    public function shouldHandleByteOverflow(): Void {
        connectToSocket();
        output.write(cast any).calls(function(args): Void {
            Assert.areEqual(99, args[0].get(0));
        });
        socketStream.writeUnsignedByte(355);
        output.write(cast any).verify();
    }

    @Test
    public function shouldWriteShortToConnectedSocket(): Void {
        connectToSocket();
        socketStream.writeUnsignedShort(1024);
        output.writeUInt16(1024).verify();
    }

    @Test
    public function shouldWriteFloatToConnectedSocket(): Void {
        connectToSocket();
        socketStream.writeFloat(843.935);
        output.writeDouble(843.935).verify();
    }
    
    @Test
    public function shouldWriteDOubleToConnectedSocket(): Void {
        connectToSocket();
        socketStream.writeDouble(878645432.546968456);
        output.writeDouble(878645432.546968456).verify();
    }

    @Test
    public function shouldWriteUTFBytesToConnectedSocket(): Void {
        connectToSocket();
        socketStream.writeUTFBytes("foo bar baz cat");
        output.writeString("foo bar baz cat").verify();
    }

    @IgnoreCover
    private function connectToSocket():Void {
        socketStream.connect("localhost", 1337);
    }

}

class Error {

    public var msg: String;

    public function new(string: String) {
        msg = string;
    }
}