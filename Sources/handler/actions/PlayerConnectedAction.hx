package handler.actions;
import handler.input.PlayerConnected;
import error.Logger;
class PlayerConnectedAction implements StrategyAction {

    @inject
    public var logger: Logger;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function execute(handler:IOHandler):Void {
        var playerAction: PlayerConnected = cast handler;
        logger.logDebug("player id " + playerAction.playerId);
    }
}
