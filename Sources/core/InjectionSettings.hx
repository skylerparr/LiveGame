package core;
import animation.tween.Tween;
import animation.tween.SimpleTween;
import animation.tween.MultiTweenController;
import animation.tween.TweenController;
import service.ConnectedPlayerService;
import service.PlayerService;
import handler.SocketStreamHandler;
import lookup.MapHandlerLookup;
import handler.HandlerLookup;
import lookup.ReflectStrategyMap;
import handler.StrategyMap;
import handler.StreamHandler;
import net.TCPSocketConnector;
import io.InputOutputStream;
import net.CPPSocketInputOutputStream;
import net.CPPTCPSocket;
import net.TCPSocket;
import assets.SoundAsset;
import assets.kha.KhaSoundAsset;
import assets.kha.KhaImageAsset;
import assets.ImageAsset;
import assets.kha.KhaTextAsset;
import assets.TextAsset;
import assets.AssetLoaderAssetLocator;
import assets.AssetLocator;
import assets.kha.KhaAssetsAssetLoader;
import assets.AssetLoader;
import error.TraceLogger;
import error.Logger;
import gameentities.NecroDisplay;
import gameentities.NecroGameObject;
import gameentities.WizardDisplay;
import gameentities.WizardGameObject;
import world.TypeResolvedEntityFactory;
import units.EntityFactory;
import world.two.GameWorld2D;
import world.GameWorld;
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

        injector.mapSingletonOf(Logger, TraceLogger);
        var assetLoader: AssetLoader = objectFactory.createInstance(KhaAssetsAssetLoader);
        injector.mapValue(AssetLoader, assetLoader);

        var assetLocator: AssetLocator = objectFactory.createInstance(AssetLoaderAssetLocator);
        injector.mapValue(AssetLocator, assetLocator);

        var container: KhaSprite = objectFactory.createInstance(KhaSprite);
        var renderer: Kha2DRenderer = objectFactory.createInstance(Kha2DRenderer);
        renderer.container = container;
        var layerManager: RenderableLayerManager = objectFactory.createInstance(RenderableLayerManager, [container]);

        injector.mapClass(TextAsset, KhaTextAsset);
        injector.mapClass(ImageAsset, KhaImageAsset);
        injector.mapClass(SoundAsset, KhaSoundAsset);

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

        injector.mapValue(LayerManager, layerManager, "ui");
        injector.mapValue(LayerManager, gameWorldLayerManager, "world");
        injector.mapValue(Renderer, renderer);

        Kha2DRenderer.fonts = fonts;

        var subscribeNotifer: MappedSubscriber = objectFactory.createInstance(MappedSubscriber);
        injector.mapValue(Subscriber, subscribeNotifer);
        injector.mapValue(EventNotifier, subscribeNotifer);

        #if cpp
        var animationManager: animation.ThreadedAnimationManager = objectFactory.createInstance(animation.ThreadedAnimationManager);
        #else
        var animationManager: SubscribedAnimationManager = objectFactory.createInstance(SubscribedAnimationManager);
        #end
        injector.mapValue(AnimationManager, animationManager);

        injector.mapClass(AnimationController, SpriteAnimationController);

        injector.mapValue(TweenController, objectFactory.createInstance(MultiTweenController));
        injector.mapClass(Tween, SimpleTween);

        var viewPort: ViewPort2D = objectFactory.createInstance(ViewPort2D, [viewPortContainer]);
        injector.mapValue(ViewPort, viewPort);

        var entityFactory: TypeResolvedEntityFactory = objectFactory.createInstance(TypeResolvedEntityFactory);
        injector.mapValue(EntityFactory, entityFactory);

        entityFactory.mapTypeToType(WizardGameObject, WizardDisplay);
        entityFactory.mapTypeToType(NecroGameObject, NecroDisplay);

        var gameWorld: GameWorld2D = objectFactory.createInstance(GameWorld2D);
        injector.mapValue(GameWorld, gameWorld);

        var fps: Fps = objectFactory.createInstance(Fps);
        injector.mapValue(Fps, fps);

        var playerService: PlayerService = objectFactory.createInstance(ConnectedPlayerService);
        injector.mapValue(PlayerService, playerService);

        injector.mapSingletonOf(TCPSocket, CPPTCPSocket);
        var socketIOStream: CPPSocketInputOutputStream = objectFactory.createInstance(CPPSocketInputOutputStream);

        subscribeNotifer.subscribe(EventNames.ENTER_GAME_LOOP, function(): Void {
            socketIOStream.update();
        });

        injector.mapValue(InputOutputStream, socketIOStream);
        injector.mapValue(TCPSocketConnector, socketIOStream);

        injector.mapValue(ApplicationSettings, objectFactory.createInstance(MapApplicationSettings));
        injector.mapValue(StrategyMap, objectFactory.createInstance(ReflectStrategyMap));
        injector.mapValue(HandlerLookup, objectFactory.createInstance(MapHandlerLookup));
        injector.mapValue(StreamHandler, objectFactory.createInstance(SocketStreamHandler));

        objectFactory.createInstance(Playground);
    }
}
