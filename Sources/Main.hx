package;

#if !test
import constants.ScreenConstants;
import kha.System;
import kha.Window;
#end

@IgnoreCover
class Main {
    public static function main() {
        mconsole.Console.start();
        #if !test
        System.start({title: "Live Game", width: ScreenConstants.screenWidth, height: ScreenConstants.screenHeight}, initialized);
        #end
    }

    #if !test
    private static function initialized(window: Window):Void {
        var game = new LiveGame();
        System.notifyOnFrames(game.render);
    }
    #end
}
