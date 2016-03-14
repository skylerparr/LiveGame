package animation.spec;

import animation.spec.TexturePackerJSONArrayFrameSpec.Frame;
import haxe.Json;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class TexturePackerJSONArrayFrameSpecTest {

    private var texturePacker: TexturePackerJSONArrayFrameSpec;

    public function new() {

    }

    @Before
    public function setup():Void {
    }

    @After
    public function tearDown():Void {
        texturePacker = null;
    }

    @Test
    public function shouldExtractFramesFromJSONArray(): Void {
//        trace(JSONArray.dataString);
//        var data: Dynamic = Json.parse(JSONArray.dataString);
//        trace(data);
//        texturePacker = new TexturePackerJSONArrayFrameSpec(data);
//
//        var frame: TPFrame = texturePacker.frames[0];
//        Assert.areEqual(133, frame.x);
//        Assert.areEqual(1, frame.y);
//        Assert.areEqual(64, frame.width);
//        Assert.areEqual(61, frame.height);
    }
}

class JSONArray {

    public static inline var dataString: String = "{\"frames\": [
{
	\"filename\": \"w01.png\",
	\"frame\": {\"x\":133,\"y\":1,\"w\":64,\"h\":61},
	\"rotated\": false,
	\"trimmed\": true,
	\"spriteSourceSize\": {\"x\":0,\"y\":3,\"w\":64,\"h\":61},
	\"sourceSize\": {\"w\":64,\"h\":64},
	\"pivot\": {\"x\":0.5,\"y\":0.5}
},
{
	\"filename\": \"w02.png\",
	\"frame\": {\"x\":199,\"y\":1,\"w\":63,\"h\":60},
	\"rotated\": false,
	\"trimmed\": true,
	\"spriteSourceSize\": {\"x\":1,\"y\":4,\"w\":63,\"h\":60},
	\"sourceSize\": {\"w\":64,\"h\":64},
	\"pivot\": {\"x\":0.5,\"y\":0.5}
},
{
	\"filename\": \"w03.png\",
	\"frame\": {\"x\":199,\"y\":1,\"w\":63,\"h\":60},
	\"rotated\": false,
	\"trimmed\": true,
	\"spriteSourceSize\": {\"x\":1,\"y\":4,\"w\":63,\"h\":60},
	\"sourceSize\": {\"w\":64,\"h\":64},
	\"pivot\": {\"x\":0.5,\"y\":0.5}
}],
\"meta\": {
	\"version\": \"1.0\",
	\"image\": \"wizard.png\",
	\"format\": \"RGBA8888\",
	\"size\": {\"w\":263,\"h\":64},
	\"scale\": \"1\",
}
}
";

    public function new() {
    }
}