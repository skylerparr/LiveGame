import massive.munit.TestSuite;

import core.ObjectFactoryTest;
import display.layer.RenderableLayerManagerTest;
import display.two.kha.Kha2DRendererTest;
import display.two.TwoDimDisplayNodeContainerTest;
import util.MappedSubscriberTest;
import world.two.ViewPort2DTest;

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
		add(display.layer.RenderableLayerManagerTest);
		add(display.two.kha.Kha2DRendererTest);
		add(display.two.TwoDimDisplayNodeContainerTest);
		add(util.MappedSubscriberTest);
		add(world.two.ViewPort2DTest);
	}
}
