import massive.munit.TestSuite;

import core.ObjectFactoryTest;
import lookup.MapHandlerLookupTest;
import lookup.ReflectStrategyMapTest;
import integration.net.CPPSocketInputOutputStreamIntegrationTest;
import assets.kha.KhaAssetsAssetLoaderTest;
import assets.AssetLoaderAssetLocatorTest;
import net.CPPSocketInputOutputStreamTest;
import collections.QuadTreeTest;
import collections.QuadTreeNodeLeafTest;
import collections.UniqueCollectionTest;
import handler.actions.UnitCreatedActionTest;
import handler.actions.UnitCastedSpellActionTest;
import handler.actions.UnitMoveActionTest;
import handler.actions.UnitCastingSpellActionTest;
import handler.actions.PlayerConnectedActionTest;
import handler.actions.HeroCreatedActionTest;
import handler.SocketStreamHandlerTest;
import gameentities.InteractiveGameObjectTest;
import gameentities.SingleHeroInteractionTest;
import gameentities.BaseGameObjectTest;
import gameentities.fx.MappedEffectManagerTest;
import gameentities.fx.UnitSpawnFXTest;
import gameentities.AnimatedPoseDisplayTest;
import gameentities.BattleUnitInteractionManagerTest;
import gameentities.StaticUnitFactoryTest;
import gameentities.GameLoopViewPortTrackerTest;
import animation.SpriteAnimationControllerTest;
import animation.SpriteAnimationTest;
import animation.SpriteAnimationWithEventsTest;
import animation.tween.target.SimpleTweenTargetTest;
import animation.tween.MultiTweenControllerTest;
import animation.tween.SimpleTweenTest;
import animation.SubscribedAnimationManagerTest;
import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import geom.RectangleTest;
import geom.PointTest;
import sound.kha.KhaSoundHandleTest;
import sound.SoundLayerContainerTest;
import sound.SimpleSoundManagerTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeTest;
import display.two.TwoDimDisplayNodeContainerTest;
import display.two.TwoDimInteractiveDisplayTest;
import world.TypeResolvedEntityFactoryTest;
import world.UnitTypeEntityFactoryTest;
import world.two.GameWorld2DTest;
import world.two.SubscriberZSortingManagerTest;
import world.two.ViewPort2DTest;
import service.ConnectedPlayerServiceTest;
import input.BattleGameWorldInteractionManagerTest;
import input.kha.KhaPointerEventManagerTest;
import input.kha.KhaKeyboardInputSourceListenerTest;
import input.DisplayEventMouseInputHandlerDelegateTest;
import input.tools.BattleKeyboardToolTest;
import input.tools.DefaultBattlePointingToolTest;
import input.tools.AssignedGameInputToolsTest;
import util.MappedSubscriberTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(core.ObjectFactoryTest);
		add(lookup.MapHandlerLookupTest);
		add(lookup.ReflectStrategyMapTest);
		add(integration.net.CPPSocketInputOutputStreamIntegrationTest);
		add(assets.kha.KhaAssetsAssetLoaderTest);
		add(assets.AssetLoaderAssetLocatorTest);
		add(net.CPPSocketInputOutputStreamTest);
		add(collections.QuadTreeTest);
		add(collections.QuadTreeNodeLeafTest);
		add(collections.UniqueCollectionTest);
		add(handler.actions.UnitCreatedActionTest);
		add(handler.actions.UnitCastedSpellActionTest);
		add(handler.actions.UnitMoveActionTest);
		add(handler.actions.UnitCastingSpellActionTest);
		add(handler.actions.PlayerConnectedActionTest);
		add(handler.actions.HeroCreatedActionTest);
		add(handler.SocketStreamHandlerTest);
		add(gameentities.InteractiveGameObjectTest);
		add(gameentities.SingleHeroInteractionTest);
		add(gameentities.BaseGameObjectTest);
		add(gameentities.fx.MappedEffectManagerTest);
		add(gameentities.fx.UnitSpawnFXTest);
		add(gameentities.AnimatedPoseDisplayTest);
		add(gameentities.BattleUnitInteractionManagerTest);
		add(gameentities.StaticUnitFactoryTest);
		add(gameentities.GameLoopViewPortTrackerTest);
		add(animation.SpriteAnimationControllerTest);
		add(animation.SpriteAnimationTest);
		add(animation.SpriteAnimationWithEventsTest);
		add(animation.tween.target.SimpleTweenTargetTest);
		add(animation.tween.MultiTweenControllerTest);
		add(animation.tween.SimpleTweenTest);
		add(animation.SubscribedAnimationManagerTest);
		add(animation.spec.TexturePackerJSONArrayFrameSpecTest);
		add(geom.RectangleTest);
		add(geom.PointTest);
		add(sound.kha.KhaSoundHandleTest);
		add(sound.SoundLayerContainerTest);
		add(sound.SimpleSoundManagerTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(display.two.TwoDimInteractiveDisplayTest);
		add(world.TypeResolvedEntityFactoryTest);
		add(world.UnitTypeEntityFactoryTest);
		add(world.two.GameWorld2DTest);
		add(world.two.SubscriberZSortingManagerTest);
		add(world.two.ViewPort2DTest);
		add(service.ConnectedPlayerServiceTest);
		add(input.BattleGameWorldInteractionManagerTest);
		add(input.kha.KhaPointerEventManagerTest);
		add(input.kha.KhaKeyboardInputSourceListenerTest);
		add(input.DisplayEventMouseInputHandlerDelegateTest);
		add(input.tools.BattleKeyboardToolTest);
		add(input.tools.DefaultBattlePointingToolTest);
		add(input.tools.AssignedGameInputToolsTest);
		add(util.MappedSubscriberTest);
	}
}
