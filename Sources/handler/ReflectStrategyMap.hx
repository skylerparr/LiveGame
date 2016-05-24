package handler;
class ReflectStrategyMap implements StrategyMap {

    public var handlerMap: Map<Class<IOHandler>, StrategyAction>;

    public function new() {
    }

    public function locate(handler:IOHandler):StrategyAction {
        return null;
    }

}
