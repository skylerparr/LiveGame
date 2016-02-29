package core;

import minject.Injector;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class ObjectFactoryTest {

    private var objectFactory: ObjectFactory;
    private var injector: Injector;

    public function new() {

    }

    @Before
    public function setup():Void {
        injector = mock(Injector);
        ObjectFactory.injector = injector;

        objectFactory = new ObjectFactory();
    }

    @After
    public function tearDown():Void {
        objectFactory = null;
        injector = null;
    }

    @Test
    public function shouldCreateAnInstanceFromAClass(): Void {
        injector.getInstance(Sample).throws(new AnyException());

        var sample = objectFactory.createInstance(Sample);
        Assert.isNotNull(sample);
    }

    @Test
    public function shouldCreateAnInstanceWithConstructorArgs(): Void {
        injector.getInstance(SampleWithArgs).throws("broken");

        var sample: SampleWithArgs = objectFactory.createInstance(SampleWithArgs, ["hello", 42]);
        Assert.areEqual("hello", sample.arg1);
        Assert.areEqual(42, sample.arg2);
    }

    @Test
    public function shouldCreateTheObjectFromTheInjector(): Void {
        var retVal: Sample = new Sample();
        injector.getInstance(Sample).returns(retVal);

        var sample: Sample = objectFactory.createInstance(Sample);
        Assert.isNotNull(sample);
        injector.getInstance(Sample).verify();
    }

    @Test
    public function shouldInjectIntoCreatedClass(): Void {
        injector.getInstance(Sample).throws(new AnyException());

        var sample = objectFactory.createInstance(Sample);
        Assert.isNotNull(sample);

        injector.injectInto(sample).verify();
    }

    @Test
    public function shouldCallInitOnBaseObjects(): Void {
        injector.getInstance(SampleBase).throws(new AnyException());

        var sample: SampleBase = objectFactory.createInstance(SampleBase);
        Assert.isNotNull(sample);

        Assert.isTrue(sample.initialized);
    }
}

class Sample {
    public function new() {

    }
}

class SampleWithArgs {

    public var arg1: String;
    public var arg2: Int;

    public function new(arg1: String, arg2: Int) {
        this.arg1 = arg1;
        this.arg2 = arg2;
    }
}

class SampleBase implements BaseObject {
    public var initialized: Bool = false;
    public function new() {

    }

    public function init():Void {
        initialized = true;
    }

    public function dispose():Void {
    }
}

class AnyException {
    public function new() {

    }
}