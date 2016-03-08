package;
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

    private var initialized: Bool = false;

    private var backbuffer: Image;
    private var framebuffer: Framebuffer;
    private var fonts: Map<String, Font>;

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
        });

    }

    @:async
    private function loadFonts():Void {
        fonts = new Map<String, Font>();
        fonts.set("helveticaneue_light", @await Assets.loadFont("helveticaneue_light"));
    }

    public function update():Void {
        var g = backbuffer.g2;
        g.begin();
        renderer.render();
        g.end();

        var g = framebuffer.g2;
        g.begin();
        Scaler.scale(backbuffer, framebuffer, System.screenRotation);
        g.end();

    }
}
