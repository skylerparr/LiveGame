package error;
interface ErrorManager {
    function logWarning(msg: Dynamic): Void;
    function logError(msg: Dynamic): Void;
    function logFatal(msg: Dynamic): Void;
}
