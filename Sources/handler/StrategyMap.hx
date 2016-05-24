package handler;
interface StrategyMap {
    function locate(handler: IOHandler): StrategyAction;
}
