package handler;
import core.ObjectCreator;
import util.MappedSubscriber;
import handler.output.PlayerConnect;
import error.Logger;
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
    public var handlerLookup: HandlerLookup;
    @inject
    public var strategyMap: StrategyMap;
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var logger: Logger;

    @:isVar
    public var connecting(get, null): Bool;

    function get_connecting():Bool {
        return connecting;
    }

    public var handler(get, null): IOHandler;

    private function get_handler():IOHandler {
        return handler;
    }

    private var stream: InputOutputStream;
    public var mappedSubscriber: MappedSubscriber;

    public function new() {
    }

    public function init():Void {
        mappedSubscriber = objectCreator.createInstance(MappedSubscriber);
    }

    public function dispose():Void {
        end();
        connector = null;
        settings = null;
        handlerLookup = null;
        strategyMap = null;
        logger = null;
        handler = null;
        mappedSubscriber.dispose();
        mappedSubscriber = null;
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
            settings.getSetting(SettingKeys.SOCKET_PORT)
        );
    }

    public function end():Void {
        connecting = false;

        connector.unsubscribeToConnected(onSocketConnected);
        connector.unsubscribeToClosed(onSocketClosed);
        connector.unsubscribeDataReceived(onDataReceived);

        connector.close();
    }

    public function subscribeToConnected(callback:InputOutputStream->Void):Void {
        mappedSubscriber.subscribe("connected", callback);
    }

    public function subscribeToClose(callback:InputOutputStream->Void):Void {
        mappedSubscriber.subscribe("closed", callback);
    }

    public function unsubscribeToConnected(callback:InputOutputStream->Void):Void {
        mappedSubscriber.unsubscribe("connected", callback);
    }

    public function unsubscribeToClose(callback:InputOutputStream->Void):Void {
        mappedSubscriber.unsubscribe("closed", callback);
    }

    private function onSocketConnected(stream:InputOutputStream):Void {
        this.stream = stream;
        mappedSubscriber.notify("connected", [stream]);
    }

    private function onSocketClosed(stream:InputOutputStream):Void {
        mappedSubscriber.notify("closed", [stream]);
    }

    public function send(handler:IOHandler):Void {
        handler.write(stream);
    }

    private function onDataReceived(stream:InputOutputStream):Void {
        if(handler == null) {
            handler = handlerLookup.getHandler(stream);
        }
        if(handler == null || handler.totalBytes > stream.bytesAvailable) {
            return;
        }
        handler.read(stream);

        var action: StrategyAction = strategyMap.locate(handler);
        if(action != null) {
            action.execute(handler);
        }

        handler = null;
        onDataReceived(stream);
    }

}
