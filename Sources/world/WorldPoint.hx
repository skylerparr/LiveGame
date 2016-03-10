package world;
interface WorldPoint {
    var x(get, set): Float;
    var y(get, set): Float;
    var z(get, set): Float;

    function moveTo(point: WorldPoint): Void;
}
