package handler;
import core.BaseObject;
interface StrategyAction extends BaseObject {
    function execute(handler: IOHandler): Void;
}
