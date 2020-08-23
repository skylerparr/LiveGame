package util;
#if !test
import kha.Scheduler;
#end
@IgnoreCover
class Timer {
    public function new() {
    }

    /**
     * returns time in milliseconds
     */
    public static inline function now(): UInt {
        #if test
        return 0;
        #else
        return Std.int(Scheduler.realTime() * 1000);
        #end
    }

    public static var timers: Map<UInt, haxe.Timer> = new Map<UInt, haxe.Timer>();

    public static function setInterval(func: Void -> Void, milli: UInt): UInt {
        var timer: haxe.Timer = new haxe.Timer(milli);
        var id: UInt = Std.int(Math.random() * 0xffffff);
        timers.set(id, timer);
        timer.run = func;
        return id;
    }

    public static function clearInterval(id: UInt): Void {
        var timer: haxe.Timer = timers.get(id);
        if(timer != null) {
            timer.stop();
            timers.remove(id);
        }
    }

    public static function setTimeout(func: Void -> Void, milli: UInt): UInt {
        var id: UInt = 0;
        id = setInterval(function(): Void {
            clearInterval(id);
            func();
        }, milli);
        return id;
    }
}
