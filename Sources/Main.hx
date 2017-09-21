package;

#if !test
import kha.System;
#end

@IgnoreCover
class Main {
    public static function main() {
        mconsole.Console.start();
        #if !test
        System.init({title: "Live Game", width: 800, height: 600}, initialized);
        #end
    }

    #if !test
    private static function initialized():Void {
        var game = new LiveGame();
        System.notifyOnRender(game.render);
    }
    #end
}
