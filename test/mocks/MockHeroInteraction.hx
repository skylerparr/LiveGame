package mocks;

import world.WorldPoint;
import world.GameObject;
import gameentities.HeroInteraction;
class MockHeroInteraction implements HeroInteraction {
    @:isVar
    public var hero(get, set): GameObject;

    public function set_hero(value:GameObject) {
        return this.hero = value;
    }

    public function get_hero():GameObject {
        return hero;
    }

    public function init():Void {
    }

    public function dispose():Void {
    }

    public function getCurrentLocation():WorldPoint {
        return null;
    }

    public function moveTo(worldPoint:WorldPoint):Void {
    }


}