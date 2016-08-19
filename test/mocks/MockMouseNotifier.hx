package mocks;

class MockMouseNotifier {
    public var onMouseUp: Int->Int->Int->Void;
    public var onMouseDown: Int->Int->Int->Void;
    public var onMouseMove: Int->Int->Int->Int->Void;
    public var onMouseWheel: Int->Void;

    public function new() {

    }

}