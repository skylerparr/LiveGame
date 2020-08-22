package game;

import massive.munit.Assert;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class LocalGameLogicTest {
  private var localGameLogic: LocalGameLogic;

  @Before
  public function setup() {
    localGameLogic = new LocalGameLogic();
  }

  @After
  public function tearDown() {
  }

  @Test
  public function shouldBeTrue(): Void {
    Assert.isNotNull(localGameLogic);
  }
}