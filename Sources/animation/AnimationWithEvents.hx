package animation;
interface AnimationWithEvents extends Animation {
    function subscribeOnComplete(callback: AnimationWithEvents->Void): Void;
    function unsubscribeOnComplete(callback: AnimationWithEvents->Void): Void;
}
