package handler;
import io.InputOutputStream;
interface StreamParser {
    function getHandler(stream: InputOutputStream): IOHandler;
}
