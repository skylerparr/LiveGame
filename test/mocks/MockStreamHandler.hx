package mocks;

import io.InputOutputStream;
import handler.IOHandler;
import handler.StreamHandler;
import handler.SocketStreamHandler;
class MockStreamHandler implements StreamHandler {

    public function start():Void {
    }

    public function end():Void {
    }

    public function send(handler:IOHandler):Void {
    }

    public function subscribeToConnected(callback: InputOutputStream->Void):Void {
    }

    public function subscribeToClose(callback: InputOutputStream->Void):Void {
    }

    public function unsubscribeToConnected(callback: InputOutputStream->Void):Void {
    }

    public function unsubscribeToClose(callback: InputOutputStream->Void):Void {
    }
}