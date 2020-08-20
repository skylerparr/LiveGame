package handler;
import handler.output.PlayerConnect;
import handler.actions.HeroCreatedAction;
import handler.input.HeroCreated;
import handler.actions.PlayerConnectedAction;
import handler.input.PlayerConnected;
import util.Subscriber;
import net.BufferIOStream;
import core.ObjectCreator;
import io.InputOutputStream;
import haxe.ds.ObjectMap;
class LocalStreamHandler implements StreamHandler {
  @inject
  public var objectCreator: ObjectCreator;

  public var connectedHandlers: ObjectMap<Dynamic, InputOutputStream>;
  public var closedHandlers: ObjectMap<Dynamic, InputOutputStream>;

  public function new() {
    connectedHandlers = new ObjectMap<Dynamic, InputOutputStream>();
    closedHandlers = new ObjectMap<Dynamic, InputOutputStream>();
  }

  public function start():Void {
    for(handler in connectedHandlers.keys()) {
      var stream: InputOutputStream = connectedHandlers.get(handler);
      handler(stream);
    }
  }

  public function end():Void {
    for(handler in closedHandlers.keys()) {
      var stream: InputOutputStream = closedHandlers.get(handler);
      handler(stream);
    }
  }

  public function send(handler:IOHandler):Void {
    switch(handler.cmdId) {
      case IOCommands.PLAYER_CONNECT:
        var playerId = cast(handler, PlayerConnect).playerId;
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
      case _:
        trace(handler.cmdId);
    }
  }

  public function subscribeToConnected(callback:(InputOutputStream) -> Void):Void {
    var stream: InputOutputStream = objectCreator.createInstance(BufferIOStream);
    connectedHandlers.set(callback, stream);
  }

  public function subscribeToClose(callback:(InputOutputStream) -> Void):Void {
    var stream: InputOutputStream = objectCreator.createInstance(BufferIOStream);
    closedHandlers.set(callback, stream);
  }

  public function unsubscribeToConnected(callback:(InputOutputStream) -> Void):Void {
    connectedHandlers.remove(callback);
  }

  public function unsubscribeToClose(callback:(InputOutputStream) -> Void):Void {
    closedHandlers.remove(callback);
  }
}
