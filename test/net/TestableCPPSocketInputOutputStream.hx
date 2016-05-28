package net;

class TestableCPPSocketInputOutputStream extends CPPSocketInputOutputStream {
    override public function waitForRead():Bool {
        return true;
    }
}