package error;
@IgnoreCover
class TraceLogger implements Logger {
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
}
