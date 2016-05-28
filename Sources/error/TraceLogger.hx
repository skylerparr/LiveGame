package error;
class TraceLogger implements Logger {
    public function new() {
    }

    public function logDebug(msg:Dynamic):Void {
        trace("[DEBUG] " + msg);
    }

    public function logInfo(msg:Dynamic):Void {
        trace("[INFO] " +msg);
    }

    public function logWarning(msg:Dynamic):Void {
        trace("[WARN] " +msg);
    }

    public function logError(msg:Dynamic):Void {
        trace("[ERROR] " +msg);
    }

    public function logFatal(msg:Dynamic):Void {
        trace("[FATAL] " +msg);
    }
}
