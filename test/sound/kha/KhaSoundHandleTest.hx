package sound.kha;

import util.MappedSubscriber;
import core.ObjectCreator;
import sound.kha.mocks.AudioChannel;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class KhaSoundHandleTest {

    private var soundHandle: KhaSoundHandle;
    private var sound: AudioChannel;
    private var objectCreator: ObjectCreator;
    private var subscriber: MappedSubscriber;

    @Before
    public function setup():Void {
        objectCreator = mock(ObjectCreator);
        subscriber = new MappedSubscriber();
        subscriber.init();
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);
        sound = mock(AudioChannel);

        soundHandle = new KhaSoundHandle(sound);
        soundHandle.objectCreator = objectCreator;
        soundHandle.init();

        Mockatoo.reset(sound);
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
    public function shouldNotSetVolumeAbove1(): Void {
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

    @Test
    public function shouldCallStartHandlerWhenMusicStarts(): Void {
        var callbackCalled: Bool = false;
        soundHandle.subscribeOnPlay(function(): Void {
            callbackCalled = true;
        });
        soundHandle.play();
        Assert.isTrue(callbackCalled);
    }

    @Test
    public function shouldNotCallPlayHandlerIfUnsubscribed(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPlay(callback);
        soundHandle.play();
        soundHandle.unsubscribeOnPlay(callback);
        soundHandle.pause();
        soundHandle.play();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldCallPauseHandler(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPause(callback);
        soundHandle.play();
        soundHandle.pause();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotCallPauseHandlerIfNotSubscribed(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPause(callback);
        soundHandle.play();
        soundHandle.pause();
        soundHandle.unsubscribeOnPause(callback);
        soundHandle.play();
        soundHandle.pause();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldCallStopHandler(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnStop(callback);
        soundHandle.play();
        soundHandle.stop();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotCallStopHandlerIfNotSubscribed(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnStop(callback);
        soundHandle.play();
        soundHandle.stop();
        soundHandle.unsubscribeOnStop(callback);
        soundHandle.play();
        soundHandle.stop();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldCallPlayHandlerIfResumeIsInvoked(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.play();
        soundHandle.subscribeOnPlay(callback);
        soundHandle.pause();
        soundHandle.resume();
        soundHandle.unsubscribeOnPlay(callback);
        soundHandle.pause();
        soundHandle.resume();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldCallFinishedHandler(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnFinish(callback);
        soundHandle.play();
        sound.finished.returns(false);

        soundHandle.onUpdate();
        Assert.areEqual(0, callbackCalledCount);

        Mockatoo.reset(sound);
        sound.finished.returns(true);
        soundHandle.onUpdate();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotCallFinishedHandlerIfUnsubscribed(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnFinish(callback);
        soundHandle.play();
        sound.finished.returns(true);

        soundHandle.onUpdate();
        Assert.areEqual(1, callbackCalledCount);

        Mockatoo.reset(sound);
        sound.finished.returns(true);
        soundHandle.unsubscribeOnFinish(callback);
        soundHandle.onUpdate();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotCallFinishedEventMoreThanOnce(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnFinish(callback);
        soundHandle.play();
        sound.finished.returns(true);

        soundHandle.onUpdate();
        Assert.areEqual(1, callbackCalledCount);

        Mockatoo.reset(sound);
        sound.finished.returns(true);
        soundHandle.onUpdate();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotPauseIfStopped(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPause(callback);
        soundHandle.play();
        soundHandle.stop();
        soundHandle.pause();

        Assert.areEqual(0, callbackCalledCount);
    }

    @Test
    public function shouldNotBeAbleToRestartIfStopped(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPlay(callback);
        soundHandle.play();
        soundHandle.stop();
        soundHandle.resume();

        soundHandle.onUpdate();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotResumeIfHasNotBeenPlayed(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPlay(callback);
        soundHandle.resume();

        Assert.areEqual(0, callbackCalledCount);
    }

    @Test
    public function shouldNotResumeIfStopped(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPlay(callback);
        soundHandle.play();
        soundHandle.stop();
        soundHandle.resume();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldNotPlayIfAlreadyFinished(): Void {
        var callbackCalledCount: Int = 0;
        var callback: Void->Void = function(): Void {
            callbackCalledCount++;
        }
        soundHandle.subscribeOnPlay(callback);
        soundHandle.play();

        sound.finished.returns(true);
        soundHandle.onUpdate();

        soundHandle.play();

        Assert.areEqual(1, callbackCalledCount);
    }

    @Test
    public function shouldDisposeAllItems(): Void {
        Mockatoo.reset(objectCreator);

        subscriber = mock(MappedSubscriber);
        objectCreator.createInstance(MappedSubscriber).returns(subscriber);

        sound = mock(AudioChannel);

        soundHandle = new KhaSoundHandle(sound);
        soundHandle.objectCreator = objectCreator;
        soundHandle.init();

        Assert.areEqual(subscriber, soundHandle.mappedSubscriber);

        soundHandle.dispose();

        objectCreator.disposeInstance(subscriber).verify();
        Assert.isNull(soundHandle.objectCreator);
        Assert.isNull(soundHandle.sound);
        Assert.isNull(soundHandle.mappedSubscriber);
    }

    @Test
    public function shouldReturnVolumeOfZeroIfSoundIsNull(): Void {
        soundHandle.sound = null;
        Assert.areEqual(soundHandle.volume, 0);
    }

    @Test
    public function shouldReturnPositionOfZeroIfSoundIsNull(): Void {
        soundHandle.sound = null;
        Assert.areEqual(soundHandle.position = 2, 0);
    }

    @IgnoreCover
    private function initializeWithNull():Void {
        soundHandle = new KhaSoundHandle(null);
        soundHandle.objectCreator = objectCreator;
        soundHandle.init();
    }
}