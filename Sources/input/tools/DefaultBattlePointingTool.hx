package input.tools;
import world.GameObject;
import gameentities.HeroInteraction;
import world.WorldEntity;
import world.WorldPoint;
import geom.Point;
import world.GameWorld;
class DefaultBattlePointingTool implements PointingTool {

    @inject
    public var gameWorld: GameWorld;
    @inject
    public var heroInteraction: HeroInteraction;

    public var name(get, null):String;

    public function get_name():String {
        return name;
    }

    private var currentSelectedGameObject: GameObject;

    public function new() {
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function activate(args:Array<Dynamic>):Void {
    }

    public function deactivate():Void {
    }

    public function onPointerDown(e:PointerEvent):Void {
    }

    public function onPointerMove(e:PointerEvent):Void {
    }

    public function onPointerUp(e:PointerEvent):Void {
    }

    public function onPointerClick(e:PointerEvent):Void {
        var point: Point = new Point(e.screenX, e.screenY);
        var wp: WorldPoint = gameWorld.screenToWorld(point);
        currentSelectedGameObject = cast gameWorld.getItemAt(wp);
    }

    public function onPointerRightDown(e:PointerEvent):Void {
    }

    public function onPointerRightUp(e:PointerEvent):Void {
    }

    public function onPointerRightClick(e:PointerEvent):Void {
        if(currentSelectedGameObject != null) {
            var point: Point = new Point(e.screenX, e.screenY);
            var wp: WorldPoint = gameWorld.screenToWorld(point);
            heroInteraction.moveSquadTo(currentSelectedGameObject, wp);
        }
    }

    public function onPointerDoubleClick(e:PointerEvent):Void {
    }

    public function onScroll(e:PointerEvent):Void {
    }

    public function onPointerMiddleDown(e:PointerEvent):Void {
    }

    public function onPointerMiddleUp(e:PointerEvent):Void {
    }

    public function onPointerMiddleClick(e:PointerEvent):Void {
    }


}
