package;
import assets.SoundAsset;
import assets.AssetLocator;
import kha.audio1.AudioChannel;
import kha.audio1.Audio;
import kha.Sound;
import kha.input.Mouse;
import world.ViewPort;
import constants.EventNames;
import util.EventNotifier;
import display.Renderer;
import kha.Font;
import core.InjectionSettings;
import kha.Scheduler;
import kha.Assets;
import kha.System;
import kha.ScreenRotation;
import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.Framebuffer;

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class LiveGame {

    @inject
    public var renderer: Renderer;
    @inject
    public var notifier: EventNotifier;
    @inject
    public var viewPort: ViewPort;
    @inject
    public var assetLocator: AssetLocator;

    private var initialized: Bool = false;

    private var backbuffer: Image;
    private var framebuffer: Framebuffer;
    private var fonts: Map<String, Font>;

//    private var xPos: Int;
//    private var yPos: Int;
//    private var engaged: Bool;
//    private var dirty: Bool;

    private var audioChannel: AudioChannel;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);

//        Mouse.get().notify(onDown, onUp, onMove, null);
    }

//    private function onDown(x:Int, y:Int, z:Int):Void {
//        if(x == 0) {
//            engaged = true;
//        }
//    }
//
//    private function onUp(x:Int, y:Int, z:Int):Void {
//        engaged = false;
//        xPos = 0;
//        yPos = 0;
//    }
//
//    private function onMove(w: Int, x:Int, y:Int, z:Int):Void {
//        if(engaged) {
//            xPos = y;
//            yPos = z;
//            dirty = true;
//        }
//    }
//
    public function render(framebuffer:Framebuffer):Void {
        this.framebuffer = framebuffer;
        if(initialized) {
            return;
        }
        initialized = true;

        loadFonts(function(): Void {
            var settings = new InjectionSettings(backbuffer, fonts);
            settings.injector.injectInto(this);
            Scheduler.addTimeTask(this.update, 0, 1 / 60);

//            loadMusic();
        });

    }

    private function loadMusic():Void {
        assetLocator.getSoundAssetByName("song_1", onMusicLoaded);
    }

    private function onMusicLoaded(soundAsset: SoundAsset):Void {
        audioChannel = Audio.play(soundAsset.data, true);
    }

    @:async
    private function loadFonts():Void {
        fonts = new Map<String, Font>();
        fonts.set("helveticaneue_light", @await Assets.loadFont("helveticaneue_light"));
    }

    public function update():Void {
        notifier.notify(EventNames.ENTER_GAME_LOOP, null);

//        if(engaged) {
//            viewPort.x -= xPos;
//            viewPort.y -= yPos;

//            xPos = 0;
//            yPos = 0;

//            audioChannel.volume -= 0.0002;
//            if(audioChannel.volume <= 0) {
//                audioChannel.volume = 0;
//            }
//        }

        var g = backbuffer.g2;
        g.begin(true, Color.fromValue(0));
        renderer.render();
        g.end();

        var g = framebuffer.g2;
        g.begin();
        Scaler.scale(backbuffer, framebuffer, System.screenRotation);
        g.end();

//        dirty = false;
    }
}
