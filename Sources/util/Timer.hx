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
}
