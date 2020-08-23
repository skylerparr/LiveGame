package game;

import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class FullGameWorldObjectsTest {
	private var worldObjects: FullGameWorldObjects;

  @Before
  public function setup() {
		worldObjects = new FullGameWorldObjects();
  }

  @After
  public function tearDown() {
  }

  @Test
  public function testExample() {
    Assert.isTrue(true);
  }
}