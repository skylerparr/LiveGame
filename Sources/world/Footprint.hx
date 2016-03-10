package world;
/**
 * this is the space the object takes on the world
 */
import geom.Point;
import geom.Rectangle;
interface Footprint {
    var registrationPoint(get, set): Point;
    var footprint(get, set): Rectangle;
}
