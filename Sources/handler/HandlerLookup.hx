package handler;
import io.InputOutputStream;
interface HandlerLookup {
    function getHandler(stream: InputOutputStream): IOHandler;
}
