package animation;

@IgnoreCover
class TestableSubscribedAnimationManager extends SubscribedAnimationManager {

    public var currentTime: UInt;

    override public function getTime():UInt {
        return currentTime;
    }

}