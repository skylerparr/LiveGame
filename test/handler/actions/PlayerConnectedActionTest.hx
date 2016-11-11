package handler.actions;

import massive.munit.Assert;
import service.ConnectedPlayerService;
import handler.input.PlayerConnected;
import vo.mutable.MutablePlayerVO;
import service.PlayerService;
import error.Logger;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
class PlayerConnectedActionTest {

    private var playerConnectedAction: PlayerConnectedAction;
    private var logger: Logger;
    private var playerService: ConnectedPlayerService;
    private var player: MutablePlayerVO;
    private var playerHandler: PlayerConnected;

    @Before
    public function setup():Void {
        logger = mock(Logger);
        playerService = mock(ConnectedPlayerService);
        player = mock(MutablePlayerVO);
        playerHandler = new PlayerConnected();

        playerConnectedAction = new PlayerConnectedAction();
        playerConnectedAction.logger = logger;
        playerConnectedAction.playerService = playerService;
        playerConnectedAction.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldAssignPlayerId(): Void {
        playerHandler.playerId = 49802;
        playerHandler.identifier = 89349;
        playerService.get_uniqueId().returns(89349);
        playerService.getCurrentPlayer(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            args[0](player);
        });

        playerConnectedAction.execute(playerHandler);

        player.set_id(49802).verify();
    }

    @Test
    public function shouldNotAssignPlayerIdIfUniqueIdDoesntMatch(): Void {
        playerHandler.playerId = 49802;
        playerHandler.identifier = 5;
        playerService.get_uniqueId().returns(89349);
        playerService.getCurrentPlayer(cast isNotNull).calls(function(args: Array<Dynamic>): Void {
            args[0](player);
        });

        playerConnectedAction.execute(playerHandler);

        player.set_id(49802).verify(0);
    }

    @Test
    public function shouldDispose(): Void {
        playerConnectedAction.dispose();
        Assert.isNull(playerConnectedAction.logger);
        Assert.isNull(playerConnectedAction.playerService);
    }
}