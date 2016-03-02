package display.layer;
class RenderableLayerManager implements LayerManager {

    private var layerMap: Map<String, RenderContainer>;
    private var topContainer(get, null): DisplayNodeContainer;

    private function get_topContainer():DisplayNodeContainer {
        return topContainer;
    }

    public function new(topContainer: DisplayNodeContainer) {
        this.topContainer = topContainer;
    }

    public function init():Void {
        layerMap = new Map<String, RenderContainer>();
    }

    public function dispose():Void {
    }

    public function addLayerByName(layerName:String, container:DisplayNodeContainer, renderer:Renderer):Void {
        if(container == null || renderer == null) {
            return;
        }
        layerMap.set(layerName, {container: container, renderer: renderer});
        topContainer.addChild(container);
    }

    public function getLayerByName(layerName:String):DisplayNodeContainer {
        var renderContainer = layerMap.get(layerName);
        if(renderContainer == null) {
            return null;
        }
        return renderContainer.container;
    }

    public function getLayerName(displayNodeContainer:DisplayNodeContainer):String {
        for(key in layerMap.keys()) {
            var layer: RenderContainer = layerMap.get(key);
            if(layer.container == displayNodeContainer) {
                return key;
            }
        }
        return null;
    }

    public function removeLayerByName(layerName:String):Void {
        var renderContainer: RenderContainer = layerMap.get(layerName);
        if(renderContainer == null) {
            return;
        }
        layerMap.remove(layerName);
        topContainer.removeChild(renderContainer.container);
    }

    public function getLayers():Array<DisplayNodeContainer> {
        var retVal: Array<DisplayNodeContainer> = [];
        for(layer in layerMap) {
            retVal.push(layer.container);
        }
        return retVal;
    }

    public function getLayerMap(): Map<String, RenderContainer> {
        return layerMap;
    }
}

typedef RenderContainer = {
    container: DisplayNodeContainer,
    renderer: Renderer
}