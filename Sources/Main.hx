package;

#if !test
import constants.ScreenConstants;
import kha.System;
#end

@IgnoreCover
class Main {
    public static function main() {
        mconsole.Console.start();
        #if !test
        System.init({title: "Live Game", width: ScreenConstants.screenWidth, height: ScreenConstants.screenHeight}, initialized);
        #end
    }

    #if !test
    private static function initialized():Void {
        var game = new LiveGame();
        System.notifyOnRender(game.render);
    }
    #end
}
