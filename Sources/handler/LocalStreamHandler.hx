package handler;
import game.GameLogicInput;
import handler.output.PlayerConnect;
import net.BufferIOStream;
import core.ObjectCreator;
import io.InputOutputStream;
import haxe.ds.ObjectMap;
class LocalStreamHandler implements StreamHandler {
  @inject
  public var objectCreator: ObjectCreator;
  @inject
  public var gameLogicInput: GameLogicInput;

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
    gameLogicInput.input(handler);
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
