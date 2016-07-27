package animation.spec;
import geom.Point;
class TexturePackerJSONArrayFrameSpec {

    public var frames: Array<Frame> = [];

    public function new(jsonArray: Dynamic, offset: Point) {
        var frames: Array<Dynamic> = cast jsonArray.frames;
        for(frame in frames) {
            this.frames.push({x: frame.frame.x + offset.x, y: frame.frame.y + offset.y, width: frame.frame.w, height: frame.frame.h, rotated: frame.rotated});
        }
    }
}
