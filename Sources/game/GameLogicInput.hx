package game;
import handler.IOHandler;
import core.BaseObject;
interface GameLogicInput extends BaseObject {
  function input(handle: IOHandler): Void;
}
