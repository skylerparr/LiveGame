package sound;
import haxe.ds.ObjectMap;
class SimpleSoundManager implements SoundManager {

    public var allLayers(get, null): Map<String, SoundLayer>;

    @:isVar
    function get_allLayers():Map<String, SoundLayer> {
        return allLayers;
    }

    @:isVar
    public var masterVolume(get, set):Float;

    public function set_masterVolume(value:Float) {
        return this.masterVolume = value;
    }

    public function get_masterVolume():Float {
        return masterVolume;
    }

    public var layerVolumeMap(get, null): ObjectMap<SoundLayer, Float>;

    function get_layerVolumeMap():ObjectMap<SoundLayer, Float> {
        return layerVolumeMap;
    }

    public function new() {
    }

    public function init():Void {
        allLayers = new Map<String, SoundLayer>();
        layerVolumeMap = new ObjectMap<SoundLayer, Float>();
    }

    public function dispose():Void {
    }

    public function playAll():Void {
        for(layer in allLayers) {
            layer.play();
        }
    }

    public function stopAll():Void {
        for(layer in allLayers) {
            layer.stop();
        }
    }

    public function pauseAll():Void {
        for(layer in allLayers) {
            layer.pause();
        }
    }

    public function resumeAll():Void {
        for(layer in allLayers) {
            layer.resume();
        }
    }

    public function addSoundLayer(name:String, soundLayer:SoundLayer):Void {
        allLayers.set(name, soundLayer);
        layerVolumeMap.set(soundLayer, soundLayer.volume);
        soundLayer.subscribeToVolumeChange(onVolumeChanged);
    }

    private function onVolumeChanged(soundLayer:SoundLayer):Void {
        layerVolumeMap.set(soundLayer, soundLayer.volume);
    }

    public function getSoundLayerByName(name:String):SoundLayer {
        return allLayers.get(name);
    }

    public function removeSoundLayerByName(name:String):Void {
        var soundLayer: SoundLayer = allLayers.get(name);
        soundLayer.unsubscribeFromVolumeChange(onVolumeChanged);
        layerVolumeMap.remove(soundLayer);
        allLayers.remove(name);
    }

}
