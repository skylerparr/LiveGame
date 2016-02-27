package core;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
import minject.Injector;

class ObjectFactoryTest {

    private var injector: Injector;
    private var objectFactory: ObjectFactory;

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
        injector = null;
        objectFactory = null;
    }

    @Test
    public function shouldCreateAnObject():Void {
        injector.getInstance(Sample).throws(new AnyException());

        var sample = objectFactory.createInstance(Sample);
        Assert.isNotNull(sample);
    }

    @Test
    public function shouldCreateAnObjectFromTheInjector(): Void {
        var sample: Sample = new Sample();
        injector.getInstance(Sample).returns(sample);

        var sample2 = objectFactory.createInstance(Sample);
        Assert.areEqual(sample, sample2);
    }

    @Test
    public function shouldCreateAnObjectAndInject(): Void {
        injector.getInstance(Sample).throws(new AnyException());

        var sample = objectFactory.createInstance(Sample);
        Assert.isNotNull(sample);
        injector.injectInto(sample).verify();
    }

    @Test
    public function shouldCreateAnObjectWithConstructorArgs(): Void {
        injector.getInstance(SampleWithArgs).throws(new AnyException());

        var sample: SampleWithArgs = objectFactory.createInstance(SampleWithArgs, ["hello", 42]);
        Assert.areEqual("hello", sample.arg1);
        Assert.areEqual(42, sample.arg2);
    }

    @Test
    public function shouldCreateObjectIfArgsIsNull(): Void {
        injector.getInstance(Sample).throws(new AnyException());

        var sample = objectFactory.createInstance(Sample, null);
        Assert.isNotNull(sample);
    }

    @Test
    public function shouldCallInitImplicitlyOnBaseObjects(): Void {
        injector.getInstance(SampleBase).throws(new AnyException());

        var sample: SampleBase = objectFactory.createInstance(SampleBase);
        Assert.isTrue(sample.initialized);
    }
}

class Sample {

    public function new(){

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

    public function new(){

    }

    public function init():Void {
        initialized = true;
    }

    public function dispose():Void {
    }

}

class AnyException {
    public function new(){

    }

}