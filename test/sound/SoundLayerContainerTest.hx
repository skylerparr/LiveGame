package sound;

import sound.kha.mocks.MockSoundHandle;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class SoundLayerContainerTest {

    private var soundLayer: SoundLayerContainer;
    private var soundHandle: SoundHandle = mock(MockSoundHandle);
    private var soundHandle1: SoundHandle = mock(MockSoundHandle);
    private var soundHandle2: SoundHandle = mock(MockSoundHandle);

    public function new() {

    }

    @Before
    public function setup():Void {
        soundHandle = mock(MockSoundHandle);
        soundHandle1 = mock(MockSoundHandle);
        soundHandle2 = mock(MockSoundHandle);

        soundLayer = new SoundLayerContainer();
        soundLayer.init();
    }

    @After
    public function tearDown():Void {
        soundLayer = null;
    }

    @Test
    public function shouldAddSoundsToLayer(): Void {
        addAllSounds();

        var allSounds: Array<SoundHandle> = soundLayer.allSounds;
        Assert.areEqual(3, allSounds.length);
        Assert.areEqual(soundHandle, allSounds[0]);
        Assert.areEqual(soundHandle1, allSounds[1]);
        Assert.areEqual(soundHandle2, allSounds[2]);
    }

    @Test
    public function shouldRemoveSoundFromLayer(): Void {
        addAllSounds();

        soundLayer.removeSound(soundHandle1);

        var allSounds: Array<SoundHandle> = soundLayer.allSounds;
        Assert.areEqual(2, allSounds.length);
        Assert.areEqual(soundHandle, allSounds[0]);
        Assert.areEqual(soundHandle2, allSounds[1]);
    }

    @Test
    public function shouldCallPlayOnAllSoundHandles(): Void {
        addAllSounds();

        soundLayer.play();

        soundHandle.play().verify();
        soundHandle1.play().verify();
        soundHandle2.play().verify();
    }

    @Test
    public function shouldAutoPlaySoundIfLayerIsPlaying(): Void {
        soundLayer.addSound(soundHandle);
        soundLayer.addSound(soundHandle1);

        soundLayer.play();

        soundLayer.addSound(soundHandle2);

        soundHandle2.play().verify();
    }

    @Test
    public function shouldPauseAllSounds(): Void {
        addAllSounds();

        soundLayer.play();
        soundLayer.pause();

        soundHandle.pause().verify();
        soundHandle1.pause().verify();
        soundHandle2.pause().verify();
    }
    
    @Test
    public function shouldPauseSoundHandleIfRemovedWhileLayerIsPlaying(): Void {
        addAllSounds();

        soundLayer.play();

        soundLayer.removeSound(soundHandle);

        soundHandle.pause().verify();
    }

    @Test
    public function shouldResumeIfPaused(): Void {
        addAllSounds();

        soundLayer.play();
        soundLayer.pause();
        soundLayer.resume();

        soundHandle.resume().verify();
        soundHandle1.resume().verify();
        soundHandle2.resume().verify();
    }

    @Test
    public function shouldStopAllSounds(): Void {
        addAllSounds();

        soundLayer.play();
        soundLayer.stop();

        soundHandle.stop().verify();
        soundHandle1.stop().verify();
        soundHandle2.stop().verify();
    }
    
    @Test
    public function shouldNotCallPlayTwice(): Void {
        addAllSounds();

        soundLayer.play();
        soundLayer.play();

        soundHandle.play().verify();
        soundHandle1.play().verify();
        soundHandle2.play().verify();
    }

    @Test
    public function shouldNotPauseIfNotPlaying(): Void {
        addAllSounds();
        soundLayer.pause();

        soundHandle.pause().verify(0);
        soundHandle1.pause().verify(0);
        soundHandle2.pause().verify(0);
    }

    @Test
    public function shouldNotResumeIfNotPaused(): Void {
        addAllSounds();
        soundLayer.play();
        soundLayer.resume();

        soundHandle.resume().verify(0);
        soundHandle1.resume().verify(0);
        soundHandle2.resume().verify(0);
    }

    @Test
    public function shouldStopIfPaused(): Void {
        addAllSounds();
        soundLayer.play();
        soundLayer.pause();
        soundLayer.stop();

        soundHandle.stop().verify();
        soundHandle1.stop().verify();
        soundHandle2.stop().verify();
    }

    @Test
    public function shouldNotPlayIfStopped(): Void {
        addAllSounds();
        soundLayer.play();
        soundLayer.stop();
        soundLayer.play();

        soundHandle.play().verify();
        soundHandle1.play().verify();
        soundHandle2.play().verify();
    }

    @Test
    public function shouldNotPlayIfResumed(): Void {
        addAllSounds();
        soundLayer.play();
        soundLayer.pause();
        soundLayer.resume();
        soundLayer.play();

        soundHandle.play().verify();
        soundHandle1.play().verify();
        soundHandle2.play().verify();
    }

    @Test
    public function shouldNotResumeIfStopped(): Void {
        addAllSounds();
        soundLayer.play();
        soundLayer.pause();
        soundLayer.stop();
        soundLayer.resume();

        soundHandle.resume().verify(0);
        soundHandle1.resume().verify(0);
        soundHandle2.resume().verify(0);
    }

    private inline function addAllSounds():Void {
        soundLayer.addSound(soundHandle);
        soundLayer.addSound(soundHandle1);
        soundLayer.addSound(soundHandle2);
    }
}