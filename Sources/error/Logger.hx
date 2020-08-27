package error;
interface Logger {
    function logDebug(msg: Dynamic): Void;
    function logInfo(msg: Dynamic): Void;
    function logWarning(msg: Dynamic): Void;
    function logError(msg: Dynamic): Void;
    function logFatal(msg: Dynamic): Void;
    function logNull(msg: Dynamic): Void;
}
