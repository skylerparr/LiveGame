package;
import kha.Color;
import kha.Font;
import kha.Assets;
import kha.Framebuffer;

class LiveGame {

    private var font: Font;

    public function new() {
        Assets.loadFont("helveticaneue_light", onFontLoad);
    }

    private function onFontLoad(font:Font):Void {
        this.font = font;
    }

    public function render(framebuffer:Framebuffer):Void {
        var g = framebuffer.g2;

        g.begin();
        g.font = font;
        g.fontSize = 32;
        g.color = Color.Pink;
        g.drawString("Hello world", 0, 0);
        g.end();
    }

    public function update():Void {
    }
}
