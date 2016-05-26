package handler;
import core.BaseObject;
import io.InputOutputStream;
interface HandlerLookup extends BaseObject {
    function getHandler(stream: InputOutputStream): IOHandler;
}
