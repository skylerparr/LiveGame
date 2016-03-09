package core;
import scenes.playground.Playground;
import display.Renderer;
import display.two.kha.KhaTextFieldNode;
import display.TextFieldNode;
import display.DisplayNodeContainer;
import display.two.kha.KhaBitmapNode;
import display.BitmapNode;
import display.LayerManager;
import display.two.kha.Kha2DRenderer;
import display.two.kha.KhaSprite;
import display.layer.RenderableLayerManager;
import kha.Font;
import minject.Injector;
import kha.Image;
class InjectionSettings {
    public var injector: Injector = new Injector();

    public function new(backbuffer: Image, fonts: Map<String, Font>) {
        ObjectFactory.injector = injector;

        var objectFactory: ObjectFactory = new ObjectFactory();
        injector.mapValue(ObjectCreator, objectFactory);
        injector.mapValue(kha.graphics2.Graphics, backbuffer.g2);

        var container: KhaSprite = objectFactory.createInstance(KhaSprite);
        var renderer: Kha2DRenderer = objectFactory.createInstance(Kha2DRenderer, [container]);

        var layerManager: RenderableLayerManager = objectFactory.createInstance(RenderableLayerManager, [container]);

        container = objectFactory.createInstance(KhaSprite);
        layerManager.addLayerByName("bottom", container);

        container = objectFactory.createInstance(KhaSprite);
        layerManager.addLayerByName("middle", container);

        container = objectFactory.createInstance(KhaSprite);
        layerManager.addLayerByName("top", container);

        injector.mapValue(LayerManager, layerManager);
        injector.mapValue(Renderer, renderer);

        Kha2DRenderer.fonts = fonts;

        injector.mapClass(BitmapNode, KhaBitmapNode);
        injector.mapClass(DisplayNodeContainer, KhaSprite);
        injector.mapClass(TextFieldNode, KhaTextFieldNode);

        objectFactory.createInstance(Playground);
    }
}
