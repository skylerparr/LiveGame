package display;
import core.BaseObject;
interface LayerManager extends BaseObject {
    /**
     * Adds a layers to the foreground. Layers are added from background to foreground
     */
    function addLayerByName(layerName: String, container: DisplayNodeContainer, renderer: Renderer): Void;
    function getLayerByName(layerName: String): DisplayNodeContainer;
    function getLayerName(displayNodeContainer: DisplayNodeContainer): String;
    function removeLayerByName(layerName: String): Void;
    function getLayers(): Array<DisplayNodeContainer>;
}
