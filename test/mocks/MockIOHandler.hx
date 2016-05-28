package mocks;

import io.InputOutputStream;
import handler.IOHandler;
class MockIOHandler implements IOHandler {

    @:isVar public var cmdId(get, set):UInt;

    @:isVar public var totalBytes(get, set):UInt;

    public function set_cmdId(value:UInt) {
        return this.cmdId = value;
    }

    public function get_cmdId():UInt {
        return cmdId;
    }

    public function get_totalBytes():UInt {
        return totalBytes;
    }

    public function set_totalBytes(value:UInt) {
        return this.totalBytes = value;
    }

    public function read(stream:InputOutputStream):Void {
    }

    public function write(stream:InputOutputStream):Void {
    }
}