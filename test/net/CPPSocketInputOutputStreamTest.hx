package net;
#if cpp
import haxe.io.Input;
import haxe.io.Bytes;
import haxe.io.Output;
import io.InputOutputStream;
import error.Logger;
import util.MappedSubscriber;
import core.ObjectCreator;
#end
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class CPPSocketInputOutputStreamTest {
#if cpp
    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;
    private var socket: TCPSocket;
    private var output: Output;
    private var input: Input;
    private var socketStream: CPPSocketInputOutputStream;
    private var errorManager: Logger;
    private var cbCount: Int;

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        socket = mock(TCPSocket);
        output = mock(Output);
        input = mock(Input);
        socket.output.returns(output);
        socket.input.returns(input);
        errorManager = mock(Logger);

        socketStream = new TestableCPPSocketInputOutputStream();
        socketStream.objectCreator = objectCreator;
        socketStream.socket = socket;
        socketStream.errorManager = errorManager;
        socketStream.init();
    }

    @After
    public function tearDown():Void {
        cbCount = 0;
    }

    @Test
    public function shouldSubscribeFromSocketConnected(): Void {
        socketStream.subscribeToConnected(subscriptionCallback);

        connectToSocket();

        Assert.areEqual(1, cbCount);
        Assert.isTrue(socketStream.connected);
        socket.connect(cast any, 1337).verify();
    }

    @Test
    public function shouldUnsubscribeToSocketConnected(): Void {
        socketStream.subscribeToConnected(subscriptionCallback);

        connectToSocket();

        socket.connect(cast any, 1337).verify();

        socketStream.unsubscribeToConnected(subscriptionCallback);
        connectToSocket();

        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldSubscribeToSocketClosed(): Void {
        socketStream.subscribeToClosed(subscriptionCallback);

        connectToSocket();

        socket.connect(cast any, 1337).verify();

        socketStream.close();

        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldUnsubscribeFromSocketClosed(): Void {
        socketStream.subscribeToClosed(subscriptionCallback);

        connectToSocket();
        socketStream.close();

        socketStream.unsubscribeToClosed(subscriptionCallback);
        connectToSocket();
        socketStream.close();
        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldCloseFromSocket(): Void {
        connectToSocket();
        socketStream.close();

        socket.close().verify();
        Assert.isFalse(socketStream.connected);
    }

    @Test
    public function shouldClearBufferOnClose(): Void {
        connectToSocket();
        mockSampleData();
        Assert.areEqual(3, socketStream.bytesAvailable);

        socketStream.close();
        Assert.areEqual(0, socketStream.bytesAvailable);
    }

    @Test
    public function shouldSubscribeToDataReceived(): Void {
        socketStream.subscribeToDataReceived(subscriptionCallback);
        connectToSocket();
        mockSampleData();
        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldUnsubscribeFromDataReceived(): Void {
        socketStream.subscribeToDataReceived(subscriptionCallback);
        connectToSocket();
        mockSampleData();
        Assert.areEqual(1, cbCount);

        input.reset();
        socketStream.unsubscribeDataReceived(subscriptionCallback);
        mockSampleData();
        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldNotCloseSocketThatIsNotConnected(): Void {
        socketStream.close();
        socket.close().verify(0);
    }

    @Test
    public function shouldNotCallConnectedCallbackIfConnectFails(): Void {
        socketStream.subscribeToConnected(subscriptionCallback);
        socket.connect(cast any, 1337).throws(new Error("foo"));

        connectToSocket();
        Assert.areEqual(0, cbCount);
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

    @Test
    public function shouldReadBooleanFromConnectedSocket(): Void {
        connectToSocket();
        mockSampleData();
        Assert.areEqual(3, socketStream.bytesAvailable);
        Assert.isTrue(socketStream.readBoolean());
        Assert.isFalse(socketStream.readBoolean());

        input.reset();
        var bytes = Bytes.alloc(2);
        var i: Int = 0;
        bytes.set(i++, 0);
        bytes.set(i++, 1);
        mockBytes(bytes);
        socketStream.update();

        Assert.areEqual(3, socketStream.bytesAvailable);
        Assert.isTrue(socketStream.readBoolean());
        Assert.isFalse(socketStream.readBoolean());
        Assert.isTrue(socketStream.readBoolean());
    }

    @Test
    public function shouldNotReadDataFromSocketThatIsNotConnected(): Void {
        try {
            socketStream.readBoolean();
            Assert.fail("socket must be connected");
        } catch(e: Dynamic) {
            Assert.isTrue(true);
        }
    }

    @Test
    public function shouldUnsignedReadByteFromConnectedSocket(): Void {
        connectToSocket();
        var bytes = Bytes.alloc(1);
        var i: Int = 0;
        bytes.set(i++, 32);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(1, socketStream.bytesAvailable);
        Assert.areEqual(32, socketStream.readUnsignedByte());
    }

    @Test
    public function shouldReadDoubleFromConnectedSocket(): Void {
        connectToSocket();
        var bytes = Bytes.alloc(8);
        var i: Int = 0;
        bytes.setDouble(i++, 302984023958.02394832);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(8, socketStream.bytesAvailable);
        Assert.areEqual(302984023958.02394832, socketStream.readDouble());
    }

    @Test
    public function shouldReadFloatFromConnectedSocket(): Void {
        connectToSocket();
        var bytes = Bytes.alloc(4);
        var i: Int = 0;
        bytes.setFloat(i++, -329.239);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(4, socketStream.bytesAvailable);
        Assert.areEqual(-329.239, Std.int(socketStream.readFloat() * 1000) / 1000);
    }

    @Test
    public function shouldReadIntFromConnectedSocket(): Void {
        connectToSocket();
        var bytes = Bytes.alloc(4);
        var i: Int = 0;
        bytes.setInt32(i++, 342);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(4, socketStream.bytesAvailable);
        Assert.areEqual(342, socketStream.readInt());
    }

    @Test
    public function shouldReadUnsignedShortFromConnectedSocket(): Void {
        connectToSocket();
        var bytes = Bytes.alloc(2);
        var i: Int = 0;
        bytes.setUInt16(i++, 128);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(2, socketStream.bytesAvailable);
        Assert.areEqual(128, socketStream.readUnsignedShort());
    }

    @Test
    public function shouldReadUTFBytesFromConnectedSocket(): Void {
        var string: String = "hello foo bar";
        connectToSocket();
        var bytes = Bytes.ofString(string);
        mockBytes(bytes);

        socketStream.update();
        Assert.areEqual(string.length, socketStream.bytesAvailable);
        Assert.areEqual(string, socketStream.readUTFBytes(socketStream.bytesAvailable));
    }

    @Test
    public function shouldDisposeSocketStream(): Void {
        connectToSocket();
        socketStream.subscribeToConnected(subscriptionCallback);
        socketStream.subscribeToClosed(subscriptionCallback);
        socketStream.subscribeToDataReceived(subscriptionCallback);
        mockSampleData();

        socketStream.dispose();

        objectCreator.disposeInstance(subscriber);
        Assert.isNull(socketStream.subscriber);
        Assert.isNull(socketStream.input);
        Assert.isNull(socketStream.output);
        Assert.isNull(socketStream.buffer);
        Assert.isNull(socketStream.bufferInput);
        Assert.isNull(socketStream.socket);
        Assert.isNull(socketStream.errorManager);
        Assert.isNull(socketStream.objectCreator);
        Assert.isFalse(socketStream.connected);
    }

    @Test
    public function shouldNotTryToConnectMoreThanOnce(): Void {
        connectToSocket();
        connectToSocket();
        connectToSocket();

        socket.connect(cast any, 1337).verify();
    }

    @Test
    public function shouldBeAbleToReconnectedIfSocketIsClosed(): Void {
        connectToSocket();

        socketStream.close();

        connectToSocket();

        socket.connect(cast any, 1337).verify(2);
    }

    @Test
    public function shouldCloseSocketIfStreamReturnEof(): Void {
        connectToSocket();

        input.readBytes(cast any, cast any, cast any).throws("Eof");

        socketStream.update();

        socket.close().verify();
    }

    @IgnoreCover
    private inline function mockSampleData():Void {
        var bytes = Bytes.alloc(3);
        var i: Int = 0;
        bytes.set(i++, 1);
        bytes.set(i++, 0);
        bytes.set(i++, 1);
        mockBytes(bytes);
        socketStream.update();
    }

    @IgnoreCover
    private function connectToSocket():Void {
        socket.connect(cast any, 1337).throws("Blocking");
        socketStream.connect("localhost", 1337);
    }

    @IgnoreCover
    private function mockBytes(bytes: Bytes):Void {
        input.readBytes(cast any, cast any, cast any).calls(function(args): Int {
            var readBytes: Bytes = args[0];
            readBytes.blit(0, bytes, 0, bytes.length);
            return bytes.length;
        });
    }

    @IgnoreCover
    private function subscriptionCallback(stream: InputOutputStream):Void {
        cbCount++;
        Assert.areEqual(socketStream, stream);
    }
#end
}

class Error {

    public var msg: String;

    public function new(string: String) {
        msg = string;
    }
}