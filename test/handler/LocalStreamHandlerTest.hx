package handler;

import game.GameLogicInput;
import haxe.io.BytesOutput;
import util.MappedSubscriber;
import net.BufferIOStream;
import core.ObjectCreator;
import io.InputOutputStream;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class LocalStreamHandlerTest {
  private var streamHandler: LocalStreamHandler;
  private var objectCreator: ObjectCreator;
  private var output: BytesOutput;
  private var gameLogicInput: GameLogicInput;

  @Before
  public function setup() {
    streamHandler = new LocalStreamHandler();
    objectCreator = mock(ObjectCreator);
    gameLogicInput = mock(GameLogicInput);

    output = new BytesOutput();
    objectCreator.createInstance(BufferIOStream).returns(new BufferIOStream(output));

    streamHandler.objectCreator = objectCreator;
    streamHandler.gameLogicInput = gameLogicInput;
  }

  @After
  public function tearDown() {
    streamHandler = null;
  }

  @Test
  public function shouldSubscribeToConnected(): Void {
    var cb = function(io: InputOutputStream): Void {

    };
    streamHandler.subscribeToConnected(cb);

    Assert.isNotNull(streamHandler.connectedHandlers.get(cb));
  }

  @Test
  public function shouldUnSubscribeToConnected(): Void {
    var cb = function(io: InputOutputStream): Void {

    };
    streamHandler.subscribeToConnected(cb);
    streamHandler.unsubscribeToConnected(cb);
    Assert.isNull(streamHandler.connectedHandlers.get(cb));
  }

  @Test
  public function shouldSubscribeToClose(): Void {
    var cb = function(io: InputOutputStream): Void {

    };
    streamHandler.subscribeToClose(cb);

    Assert.isNotNull(streamHandler.closedHandlers.get(cb));
  }

  @Test
  public function shouldUnSubscribeToClose(): Void {
    var cb = function(io: InputOutputStream): Void {

    };
    streamHandler.subscribeToClose(cb);
    Assert.isNotNull(streamHandler.closedHandlers.get(cb));
    streamHandler.unsubscribeToClose(cb);
    Assert.isNull(streamHandler.closedHandlers.get(cb));
  }

  @Test
  public function shouldDispatchConnectedHandlersOnStart(): Void {
    var connected: Bool = false;
    var connect = function(io: InputOutputStream): Void {
      connected = true;
    };
    streamHandler.subscribeToConnected(connect);
    var closed: Bool = false;
    var close = function(io: InputOutputStream): Void {
      closed = true;
    };
    streamHandler.subscribeToClose(close);

    streamHandler.start();

    Assert.isTrue(connected);
    Assert.isFalse(closed);
  }

  @Test
  public function shouldDoNothingIfThereAreNoSubscribers(): Void {
    var connected: Bool = false;
    var connect = function(io: InputOutputStream): Void {
      connected = true;
    };
    var closed: Bool = false;
    var close = function(io: InputOutputStream): Void {
      closed = true;
    };
    streamHandler.start();
    Assert.isFalse(connected);
    Assert.isFalse(closed);
  }

  @Test
  public function shouldDispatchClosedHandlersOnEnd(): Void {
    var connected: Bool = false;
    var connect = function(io: InputOutputStream): Void {
      connected = true;
    };
    streamHandler.subscribeToConnected(connect);
    var closed: Bool = false;
    var close = function(io: InputOutputStream): Void {
      closed = true;
    };
    streamHandler.subscribeToClose(close);

    streamHandler.end();

    Assert.isFalse(connected);
    Assert.isTrue(closed);
  }

  @Test
  public function shouldSendIOHandlerToGameLogicInput(): Void {
    var handler: IOHandler = mock(IOHandler);
    streamHandler.send(handler);

    gameLogicInput.input(handler).verify();
  }
}