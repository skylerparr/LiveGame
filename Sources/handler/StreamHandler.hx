package handler;
interface StreamHandler {
    function start(): Void;
    function end(): Void;

    function subscribeToConnected(callback: Void->Void): Void;
    function subscribeToClose(callback: Void->Void): Void;
}
