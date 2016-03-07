package;
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

    private var initialized: Bool = false;

    private var backbuffer: Image;
    private var framebuffer: Framebuffer;
    private var fonts: Map<String, Font>;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);
    }

    public function render(framebuffer:Framebuffer):Void {
        if(initialized) {
            return;
        }
        initialized = true;
        this.framebuffer = framebuffer;

        loadFonts(function(): Void {
            new InjectionSettings(backbuffer, this.framebuffer, fonts);
        });

//        var g = backbuffer.g2;
//        g.begin();
//        g.drawSubImage(wizard, 0, 0, xPos, yPos, FRAME_SIZE, FRAME_SIZE);
//        g.end();
//
//        var g = framebuffer.g2;
//
//        g.begin();
//
//        Scaler.scale(backbuffer, framebuffer, System.screenRotation);
//
//        g.end();
    }

    @:async
    private function loadFonts():Void {
        fonts = new Map<String, Font>();
        fonts.set("helveticaneue_light", @await Assets.loadFont("helveticaneue_light"));
    }

    public function update():Void {

    }
}
