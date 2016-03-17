package animation;

class TestableSubscribedAnimationManager extends SubscribedAnimationManager {

    public var currentTime: UInt;

    public function new(eventName:String) {
        super(eventName);
    }

    override public function getTime():UInt {
        return currentTime;
    }

}