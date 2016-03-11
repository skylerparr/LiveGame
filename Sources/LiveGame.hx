package;
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

    private var initialized: Bool = false;

    private var backbuffer: Image;
    private var framebuffer: Framebuffer;
    private var fonts: Map<String, Font>;

    private var xPos: Int;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);

        Mouse.get().notify(onDown, onUp, onMove, null);
    }

    private function onDown(x:Int, y:Int, z:Int):Void {
        trace(x);
        trace(y);
        trace(z);
    }

    private function onUp(x:Int, y:Int, z:Int):Void {
        trace(x);
        trace(y);
        trace(z);
    }

    private function onMove(w: Int, x:Int, y:Int, z:Int):Void {
        trace(w);
        trace(x);
        trace(y);
        trace(z);
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
        notifier.notify(EventNames.ENTER_GAME_LOOP, null);

        xPos--;
        viewPort.x = xPos;

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
