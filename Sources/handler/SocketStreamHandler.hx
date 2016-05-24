package handler;
import handler.IOHandler;
import constants.SettingKeys;
import core.ApplicationSettings;
import io.InputOutputStream;
import net.TCPSocketConnector;
import core.BaseObject;
class SocketStreamHandler implements StreamHandler implements BaseObject {

    @inject
    public var connector: TCPSocketConnector;
    @inject
    public var settings: ApplicationSettings;
    @inject
    public var parser: StreamParser;
    @inject
    public var strategyMap: StrategyMap;

    @:isVar
    public var connecting(get, null): Bool;

    function get_connecting():Bool {
        return connecting;
    }

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function start():Void {
        if(connecting) {
            return;
        }
        connecting = true;

        connector.subscribeToConnected(onSocketConnected);
        connector.subscribeToClosed(onSocketClosed);
        connector.subscribeToDataReceived(onDataReceived);

        connector.connect(
            settings.getSetting(SettingKeys.SOCKET_HOST),
            settings.getSetting(SettingKeys.SOCKET_PORT));
    }

    public function end():Void {
        connecting = false;

        connector.unsubscribeToConnected(onSocketConnected);
        connector.unsubscribeToClosed(onSocketClosed);
        connector.unsubscribeDataReceived(onDataReceived);

        connector.close();
    }

    public function subscribeToConnected(callback:Void->Void):Void {
    }

    public function subscribeToClose(callback:Void->Void):Void {
    }

    private function onSocketConnected(stream:InputOutputStream):Void {

    }

    private function onSocketClosed(stream:InputOutputStream):Void {

    }

    private function onDataReceived(stream:InputOutputStream):Void {
        var handler: IOHandler = parser.getHandler(stream);
        var action: StrategyAction = strategyMap.locate(handler);
        action.execute(handler);
    }
}
