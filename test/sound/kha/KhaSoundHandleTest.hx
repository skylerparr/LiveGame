package sound.kha;

import util.EventNotifier;
import util.MappedSubscriber;
import util.Subscriber;
import core.ObjectCreator;
import sound.kha.mocks.AudioChannel;
import assets.SoundAsset;
import assets.AssetLoader;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class KhaSoundHandleTest {

    private var soundHandle: KhaSoundHandle;
    private var sound: AudioChannel;
    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;

    public function new() {

    }

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        subscriber = new MappedSubscriber();
//        subscriber.init();
//        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        sound = mock(AudioChannel);

        soundHandle = new KhaSoundHandle(sound);
//        soundHandle.objectCreator = objectCreator;
        soundHandle.init();
    }

    @After
    public function tearDown():Void {
        soundHandle = null;
    }

    @Test
    public function shouldPlaySound(): Void {
        soundHandle.play();

        sound.play().verify();
    }

    @Test
    public function shouldNotPlaySoundIsNull(): Void {
        initializeWithNull();
        soundHandle.play();

        sound.play().verify(0);
    }

    @Test
    public function shouldNotPlaySoundIfAlreadyPlaying(): Void {
        soundHandle.play();
        soundHandle.play();
        soundHandle.play();
        soundHandle.play();

        sound.play().verify(1);
    }

    @Test
    public function shouldPauseSound(): Void {
        soundHandle.play();
        soundHandle.pause();

        sound.pause().verify();
    }
    
    @Test
    public function shouldNotPauseSoundIfNotPlaying(): Void {
        soundHandle.pause();

        sound.pause().verify(0);
    }

    @Test
    public function shouldResumeSound(): Void {
        soundHandle.play();
        soundHandle.pause();
        soundHandle.resume();

        sound.play().verify(2);
    }

    @Test
    public function shouldNotResumeIfAlreadyPlaying(): Void {
        soundHandle.play();
        soundHandle.resume();

        sound.play().verify(1);
    }

    @Test
    public function shouldNotResumeIfSoundIsNull(): Void {
        initializeWithNull();
        soundHandle.resume();

        sound.play().verify(0);
    }

    @Test
    public function shouldStopSound(): Void {
        soundHandle.play();
        soundHandle.stop();
        sound.stop().verify();
    }

    @Test
    public function shouldNotStopSoundIfNotPlaying(): Void {
        soundHandle.stop();
        sound.stop().verify(0);
    }

    @Test
    public function shouldNotStopIfSoundIsNull(): Void {
        initializeWithNull();
        soundHandle.stop();
        sound.stop().verify(0);
    }

    @Test
    public function shouldGetLength(): Void {
        sound.length.returns(43.41);
        Assert.areEqual(43.41, soundHandle.length);
    }

    @Test
    public function shouldGetPosition(): Void {
        sound.position.returns(8953.348);
        Assert.areEqual(8953.348, soundHandle.position);
    }

    @Test
    public function shouldNotSetPositionBecauseItIsNotSupported(): Void {
        sound.position.returns(32.53);
        soundHandle.position = 438.34;
        sound.set_position(438.34).verify(0);

        Assert.areEqual(32.53, soundHandle.position);
    }

    @Test
    public function shouldGetTheVolume(): Void {
        sound.volume.returns(0.65);
        Assert.areEqual(0.65, soundHandle.volume);
    }

    @Test
    public function shouldSetTheVolume(): Void {
        soundHandle.volume = 0.23;
        sound.set_volume(0.23).verify();
    }

    @Test
    public function shouldNotSetVolumePassed1(): Void {
        soundHandle.volume = 321.23;
        sound.set_volume(1).verify();
    }

    @Test
    public function shouldNotSetVolmeBelow0(): Void {
        soundHandle.volume = -321.23;
        sound.set_volume(0).verify();
    }

    @Test
    public function shouldNotMutateSoundIfNull(): Void {
        initializeWithNull();
        soundHandle.volume = 321.23;
        soundHandle.position;
        soundHandle.length;

        Assert.isTrue(true);
    }

//    @Test
//    public function shouldCallStartHandlerWhenMusicStarts(): Void {
//        soundHandle.onPlay(function(): Void {
//
//        });
//        soundHandle.play();
//
//        subscriber.subscribe("soundPlayed", cast any).verify();
//        subscriber.notify("soundPlayed", null).verify();
//    }

    private function initializeWithNull():Void {
        soundHandle = new KhaSoundHandle(null);
        soundHandle.init();
    }
}