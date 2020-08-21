package game.actions;

import handler.output.PlayerConnect;
import handler.actions.PlayerConnectedAction;
import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class PlayerConnectActionTest {

  private var playerConnectAction: PlayerConnectAction;
  private var gameLogic: GameLogic;
  private var playerConnectHandler: PlayerConnect;

  @Before
  public function setup() {
    gameLogic = mock(GameLogic);
    playerConnectAction = new PlayerConnectAction();
    playerConnectAction.gameLogic = gameLogic;

    playerConnectHandler = new PlayerConnect();
    playerConnectHandler.playerId = 238;

    playerConnectAction.init();
  }

  @After
  public function tearDown() {
    playerConnectAction = null;
  }

  @Test
  public function shouldSendPlayerIdToGameLogic(): Void {
    playerConnectAction.execute(playerConnectHandler);

    gameLogic.playerConnect(playerConnectHandler.playerId).verify();
  }

  @Test
  public function shouldDispose(): Void {
    playerConnectAction.dispose();
    Assert.isNull(playerConnectAction.gameLogic);
  }
}