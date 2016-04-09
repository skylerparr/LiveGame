package animation;

class TestableSubscribedAnimationManager extends SubscribedAnimationManager {

    public var currentTime: UInt;

    override public function getTime():UInt {
        return currentTime;
    }

}