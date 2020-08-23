package game;
import world.WorldPoint;
import geom.Rectangle;
import world.WorldEntity;
import vo.UnitVO;
class FullGameWorldObjects implements GameWorldObjects {
  public function new() {
  }

  public function init():Void {
  }

  public function dispose():Void {
  }

  public function getWorldEntityForUnit(unitVO:UnitVO):WorldEntity {
  }

  public function removeUnit(unitVO:UnitVO):Void {
  }

  public function getEntitiesInArea(rect:Rectangle):Array<WorldEntity> {
  }

  public function getUnit(unitId:Int):UnitVO {
  }

  public function addUnit(unitVO:UnitVO):Void {
  }

  public function getUnitLocation(unitVO:UnitVO):WorldPoint {
  }

  public function moveUnitTo(unitVO:UnitVO, location:WorldPoint):Void {
  }

  public function getUnitsInArea(rect:Rectangle):Array<UnitVO> {
  }

  public function getUnitsInRadius(radius:Float):Array<UnitVO> {
  }
}
