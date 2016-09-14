import massive.munit.TestSuite;

import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import animation.SpriteAnimationControllerTest;
import animation.SpriteAnimationTest;
import animation.SpriteAnimationWithEventsTest;
import animation.SubscribedAnimationManagerTest;
import animation.tween.MultiTweenControllerTest;
import animation.tween.SimpleTweenTest;
import animation.tween.target.SimpleTweenTargetTest;
import assets.AssetLoaderAssetLocatorTest;
import assets.kha.KhaAssetsAssetLoaderTest;
import collections.QuadTreeNodeLeafTest;
import collections.QuadTreeTest;
import collections.UniqueCollectionTest;
import core.ObjectFactoryTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeContainerTest;
import display.two.TwoDimDisplayNodeTest;
import display.two.TwoDimInteractiveDisplayTest;
import gameentities.AnimatedPoseDisplayTest;
import gameentities.BaseGameObjectTest;
import gameentities.BattleUnitInteractionManagerTest;
import gameentities.fx.MappedEffectManagerTest;
import gameentities.fx.UnitSpawnFXTest;
import gameentities.GameLoopViewPortTrackerTest;
import gameentities.InteractiveGameObjectTest;
import gameentities.SingleHeroInteractionTest;
import gameentities.StaticUnitFactoryTest;
import geom.PointTest;
import geom.RectangleTest;
import handler.actions.HeroCreatedActionTest;
import handler.actions.PlayerConnectedActionTest;
import handler.actions.UnitCastedSpellActionTest;
import handler.actions.UnitCastingSpellActionTest;
import handler.actions.UnitCreatedActionTest;
import handler.actions.UnitMoveActionTest;
import handler.SocketStreamHandlerTest;
import input.BattleGameWorldInteractionManagerTest;
import input.DisplayEventMouseInputHandlerDelegateTest;
import input.kha.KhaKeyboardInputSourceListenerTest;
import input.kha.KhaPointerEventManagerTest;
import input.tools.AssignedGameInputToolsTest;
import input.tools.BattleKeyboardToolTest;
import input.tools.DefaultBattlePointingToolTest;
import integration.net.CPPSocketInputOutputStreamIntegrationTest;
import lookup.MapHandlerLookupTest;
import lookup.ReflectStrategyMapTest;
import net.CPPSocketInputOutputStreamTest;
import service.ConnectedPlayerServiceTest;
import sound.kha.KhaSoundHandleTest;
import sound.SimpleSoundManagerTest;
import sound.SoundLayerContainerTest;
import util.MappedSubscriberTest;
import world.two.GameWorld2DTest;
import world.two.SubscriberZSortingManagerTest;
import world.two.ViewPort2DTest;
import world.TypeResolvedEntityFactoryTest;
import world.UnitTypeEntityFactoryTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(animation.spec.TexturePackerJSONArrayFrameSpecTest);
		add(animation.SpriteAnimationControllerTest);
		add(animation.SpriteAnimationTest);
		add(animation.SpriteAnimationWithEventsTest);
		add(animation.SubscribedAnimationManagerTest);
		add(animation.tween.MultiTweenControllerTest);
		add(animation.tween.SimpleTweenTest);
		add(animation.tween.target.SimpleTweenTargetTest);
		add(assets.AssetLoaderAssetLocatorTest);
		add(assets.kha.KhaAssetsAssetLoaderTest);
		add(collections.QuadTreeNodeLeafTest);
		add(collections.QuadTreeTest);
		add(collections.UniqueCollectionTest);
		add(core.ObjectFactoryTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(display.two.TwoDimDisplayNodeTest);
		add(display.two.TwoDimInteractiveDisplayTest);
		add(gameentities.AnimatedPoseDisplayTest);
		add(gameentities.BaseGameObjectTest);
		add(gameentities.BattleUnitInteractionManagerTest);
		add(gameentities.fx.MappedEffectManagerTest);
		add(gameentities.fx.UnitSpawnFXTest);
		add(gameentities.GameLoopViewPortTrackerTest);
		add(gameentities.InteractiveGameObjectTest);
		add(gameentities.SingleHeroInteractionTest);
		add(gameentities.StaticUnitFactoryTest);
		add(geom.PointTest);
		add(geom.RectangleTest);
		add(handler.actions.HeroCreatedActionTest);
		add(handler.actions.PlayerConnectedActionTest);
		add(handler.actions.UnitCastedSpellActionTest);
		add(handler.actions.UnitCastingSpellActionTest);
		add(handler.actions.UnitCreatedActionTest);
		add(handler.actions.UnitMoveActionTest);
		add(handler.SocketStreamHandlerTest);
		add(input.BattleGameWorldInteractionManagerTest);
		add(input.DisplayEventMouseInputHandlerDelegateTest);
		add(input.kha.KhaKeyboardInputSourceListenerTest);
		add(input.kha.KhaPointerEventManagerTest);
		add(input.tools.AssignedGameInputToolsTest);
		add(input.tools.BattleKeyboardToolTest);
		add(input.tools.DefaultBattlePointingToolTest);
		add(integration.net.CPPSocketInputOutputStreamIntegrationTest);
		add(lookup.MapHandlerLookupTest);
		add(lookup.ReflectStrategyMapTest);
		add(net.CPPSocketInputOutputStreamTest);
		add(service.ConnectedPlayerServiceTest);
		add(sound.kha.KhaSoundHandleTest);
		add(sound.SimpleSoundManagerTest);
		add(sound.SoundLayerContainerTest);
		add(util.MappedSubscriberTest);
		add(world.two.GameWorld2DTest);
		add(world.two.SubscriberZSortingManagerTest);
		add(world.two.ViewPort2DTest);
		add(world.TypeResolvedEntityFactoryTest);
		add(world.UnitTypeEntityFactoryTest);
	}
}
