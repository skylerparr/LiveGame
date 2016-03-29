package;

import sys.io.File;
import haxe.Json;

class FrameGenerator {

    private static var imageWidth: UInt;
    private static var imageHeight: UInt;

    private static var framesWide: UInt;
    private static var framesHigh: UInt;

    private static var prefix: String;

    public static function main() {
        var args: Array<String> = Sys.args();
        if(args.length != 3) {
            trace("must specify number of frames wide and number of frame high (nWxnH) and image dimensions (WxH) and prefix");
            return;
        }

        var frameDimensions: Array<String> = args[0].split("x");
        framesWide = Std.parseInt(frameDimensions[0]);
        framesHigh = Std.parseInt(frameDimensions[1]);

        var imageDimensions: Array<String> = args[1].split("x");
        imageWidth = Std.parseInt(imageDimensions[0]);
        imageHeight = Std.parseInt(imageDimensions[1]);

        prefix = args[2];

        var frameWidth: UInt = Std.int(imageWidth / framesWide);
        var frameHeight: UInt = Std.int(imageHeight / framesHigh);

        for(j in 0...framesHigh) {
            var frames: Array<Dynamic> = [];
            for(i in 0...framesWide) {
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