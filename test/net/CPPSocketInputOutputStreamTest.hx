package net;

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
    private var socketStream: CPPSocketInputOutputStream;
    private var errorManager: ErrorManager;

    @Before
    public function setup():Void {
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator = mock(ObjectCreator);
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        socket = mock(TCPSocket);
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

        socketStream.connect("localhost", 1337);

        Assert.isTrue(cbCalled);
        socket.connect(cast any, 1337).verify();
    }

    @Test
    public function shouldNotCallConnectedCallbackIfConnectFails(): Void {
        var cbCalled: Bool = false;
        socketStream.subscribeToConnected(function(stream: InputOutputStream): Void {
            cbCalled = true;
        });
        socket.connect(cast any, 1337).throws(new Error("foo"));

        socketStream.connect("localhost", 1337);
        Assert.isFalse(cbCalled);
        errorManager.logError(cast any).verify();
    }

}

class Error {

    public var msg: String;

    public function new(string: String) {
        msg = string;
    }
}