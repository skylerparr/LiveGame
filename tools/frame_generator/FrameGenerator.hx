package;

import sys.io.File;
import haxe.Json;

class FrameGenerator {

    private static var imageWidth: UInt;
    private static var imageHeight: UInt;

    private static var frameWidth: UInt;
    private static var frameHeight: UInt;

    private static var prefix: String;

    public static function main() {
        var args: Array<String> = Sys.args();
        if(args.length != 3) {
            trace("must specify frame dimensions (WxH) and image dimensions (WxH) and prefix");
            return;
        }

        var frameDimensions: Array<String> = args[0].split("x");
        frameWidth = Std.parseInt(frameDimensions[0]);
        frameHeight = Std.parseInt(frameDimensions[1]);

        var imageDimensions: Array<String> = args[1].split("x");
        imageWidth = Std.parseInt(imageDimensions[0]);
        imageHeight = Std.parseInt(imageDimensions[1]);

        prefix = args[2];

        var numberOfFramesWide: UInt = Std.int(imageWidth / frameWidth);
        var numberOfDirections: UInt = Std.int(imageHeight / frameHeight);

        for(j in 0...numberOfDirections) {
            var frames: Array<Dynamic> = [];
            for(i in 0...numberOfFramesWide) {
                frames.push({frame: {x: frameWidth * i, y: j * frameHeight, w: frameWidth, h: frameHeight}});
            }
            var pose: Dynamic = {frames: frames};
            saveFile(pose, j);
        }
    }

    private static function saveFile(pose: Dynamic, index:Int):Void {
        var filename: String = index + "_" + prefix + ".json";
        if(index < 10) {
            filename = "0" + filename;
        }
        File.saveContent(filename, Json.stringify(pose));
    }
}