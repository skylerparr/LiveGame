package animation;
import cpp.vm.Thread;
class ThreadedAnimationManager extends SubscribedAnimationManager {

    private var running: Bool = false;

    public function new(eventName: String) {
        super(eventName);
    }

    override public function init():Void {
        super.init();
        subscriber.unsubscribe(this.eventName, onEvent);
    }

    private function onThreadCreated():Void {
        while(running) {
            onEvent();
            Sys.sleep(1 / 60);
        }
    }

    override public function queueAnimationUpdate(animation:AnimationController):Void {
        super.queueAnimationUpdate(animation);
        startAnimationThread();
    }

    override public function dequeueAnimationUpdate(animation:AnimationController):Void {
        super.dequeueAnimationUpdate(animation);
        for(animation in animations) {
            running = false;
            return;
        }
    }

    private inline function startAnimationThread():Void {
        if(!running) {
            running = true;
            Thread.create(onThreadCreated);
        }
    }
}
