package handler.actions;
import vo.mutable.MutablePlayerVO;
import vo.PlayerVO;
import service.PlayerService;
import handler.input.PlayerConnected;
import error.Logger;
class PlayerConnectedAction implements StrategyAction {

    @inject
    public var logger: Logger;
    @inject
    public var playerService: PlayerService;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
        logger = null;
        playerService = null;
    }

    public function execute(handler:IOHandler):Void {
        var playerAction: PlayerConnected = cast handler;
        logger.logDebug('player id ${playerAction.playerId}, identifier ${playerAction.identifier}');

        if(playerService.uniqueId == playerAction.identifier) {
            playerService.getCurrentPlayer(function(player: PlayerVO): Void {
                cast(player, MutablePlayerVO).id = playerAction.playerId;
            });
        }
    }
}
