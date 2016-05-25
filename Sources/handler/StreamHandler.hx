package handler;
import io.InputOutputStream;
interface StreamHandler {
    function start(): Void;
    function end(): Void;

    function subscribeToConnected(callback: InputOutputStream->Void): Void;
    function subscribeToClose(callback: InputOutputStream->Void): Void;
    function unsubscribeToConnected(callback: InputOutputStream->Void): Void;
    function unsubscribeToClose(callback: InputOutputStream->Void): Void;
}
