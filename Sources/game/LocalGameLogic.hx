package game;
import handler.actions.HeroCreatedAction;
import handler.actions.PlayerConnectedAction;
import core.ObjectCreator;
import handler.input.HeroCreated;
import handler.StrategyAction;
import handler.input.PlayerConnected;
class LocalGameLogic implements GameLogic {
  @inject
  public var objectCreator: ObjectCreator;

  public function new() {
  }

  public function playerConnect(playerId:UInt):Void {
    var playerConnected: PlayerConnected = new PlayerConnected();
    playerConnected.identifier = playerId;
    playerConnected.playerId = playerId;

    var action: StrategyAction = objectCreator.createInstance(PlayerConnectedAction);
    action.execute(playerConnected);

    var unitHeroCreated: HeroCreated = new HeroCreated();
    unitHeroCreated.playerId = playerId;
    unitHeroCreated.unitId = 1;
    unitHeroCreated.unitType = 1;
    unitHeroCreated.posX = 250;
    unitHeroCreated.posZ = 250;

    var action: StrategyAction = objectCreator.createInstance(HeroCreatedAction);
    action.execute(unitHeroCreated);
  }
}
