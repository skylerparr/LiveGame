package core;
import game.GameLogicInputHandler;
import game.GameLogicInput;
import game.LocalGameLogic;
import game.GameLogic;
import haxe.io.BytesOutput;
import handler.LocalStreamHandler;
import constants.ScreenConstants;
import input.GameWorldInteractionManager;
import input.BattleGameWorldInteractionManager;
import gameentities.fx.MappedEffectManager;
import gameentities.fx.EffectManager;
import animation.SpriteAnimationWithEvents;
import animation.AnimationWithEvents;
import gameentities.StaticUnitFactory;
import gameentities.UnitFactory;
import world.UnitTypeEntityFactory;
import service.StaticSpellService;
import service.SpellService;
import gameentities.GameLoopViewPortTracker;
import gameentities.ViewPortTracker;
import gameentities.SingleHeroInteraction;
import gameentities.HeroInteraction;
import world.two.WorldPoint2D;
import world.WorldPoint;
import input.tools.BattleKeyboardTool;
import input.PointingInputSourceListener;
import input.GameInputTools;
import input.tools.AssignedGameInputTools;
import input.kha.KhaKeyboardInputSourceListener;
import input.KeyboardInputSourceListener;
import world.two.SubscriberZSortingManager;
import world.two.ZSortingManager;
import gameentities.BattleUnitInteractionManager;
import gameentities.UnitInteractionManager;
import animation.tween.Tween;
import animation.tween.MultiTweenController;
import animation.tween.TweenController;
import animation.tween.SimpleTween;
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
#if (multiplayer && cpp)
import net.CPPSocketInputOutputStream;
import net.CPPTCPSocket;
#else
import net.BufferIOStream;
#end
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
import error.ConsoleLogger;
import error.Logger;
import units.EntityFactory;
import world.two.GameWorld2D;
import world.GameWorldDisplay;
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
import input.PointerEventManager;
import input.DisplayEventMouseInputHandlerDelegate;
import input.DisplayEventMouseInputHandler;
import input.kha.KhaPointerEventManager;
import minject.Injector;
@IgnoreCover
class InjectionSettings {
    public var injector: Injector = new Injector();

#if test
    public function new(backbuffer: Dynamic, fonts: Map<String, Dynamic>) {
    }
#else
    public function new(backbuffer: kha.Image, fonts: Map<String, kha.Font>) {
        ObjectFactory.injector = injector;

        var objectFactory: ObjectFactory = new ObjectFactory();
        injector.mapValue(ObjectCreator, objectFactory);
        injector.mapValue(kha.graphics2.Graphics, backbuffer.g2);

        injector.mapSingletonOf(Logger, ConsoleLogger);
        var assetLoader: AssetLoader = objectFactory.createInstance(KhaAssetsAssetLoader);
        injector.mapValue(AssetLoader, assetLoader);

        var assetLocator: AssetLocator = objectFactory.createInstance(AssetLoaderAssetLocator);
        injector.mapValue(AssetLocator, assetLocator);

        var eventManager: KhaPointerEventManager = objectFactory.createInstance(KhaPointerEventManager);
        injector.mapValue(PointerEventManager, eventManager);
        injector.mapValue(input.PointingInputSourceListener, eventManager);

        var mouseHandlerDelegate: DisplayEventMouseInputHandlerDelegate = objectFactory.createInstance(DisplayEventMouseInputHandlerDelegate);
        injector.mapValue(DisplayEventMouseInputHandler, mouseHandlerDelegate);

        display.two.TwoDimInteractiveDisplay.pointerEventManager = eventManager;

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
        injector.mapClass(AnimationWithEvents, SpriteAnimationWithEvents);
        injector.mapValue(EffectManager, objectFactory.createInstance(MappedEffectManager));

        var viewPortContainer: DisplayNodeContainer = objectFactory.createInstance(DisplayNodeContainer);
        var gameWorldLayerManager: RenderableLayerManager = objectFactory.createInstance(RenderableLayerManager, [viewPortContainer]);

        container = objectFactory.createInstance(DisplayNodeContainer);
        gameWorldLayerManager.addLayerByName(LayerNames.TERRAIN, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        gameWorldLayerManager.addLayerByName(LayerNames.GAME_OBJECTS, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        gameWorldLayerManager.addLayerByName(LayerNames.FX, container);

        layerManager.addLayerByName(LayerNames.GAME_WORLD, viewPortContainer);

        container = objectFactory.createInstance(DisplayNodeContainer);
        container.width = ScreenConstants.screenWidth;
        container.height = ScreenConstants.screenHeight;
        container.mouseChildren = false;
        container.mouseEnabled = true;
        layerManager.addLayerByName(LayerNames.WORLD_INTERACTION, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName(LayerNames.UI, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName(LayerNames.DIALOGS, container);

        container = objectFactory.createInstance(DisplayNodeContainer);
        layerManager.addLayerByName(LayerNames.DEBUG, container);

        injector.mapValue(LayerManager, layerManager, "ui");
        injector.mapValue(LayerManager, gameWorldLayerManager, "world");

        injector.mapValue(Renderer, renderer);

        Kha2DRenderer.fonts = fonts;

        var subscribeNotifer: MappedSubscriber = objectFactory.createInstance(MappedSubscriber);
        injector.mapValue(Subscriber, subscribeNotifer);
        injector.mapValue(EventNotifier, subscribeNotifer);

        injector.mapClass(WorldPoint, WorldPoint2D);
        #if cpp
        var animationManager: animation.ThreadedAnimationManager = objectFactory.createInstance(animation.ThreadedAnimationManager);
        #else
        var animationManager: SubscribedAnimationManager = objectFactory.createInstance(SubscribedAnimationManager);
        animationManager.eventName = EventNames.ENTER_GAME_LOOP;
        #end
        injector.mapValue(AnimationManager, animationManager);

        injector.mapClass(AnimationController, SpriteAnimationController);

        injector.mapValue(TweenController, objectFactory.createInstance(MultiTweenController));
        injector.mapClass(Tween, SimpleTween);

        var viewPort: ViewPort2D = objectFactory.createInstance(ViewPort2D, [viewPortContainer]);
        viewPort.width = ScreenConstants.screenWidth;
        viewPort.height = ScreenConstants.screenHeight;
        injector.mapValue(ViewPort, viewPort);

        injector.mapValue(ViewPortTracker, objectFactory.createInstance(GameLoopViewPortTracker));

        var heroInteraction: SingleHeroInteraction = objectFactory.createInstance(SingleHeroInteraction);
        injector.mapValue(HeroInteraction, heroInteraction);

        injector.mapValue(UnitFactory, objectFactory.createInstance(StaticUnitFactory));
        injector.mapValue(EntityFactory, objectFactory.createInstance(UnitTypeEntityFactory));

        var gameWorld: GameWorld2D = objectFactory.createInstance(GameWorld2D);
        injector.mapValue(GameWorldDisplay, gameWorld);

        var zSorting: SubscriberZSortingManager = objectFactory.createInstance(SubscriberZSortingManager);
        zSorting.updateEvent = EventNames.ENTER_GAME_LOOP;
        injector.mapValue(ZSortingManager, zSorting);

        var unitInteractionManager: UnitInteractionManager = cast objectFactory.createInstance(BattleUnitInteractionManager);
        injector.mapValue(UnitInteractionManager, unitInteractionManager);

        var fps: Fps = objectFactory.createInstance(Fps);
        injector.mapValue(Fps, fps);

        var playerService: PlayerService = objectFactory.createInstance(ConnectedPlayerService);
        injector.mapValue(PlayerService, playerService);

        injector.mapValue(SpellService, objectFactory.createInstance(StaticSpellService));

        #if (multiplayer && cpp)
        injector.mapSingletonOf(TCPSocket, CPPTCPSocket);
        var socketIOStream: CPPSocketInputOutputStream = objectFactory.createInstance(CPPSocketInputOutputStream);

        subscribeNotifer.subscribe(EventNames.ENTER_GAME_LOOP, function(): Void {
            socketIOStream.update();
        });

        injector.mapValue(InputOutputStream, socketIOStream);
        injector.mapValue(TCPSocketConnector, socketIOStream);
        #else
        var bytesOutput: BytesOutput = new BytesOutput();
        var localStream: BufferIOStream = objectFactory.createInstance(BufferIOStream, [bytesOutput]);
        injector.mapValue(InputOutputStream, localStream);
        #end

        injector.mapValue(ApplicationSettings, objectFactory.createInstance(MapApplicationSettings));
        injector.mapValue(StrategyMap, objectFactory.createInstance(ReflectStrategyMap));
        injector.mapValue(HandlerLookup, objectFactory.createInstance(MapHandlerLookup));
        #if (multiplayer && cpp)
        var streamHandler: SocketStreamHandler = objectFactory.createInstance(SocketStreamHandler);
        #else
        injector.mapValue(GameLogic, objectFactory.createInstance(LocalGameLogic));
        injector.mapSingletonOf(GameLogicInput, GameLogicInputHandler);
        var streamHandler: LocalStreamHandler = objectFactory.createInstance(LocalStreamHandler);
        #end
        injector.mapValue(StreamHandler, streamHandler);

        heroInteraction.streamHandler = streamHandler;

        var inputTools: AssignedGameInputTools = objectFactory.createInstance(AssignedGameInputTools);
        injector.mapValue(GameInputTools, inputTools);

        var keyboardListener: KhaKeyboardInputSourceListener = objectFactory.createInstance(KhaKeyboardInputSourceListener);
        injector.mapValue(KeyboardInputSourceListener, keyboardListener);

        inputTools.currentTool = objectFactory.createInstance(input.tools.DefaultBattlePointingTool);
        inputTools.keyboardTool = objectFactory.createInstance(BattleKeyboardTool);

        var interactionLayer: DisplayNodeContainer = layerManager.getLayerByName(LayerNames.WORLD_INTERACTION);
        var gameWorldInteractionManager: BattleGameWorldInteractionManager = objectFactory.createInstance(BattleGameWorldInteractionManager);
        gameWorldInteractionManager.interactionContainer = interactionLayer;
        injector.mapValue(GameWorldInteractionManager, gameWorldInteractionManager);

        objectFactory.createInstance(Playground);
#end
    }
}
