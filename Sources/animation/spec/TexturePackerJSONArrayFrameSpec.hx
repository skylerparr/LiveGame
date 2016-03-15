package animation.spec;
class TexturePackerJSONArrayFrameSpec {

    public var frames: Array<Frame> = [];

    public function new(jsonArray: Dynamic) {
        var frames: Array<Dynamic> = cast jsonArray.frames;
        for(frame in frames) {
            this.frames.push({x: frame.frame.x, y: frame.frame.y, width: frame.frame.w, height: frame.frame.h, rotated: frame.rotated});
        }
    }
}
