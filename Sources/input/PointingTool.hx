package input;
interface PointingTool extends PointingInputSourceListener {

    /**
     * Set up for the user to use
     *
     * @param args Optional arguments the tool may use
     */
    function activate(args: Array<Dynamic>): Void;

    /**
     * Clean-up
     */
    function deactivate(): Void;

    /**
     * Return the name of the tool.
     */
    var name(get, null): String;

}
