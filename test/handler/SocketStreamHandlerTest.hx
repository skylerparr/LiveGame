package handler;

import error.Logger;
import handler.SocketStreamHandlerTest.StrategyActionHandler;
import util.MappedSubscriber;
import core.ObjectCreator;
import mocks.MockIOHandler;
import constants.SettingKeys;
import mocks.MockInputOutputStream;
import core.ApplicationSettings;
import net.TCPSocketConnector;
import io.InputOutputStream;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class SocketStreamHandlerTest {

    private var streamHandler: SocketStreamHandler;
    private var connector: TCPSocketConnector;
    private var applicationSettings: ApplicationSettings;
    private var parser: StreamParser;
    private var stream: InputOutputStream;
    private var strategyMap: StrategyMap;
    private var logger: Logger;
    private var cbCount: Int;

    @Before
    public function setup():Void {
        stream = mock(MockInputOutputStream);
        parser = mock(StreamParser);
        connector = mock(TCPSocketConnector);
        applicationSettings = mock(ApplicationSettings);
        strategyMap = mock(StrategyMap);
        logger = mock(Logger);

        applicationSettings.getSetting(SettingKeys.SOCKET_HOST).returns("localhost");
        applicationSettings.getSetting(SettingKeys.SOCKET_PORT).returns(1337);

        streamHandler = new SocketStreamHandler();
        streamHandler.connector = connector;
        streamHandler.settings = applicationSettings;
        streamHandler.parser = parser;
        streamHandler.strategyMap = strategyMap;
        streamHandler.logger = logger;
        streamHandler.init();
    }

    @After
    public function tearDown():Void {
        cbCount = 0;
    }

    @Test
    public function shouldMakeSocketConnectionWhenStarting(): Void {
        streamHandler.start();
        connector.connect("localhost", 1337).verify();
    }

    @Test
    public function shouldSetUpSubscriptionsOnConnector(): Void {
        streamHandler.start();
        connector.subscribeToConnected(cast any).verify();
        connector.subscribeToClosed(cast any).verify();
        connector.subscribeToDataReceived(cast any).verify();
    }

    @Test
    public function shouldNotConnectTwice(): Void {
        streamHandler.start();
        streamHandler.start();

        connector.connect("localhost", 1337).verify();
        connector.subscribeToConnected(cast any).verify();
        connector.subscribeToClosed(cast any).verify();
        connector.subscribeToDataReceived(cast any).verify();
    }

    @Test
    public function shouldCloseConnectionAndUnsubscribeOnEnd(): Void {
        streamHandler.start();
        streamHandler.end();

        Assert.isFalse(streamHandler.connecting);
        connector.close().verify();
        connector.unsubscribeToConnected(cast any).verify();
        connector.unsubscribeToClosed(cast any).verify();
        connector.unsubscribeDataReceived(cast any).verify();
    }

    @Test
    public function shouldReturnAIOHandlerFromParserAndPassToStrategyMapAndExecuteStrategy(): Void {
        var actionHandler: StrategyActionHandler = setupAction();

        parser.reset();
        parser.getHandler(cast any).calls(function(args): IOHandler {
            actionHandler.handler.reset();
            stream.reset();

            cbCount++;
            if(cbCount == 1) {
                actionHandler.handler.totalBytes.returns(16);
                stream.bytesAvailable.returns(16);
            }
            else if(cbCount == 2) {
                actionHandler.handler.totalBytes.returns(16);
                stream.bytesAvailable.returns(0);
            }
            return actionHandler.handler;
        });

        actionHandler.onDataCb(stream);
        actionHandler.action.execute(actionHandler.handler).verify();
    }

    @Test
    public function shouldNotExecuteActionIfNotEnoughDataIsAvailable(): Void {
        var actionHandler: StrategyActionHandler = setupAction();
        actionHandler.handler.totalBytes.returns(16);
        stream.bytesAvailable.returns(8);

        actionHandler.onDataCb(stream);
        actionHandler.action.execute(actionHandler.handler).verify(0);
    }

    @Test
    public function shouldExecuteMultipleActionsIfDataIsAvailable(): Void {
        var actionHandler: StrategyActionHandler = setupAction();

        var cbCount: Int = 0;

        parser.reset();
        parser.getHandler(cast any).calls(function(args): IOHandler {
            actionHandler.handler.reset();
            stream.reset();

            cbCount++;
            if(cbCount == 1) {
                actionHandler.handler.totalBytes.returns(16);
                stream.bytesAvailable.returns(32);
            } else if(cbCount == 2) {
                actionHandler.handler.totalBytes.returns(16);
                stream.bytesAvailable.returns(20);
            } else if(cbCount == 3) {
                actionHandler.handler.totalBytes.returns(16);
                stream.bytesAvailable.returns(4);
            }
            return actionHandler.handler;
        });

        actionHandler.onDataCb(stream);
        actionHandler.action.execute(actionHandler.handler).verify(2);
    }

    @Test
    public function shouldNotCrashIfHandlerIsNull(): Void {
        var actionHandler: StrategyActionHandler = setupAction();
        parser.reset();
        parser.getHandler(cast any).calls(function(args): IOHandler {
            return null;
        });

        actionHandler.onDataCb(stream);
        actionHandler.action.execute(actionHandler.handler).verify(0);
        logger.logFatal(cast any).verify();
    }

    @Test
    public function shouldSubscribeToConnected(): Void {
        var connectedCallback: InputOutputStream->Void = null;
        connector.subscribeToConnected(cast any).calls(function(args): Void {
            if(connectedCallback == null) {
                connectedCallback = args[0];
            }
        });
        streamHandler.subscribeToConnected(onConnected);
        streamHandler.start();

        connectedCallback(stream);

        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldUnSubscribeToConnected(): Void {
        var connectedCallback: InputOutputStream->Void = null;
        connector.subscribeToConnected(cast any).calls(function(args): Void {
            if(connectedCallback == null) {
                connectedCallback = args[0];
            }
        });
        connector.unsubscribeToConnected(cast any).calls(function(args): Void {
            connectedCallback = null;
        });
        streamHandler.subscribeToConnected(onConnected);
        streamHandler.start();
        connectedCallback(stream);

        streamHandler.unsubscribeToConnected(onConnected);
        streamHandler.start();

        Assert.isNull(connectedCallback);
    }

    @Test
    public function shouldSubscribeToClose(): Void {
        var closedCb: InputOutputStream->Void = null;
        connector.subscribeToClosed(cast any).calls(function(args): Void {
            if(closedCb == null) {
                closedCb = args[0];
            }
        });
        streamHandler.subscribeToClose(onConnected);
        streamHandler.start();
        streamHandler.end();

        closedCb(stream);

        Assert.areEqual(1, cbCount);
    }

    @Test
    public function shouldUnsubscribeToClose(): Void {
        var closedCb: InputOutputStream->Void = null;
        connector.subscribeToClosed(cast any).calls(function(args): Void {
            if(closedCb == null) {
                closedCb = args[0];
            }
        });
        connector.unsubscribeToClosed(cast any).calls(function(args): Void {
            closedCb = null;
        });
        streamHandler.subscribeToClose(onConnected);
        streamHandler.start();
        closedCb(stream);

        streamHandler.unsubscribeToClose(onConnected);
        streamHandler.start();

        Assert.isNull(closedCb);
    }

    @IgnoreCover
    private function setupAction():StrategyActionHandler {
        var dataReceivedCb: InputOutputStream->Void = null;
        connector.subscribeToDataReceived(cast any).calls(function(args): Void {
            dataReceivedCb = args[0];
        });
        var handler: IOHandler = mock(MockIOHandler);
        var action: StrategyAction = mock(StrategyAction);

        parser.getHandler(stream).returns(handler);
        strategyMap.locate(handler).returns(action);

        streamHandler.start();

        return {action: action, handler: handler, onDataCb: dataReceivedCb};
    }

    @IgnoreCover
    private function onConnected(ioStream: InputOutputStream):Void {
        cbCount++;
    }
}

@IgnoreCover
typedef StrategyActionHandler = {
    action: StrategyAction,
    handler: IOHandler,
    onDataCb: InputOutputStream->Void
}