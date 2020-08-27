package error;
@IgnoreCover
class ConsoleLogger implements Logger {
    public function new() {
    }

    public function logDebug(msg:Dynamic):Void {
        Console.debug("[DEBUG] " + msg);
    }

    public function logInfo(msg:Dynamic):Void {
        Console.log("[INFO] " + msg);
    }

    public function logWarning(msg:Dynamic):Void {
        Console.warn("[WARN] " + msg);
    }

    public function logError(msg:Dynamic):Void {
        Console.error("[ERROR] " + msg);
    }

    public function logFatal(msg:Dynamic):Void {
        Console.error("[FATAL] " + msg);
    }

    public inline function logNull(msg:Dynamic):Void {
        LogHelper.logOnlyIfDebug(msg);
    }
}

class LogHelper {
    macro public static function logOnlyIfDebug(msg: haxe.macro.Expr): haxe.macro.Expr {
        return macro if($e{msg} == null) trace(msg, "is null", '\n${haxe.CallStack.callStack().join("\n")}');
    }
}