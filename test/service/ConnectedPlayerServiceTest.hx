package service;

import vo.PlayerVO;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class ConnectedPlayerServiceTest {

    private var playerService: ConnectedPlayerService;

    @Before
    public function setup():Void {
        playerService = new ConnectedPlayerService();
        playerService.init();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldGetCurrentPlayer(): Void {
        var player: PlayerVO = null;
        playerService.getCurrentPlayer(function(p: PlayerVO): Void {
            player = p;
        });
        Assert.isNotNull(player);
    }

    @Test
    public function shouldGetPlayerUniqueId(): Void {
        Assert.isTrue(playerService.uniqueId > 0);
    }

    @Test
    public function shouldNotCrashIfCallbackIsNull(): Void {
        playerService.getCurrentPlayer(null);
        Assert.isTrue(true);
    }

    @Test
    public function shouldDisposePlayer(): Void {
        playerService.dispose();
        Assert.isNull(playerService.currentPlayer);
        Assert.areEqual(0, playerService.uniqueId);
    }

}