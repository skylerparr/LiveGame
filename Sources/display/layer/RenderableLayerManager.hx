package display.layer;
class RenderableLayerManager implements LayerManager {

    private var layerMap: Map<String, DisplayNodeContainer>;
    private var topContainer(get, null): DisplayNodeContainer;

    private function get_topContainer():DisplayNodeContainer {
        return topContainer;
    }

    public function new(topContainer: DisplayNodeContainer) {
        this.topContainer = topContainer;
    }

    public function init():Void {
        layerMap = new Map<String, DisplayNodeContainer>();
    }

    public function dispose():Void {
    }

    public function addLayerByName(layerName:String, container:DisplayNodeContainer):Void {
        if(container == null) {
            return;
        }
        layerMap.set(layerName, container);
        topContainer.addChild(container);
    }

    public function getLayerByName(layerName:String):DisplayNodeContainer {
        var container: DisplayNodeContainer = layerMap.get(layerName);
        if(container == null) {
            return null;
        }
        return container;
    }

    public function getLayerName(displayNodeContainer:DisplayNodeContainer):String {
        for(key in layerMap.keys()) {
            var layer: DisplayNodeContainer = layerMap.get(key);
            if(layer == displayNodeContainer) {
                return key;
            }
        }
        return null;
    }

    public function removeLayerByName(layerName:String):Void {
        var container: DisplayNodeContainer = layerMap.get(layerName);
        if(container == null) {
            return;
        }
        layerMap.remove(layerName);
        topContainer.removeChild(container);
    }

    public function getLayers():Array<DisplayNodeContainer> {
        var retVal: Array<DisplayNodeContainer> = [];
        for(layer in layerMap) {
            retVal.push(layer);
        }
        return retVal;
    }

    public function getLayerMap(): Map<String, DisplayNodeContainer> {
        return layerMap;
    }

}
