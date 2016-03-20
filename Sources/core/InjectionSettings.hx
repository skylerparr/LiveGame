package core;
import animation.ThreadedAnimationManager;
import animation.SpriteAnimationController;
import animation.AnimationController;
import constants.EventNames;
import animation.SubscribedAnimationManager;
import animation.AnimationManager;
import animation.SpriteAnimation;
import animation.Animation;
import world.two.ViewPort2D;
import world.ViewPort;
import constants.LayerNames;
import util.Fps;
import util.EventNotifier;
import util.MappedSubscriber;
import util.Subscriber;
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

        injector.mapClass(BitmapNode, KhaBitmapNode);
        injector.mapClass(DisplayNodeContainer, KhaSprite);
        injector.mapClass(TextFieldNode, KhaTextFieldNode);
        injector.mapClass(Animation, SpriteAnimation);

        var viewPortContainer: DisplayNodeContainer = objectFactory.createInstance(DisplayNodeContainer);
        var gameWorldLayerManager: RenderableLayerManager = objectFactory.createInstance(RenderableLayerManager, [viewPortContainer]);

        container = objectFactory.createInstance(DisplayNodeContainer);
        gameWorldLayerManager.addLayerByName(LayerNames.TERRAIN, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        gameWorldLayerManager.addLayerByName(LayerNames.GAME_OBJECTS, container);

        layerManager.addLayerByName(LayerNames.GAME_WORLD, viewPortContainer);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName("bottom", container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName("middle", container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName("top", container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName(LayerNames.DEBUG, container);

        injector.mapValue(LayerManager, layerManager);
        injector.mapValue(LayerManager, gameWorldLayerManager, "gameWorld");
        injector.mapValue(Renderer, renderer);

        Kha2DRenderer.fonts = fonts;

        var subscribeNotifer: MappedSubscriber = objectFactory.createInstance(MappedSubscriber);
        injector.mapValue(Subscriber, subscribeNotifer);
        injector.mapValue(EventNotifier, subscribeNotifer);

        #if cpp
        var animationManager: ThreadedAnimationManager = objectFactory.createInstance(ThreadedAnimationManager, [EventNames.ENTER_GAME_LOOP]);
        #else
        var animationManager: SubscribedAnimationManager = objectFactory.createInstance(SubscribedAnimationManager, [EventNames.ENTER_GAME_LOOP]);
        #end
        injector.mapValue(AnimationManager, animationManager);

        injector.mapClass(AnimationController, SpriteAnimationController);

        var viewPort: ViewPort2D = objectFactory.createInstance(ViewPort2D, [viewPortContainer]);
        injector.mapValue(ViewPort, viewPort);

        var fps: Fps = objectFactory.createInstance(Fps);
        injector.mapValue(Fps, fps);

        objectFactory.createInstance(Playground);
    }
}
