import massive.munit.TestSuite;

import integration.net.CPPSocketInputOutputStreamIntegrationTest;
import world.UnitTypeEntityFactoryTest;
import world.two.SubscriberZSortingManagerTest;
import world.two.GameWorld2DTest;
import world.two.ViewPort2DTest;
import world.TypeResolvedEntityFactoryTest;
import net.CPPSocketInputOutputStreamTest;
import display.layer.RenderableLayerManagerTest;
import display.two.TwoDimDisplayNodeContainerTest;
import display.two.TwoDimInteractiveDisplayTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeTest;
import service.ConnectedPlayerServiceTest;
import input.DisplayEventMouseInputHandlerDelegateTest;
import input.tools.AssignedGameInputToolsTest;
import input.tools.BattleKeyboardToolTest;
import input.tools.DefaultBattlePointingToolTest;
import input.kha.KhaPointerEventManagerTest;
import input.kha.KhaKeyboardInputSourceListenerTest;
import input.BattleGameWorldInteractionManagerTest;
import handler.actions.UnitCreatedActionTest;
import handler.actions.PlayerConnectedActionTest;
import handler.actions.UnitCastedSpellActionTest;
import handler.actions.HeroCreatedActionTest;
import handler.actions.UnitMoveActionTest;
import handler.actions.UnitCastingSpellActionTest;
import handler.SocketStreamHandlerTest;
import gameentities.fx.MappedEffectManagerTest;
import gameentities.fx.UnitSpawnFXTest;
import gameentities.BattleUnitInteractionManagerTest;
import gameentities.BaseGameObjectTest;
import gameentities.InteractiveGameObjectTest;
import gameentities.StaticUnitFactoryTest;
import gameentities.GameLoopViewPortTrackerTest;
import gameentities.SingleHeroInteractionTest;
import gameentities.AnimatedPoseDisplayTest;
import util.MappedSubscriberTest;
import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import animation.tween.MultiTweenControllerTest;
import animation.tween.SimpleTweenTest;
import animation.tween.target.SimpleTweenTargetTest;
import animation.SpriteAnimationTest;
import animation.SpriteAnimationControllerTest;
import animation.SubscribedAnimationManagerTest;
import animation.SpriteAnimationWithEventsTest;
import core.ObjectFactoryTest;
import lookup.ReflectStrategyMapTest;
import lookup.MapHandlerLookupTest;
import geom.RectangleTest;
import geom.PointTest;
import sound.SoundLayerContainerTest;
import sound.kha.KhaSoundHandleTest;
import sound.SimpleSoundManagerTest;
import collections.UniqueCollectionTest;
import collections.QuadTreeNodeLeafTest;
import collections.QuadTreeTest;
import assets.kha.KhaAssetsAssetLoaderTest;
import assets.AssetLoaderAssetLocatorTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(integration.net.CPPSocketInputOutputStreamIntegrationTest);
		add(world.UnitTypeEntityFactoryTest);
		add(world.two.SubscriberZSortingManagerTest);
		add(world.two.GameWorld2DTest);
		add(world.two.ViewPort2DTest);
		add(world.TypeResolvedEntityFactoryTest);
		add(net.CPPSocketInputOutputStreamTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(display.two.TwoDimInteractiveDisplayTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeTest);
		add(service.ConnectedPlayerServiceTest);
		add(input.DisplayEventMouseInputHandlerDelegateTest);
		add(input.tools.AssignedGameInputToolsTest);
		add(input.tools.BattleKeyboardToolTest);
		add(input.tools.DefaultBattlePointingToolTest);
		add(input.kha.KhaPointerEventManagerTest);
		add(input.kha.KhaKeyboardInputSourceListenerTest);
		add(input.BattleGameWorldInteractionManagerTest);
		add(handler.actions.UnitCreatedActionTest);
		add(handler.actions.PlayerConnectedActionTest);
		add(handler.actions.UnitCastedSpellActionTest);
		add(handler.actions.HeroCreatedActionTest);
		add(handler.actions.UnitMoveActionTest);
		add(handler.actions.UnitCastingSpellActionTest);
		add(handler.SocketStreamHandlerTest);
		add(gameentities.fx.MappedEffectManagerTest);
		add(gameentities.fx.UnitSpawnFXTest);
		add(gameentities.BattleUnitInteractionManagerTest);
		add(gameentities.BaseGameObjectTest);
		add(gameentities.InteractiveGameObjectTest);
		add(gameentities.StaticUnitFactoryTest);
		add(gameentities.GameLoopViewPortTrackerTest);
		add(gameentities.SingleHeroInteractionTest);
		add(gameentities.AnimatedPoseDisplayTest);
		add(util.MappedSubscriberTest);
		add(animation.spec.TexturePackerJSONArrayFrameSpecTest);
		add(animation.tween.MultiTweenControllerTest);
		add(animation.tween.SimpleTweenTest);
		add(animation.tween.target.SimpleTweenTargetTest);
		add(animation.SpriteAnimationTest);
		add(animation.SpriteAnimationControllerTest);
		add(animation.SubscribedAnimationManagerTest);
		add(animation.SpriteAnimationWithEventsTest);
		add(core.ObjectFactoryTest);
		add(lookup.ReflectStrategyMapTest);
		add(lookup.MapHandlerLookupTest);
		add(geom.RectangleTest);
		add(geom.PointTest);
		add(sound.SoundLayerContainerTest);
		add(sound.kha.KhaSoundHandleTest);
		add(sound.SimpleSoundManagerTest);
		add(collections.UniqueCollectionTest);
		add(collections.QuadTreeNodeLeafTest);
		add(collections.QuadTreeTest);
		add(assets.kha.KhaAssetsAssetLoaderTest);
		add(assets.AssetLoaderAssetLocatorTest);
	}
}
