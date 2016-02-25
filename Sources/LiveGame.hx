package;
import kha.System;
import kha.ScreenRotation;
import kha.Canvas;
import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.Font;
import kha.Assets;
import kha.Framebuffer;

class LiveGame {

    private var initialized: Bool = false;
    private var font: Font;
    private var grumpyCat: Image;
    private var xPos: Float = 0;

    private var backbuffer: Image;

    public function new() {
        backbuffer = Image.createRenderTarget(800, 600);

        Assets.loadFont("helveticaneue_light", onFontLoad);
        Assets.loadImage("grumpy_cat_nope", onImageLoaded);
    }

    private function onFontLoad(font:Font):Void {
        this.font = font;
        checkLoaded();
    }

    private function onImageLoaded(image:Image):Void {
        grumpyCat = image;
        checkLoaded();
    }

    private inline function checkLoaded():Void {
        if(font != null && grumpyCat != null) {
            initialized = true;
        }
    }

    public function render(framebuffer:Framebuffer):Void {
        if(!initialized) {
            return;
        }

        var g = backbuffer.g2;
        g.begin(false);
        g.drawImage(grumpyCat, 0, 0);
        g.end();

        var g = framebuffer.g2;

        g.begin();

        //things will be rendered on bottom
        Scaler.scale(backbuffer, framebuffer, System.screenRotation);

        g.font = font;
        g.fontSize = 32;
        g.color = Color.Pink;
        g.drawString("Hello world", xPos, 0);

        //things will be rendered on top

        g.end();

        xPos++;
        if(xPos > 800) {
            xPos = 0;
        }
    }

    public function update():Void {

    }
}
