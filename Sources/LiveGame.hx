package;
#if !test
import kha.Font;
import kha.Scheduler;
import kha.Assets;
import kha.System;
import kha.ScreenRotation;
import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.Framebuffer;
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
import core.InjectionSettings;
#end

@IgnoreCover
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class LiveGame {
#if test

    public function new() {
    }
#else
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

    private var audioChannel: AudioChannel;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);
    }

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

        var g = backbuffer.g2;
        g.begin(true, Color.fromValue(0));
        renderer.render();
        g.end();

        var g = framebuffer.g2;
        g.begin();
        Scaler.scale(backbuffer, framebuffer, System.screenRotation);
        g.end();

    }
#end
}
