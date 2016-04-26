package error;
class TraceErrorManager implements ErrorManager {
    public function new() {
    }

    public function logWarning(msg:Dynamic):Void {
        trace(msg);
    }

    public function logError(msg:Dynamic):Void {
        trace(msg);
    }

    public function logFatal(msg:Dynamic):Void {
        trace(msg);
    }
}
