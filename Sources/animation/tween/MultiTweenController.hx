package animation.tween;
import constants.EventNames;
import util.Subscriber;
class MultiTweenController implements TweenController {
    @inject
    public var subscriber: Subscriber;

    private var allTweens: Map<Tween, Tween>;

    public function new() {
    }

    public function init():Void {
        subscriber.subscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
        allTweens = new Map<Tween, Tween>();
    }

    public function dispose():Void {
        subscriber.unsubscribe(EventNames.ENTER_GAME_LOOP, onUpdate);
    }

    private function onUpdate():Void {
        for(tween in allTweens) {
            tween.update();
        }
    }

    public function addTween(tween:Tween):Void {
        allTweens.set(tween, tween);
    }

    public function removeTween(tween:Tween):Void {
        allTweens.remove(tween);
    }

    public function pauseAll():Void {
        for(tween in allTweens) {
            tween.pause();
        }
    }

    public function resumeAll():Void {
        for(tween in allTweens) {
            tween.resume();
        }
    }

    public function stopAll():Void {
        for(tween in allTweens) {
            tween.stop();
        }
    }
}
