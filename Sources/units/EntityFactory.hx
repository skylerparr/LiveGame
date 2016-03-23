package units;
import display.DisplayNode;
import world.WorldEntity;
import core.BaseObject;
interface EntityFactory extends BaseObject {
    function createViewForEntity(worldEntity: WorldEntity): DisplayNode;
    function disposeViewForEntity(worldEntity: WorldEntity, display: DisplayNode): Void;
}
