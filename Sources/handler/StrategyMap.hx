package handler;
import core.BaseObject;
interface StrategyMap extends BaseObject {
    function locate(handler: IOHandler): StrategyAction;
}
