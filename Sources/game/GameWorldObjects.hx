package game;
import world.WorldEntity;
import geom.Rectangle;
import world.WorldPoint;
import vo.UnitVO;
import core.BaseObject;
interface GameWorldObjects extends BaseObject {
  function getUnit(unitId: Int): UnitVO;
  function addUnit(unitVO: UnitVO): Void;
  function removeUnit(unitVO: UnitVO): Void;
  function getWorldEntityForUnit(unitVO: UnitVO): WorldEntity;
  function getUnitLocation(unitVO: UnitVO): WorldPoint;
  function moveUnitTo(unitVO: UnitVO, location: WorldPoint): Void;
  function getUnitsInArea(rect: Rectangle): Array<UnitVO>;
  function getEntitiesInArea(rect: Rectangle): Array<WorldEntity>;
  function getUnitsInRadius(radius: Float): Array<UnitVO>;
}
