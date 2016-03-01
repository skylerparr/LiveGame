import massive.munit.TestSuite;

import core.ObjectFactoryTest;
import display.two.TwoDimDisplayNodeContainerTest;

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
		add(display.two.TwoDimDisplayNodeContainerTest);
	}
}
