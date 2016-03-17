package util;
import kha.Scheduler;
class Timer {
    public function new() {
    }

    /**
     * returns time in milliseconds
     */
    public static inline function now(): UInt {
        return Std.int(Scheduler.realTime() * 1000);
    }
}
