import massive.munit.TestSuite;

import animation.spec.TexturePackerJSONArrayFrameSpecTest;
import animation.SpriteAnimationControllerTest;
import animation.SpriteAnimationTest;
import animation.SubscribedAnimationManagerTest;
import animation.tween.MultiTweenControllerTest;
import animation.tween.SimpleTweenTest;
import animation.tween.target.SimpleTweenTargetTest;
import assets.AssetLoaderAssetLocatorTest;
import assets.kha.KhaAssetsAssetLoaderTest;
import collections.QuadTreeNodeTest;
import collections.QuadTreeTest;
import collections.UniqueCollectionTest;
import core.ObjectFactoryTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeContainerTest;
import gameentities.AnimatedPoseDisplayTest;
import gameentities.BattleUnitInteractionManagerTest;
import gameentities.fx.MappedEffectManagerTest;
import gameentities.GameLoopViewPortTrackerTest;
import gameentities.SingleHeroInteractionTest;
import geom.RectangleTest;
import handler.actions.UnitCastedSpellActionTest;
import handler.actions.UnitCastingSpellActionTest;
import handler.SocketStreamHandlerTest;
import input.kha.KhaKeyboardInputSourceListenerTest;
import input.kha.KhaMouseInputSourceTest;
import input.tools.BattleKeyboardToolTest;
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
		add(animation.SubscribedAnimationManagerTest);
		add(animation.tween.MultiTweenControllerTest);
		add(animation.tween.SimpleTweenTest);
		add(animation.tween.target.SimpleTweenTargetTest);
		add(assets.AssetLoaderAssetLocatorTest);
		add(assets.kha.KhaAssetsAssetLoaderTest);
		add(collections.QuadTreeNodeTest);
		add(collections.QuadTreeTest);
		add(collections.UniqueCollectionTest);
		add(core.ObjectFactoryTest);
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(gameentities.AnimatedPoseDisplayTest);
		add(gameentities.BattleUnitInteractionManagerTest);
		add(gameentities.fx.MappedEffectManagerTest);
		add(gameentities.GameLoopViewPortTrackerTest);
		add(gameentities.SingleHeroInteractionTest);
		add(geom.RectangleTest);
		add(handler.actions.UnitCastedSpellActionTest);
		add(handler.actions.UnitCastingSpellActionTest);
		add(handler.SocketStreamHandlerTest);
		add(input.kha.KhaKeyboardInputSourceListenerTest);
		add(input.kha.KhaMouseInputSourceTest);
		add(input.tools.BattleKeyboardToolTest);
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
	}
}
