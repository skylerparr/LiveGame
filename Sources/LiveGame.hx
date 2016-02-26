package;
import kha.Scheduler;
import kha.Assets;
import kha.System;
import kha.ScreenRotation;
import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.Framebuffer;

class LiveGame {

    private static inline var FRAME_SIZE: Float = 64;
    private static inline var FRAME_COUNT: Float = 3;
    private static inline var FRAME_TIME: UInt = 60;

    private var initialized: Bool = false;
    private var xPos: Float = 0;
    private var yPos: Float = 0;

    private var wizard: Image;
    private var backbuffer: Image;

    private var currentTime: Float = 0;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);

        currentTime = getNow();

        Assets.loadImage("wizard", onWizardLoaded);
    }

    private function onWizardLoaded(image: Image): Void {
        wizard = image;
        checkLoaded();
    }

    private inline function checkLoaded():Void {
        if(wizard != null) {
            initialized = true;
        }
    }

    public function render(framebuffer:Framebuffer):Void {
        if(!initialized) {
            return;
        }

        var g = backbuffer.g2;
        g.begin();
        g.drawSubImage(wizard, 0, 0, xPos, yPos, FRAME_SIZE, FRAME_SIZE);
        g.end();

        var g = framebuffer.g2;

        g.begin();

        Scaler.scale(backbuffer, framebuffer, System.screenRotation);

        g.end();

        var now: Float = getNow();
        if(now < currentTime + FRAME_TIME) {
            return;
        }
        currentTime = getNow();

        xPos += FRAME_SIZE;
        if(xPos > FRAME_COUNT * FRAME_SIZE) {
            xPos = 0;
            yPos += FRAME_SIZE;

            if(yPos > FRAME_COUNT * FRAME_SIZE) {
                yPos = 0;
            }
        }
    }

    private inline function getNow(): Float {
        return Scheduler.time() * 1000;
    }

    public function update():Void {

    }
}
