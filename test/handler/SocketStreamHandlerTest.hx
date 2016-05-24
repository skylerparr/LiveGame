package handler;

import mocks.MockIOHandler;
import constants.SettingKeys;
import mocks.MockInputOutputStream;
import core.ApplicationSettings;
import net.TCPSocketConnector;
import net.TCPSocket;
import io.InputOutputStream;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
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

    @Before
    public function setup():Void {
        stream = mock(MockInputOutputStream);
        parser = mock(StreamParser);
        connector = mock(TCPSocketConnector);
        applicationSettings = mock(ApplicationSettings);
        strategyMap = mock(StrategyMap);

        applicationSettings.getSetting(SettingKeys.SOCKET_HOST).returns("localhost");
        applicationSettings.getSetting(SettingKeys.SOCKET_PORT).returns(1337);

        streamHandler = new SocketStreamHandler();
        streamHandler.connector = connector;
        streamHandler.settings = applicationSettings;
        streamHandler.parser = parser;
        streamHandler.strategyMap = strategyMap;
        streamHandler.init();
    }

    @After
    public function tearDown():Void {
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
        var dataReceivedCb: InputOutputStream->Void = null;
        connector.subscribeToDataReceived(cast any).calls(function(args): Void {
            dataReceivedCb = args[0];
        });
        var handler: IOHandler = mock(MockIOHandler);
        var action: StrategyAction = mock(StrategyAction);

        parser.getHandler(stream).returns(handler);
        strategyMap.locate(handler).returns(action);

        streamHandler.start();
        dataReceivedCb(stream);

        action.execute(handler).verify();
    }
}