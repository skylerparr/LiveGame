package sound;

import util.MappedSubscriber;
import core.ObjectCreator;
import sound.kha.mocks.MockSoundLayer;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class SimpleSoundManagerTest {

    private var soundManager: SimpleSoundManager;
    private var soundLayer: MockSoundLayer;
    private var soundLayer1: MockSoundLayer;
    private var soundLayer2: MockSoundLayer;


    @Before
    public function setup():Void {
        soundLayer = mock(MockSoundLayer);
        soundLayer.volume.returns(1);
        soundLayer1 = mock(MockSoundLayer);
        soundLayer1.volume.returns(0.75);
        soundLayer2 = mock(MockSoundLayer);
        soundLayer2.volume.returns(0.5);

        soundManager = new SimpleSoundManager();
        soundManager.init();
    }

    @After
    public function tearDown():Void {
        soundManager = null;
        soundLayer = null;
        soundLayer1 = null;
        soundLayer2 = null;
    }

    @Test
    public function shouldAddSoundLayerToManager(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        Assert.areEqual(soundLayer, soundManager.allLayers.get("sfx"));
        Assert.areEqual(soundLayer1, soundManager.allLayers.get("music"));
    }

    @Test
    public function shouldGetSoundLayerByName(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        Assert.areEqual(soundLayer1, soundManager.getSoundLayerByName("music"));
        Assert.areEqual(soundLayer, soundManager.getSoundLayerByName("sfx"));
    }

    @Test
    public function shouldRemoveSoundLayerByName(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        soundManager.removeSoundLayerByName("music");

        Assert.areEqual(soundLayer, soundManager.getSoundLayerByName("sfx"));
        Assert.isNull(soundManager.getSoundLayerByName("music"));
    }

    @Test
    public function shouldCallPlayOnAllSoundLayers(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        soundManager.playAll();

        soundLayer.play().verify();
        soundLayer1.play().verify();
    }

    @Test
    public function shouldCallPauseOnAllSoundLayers(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        soundManager.pauseAll();

        soundLayer.pause().verify();
        soundLayer1.pause().verify();
    }

    @Test
    public function shouldCallResumeOnAllSoundLayers(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        soundManager.resumeAll();

        soundLayer.resume().verify();
        soundLayer1.resume().verify();
    }

    @Test
    public function shouldCallStopOnAllSoundLayers(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);

        soundManager.stopAll();

        soundLayer.stop().verify();
        soundLayer1.stop().verify();
    }

    @Test
    public function shouldSubscribeToVolumeChangeOnAllLayers(): Void {
        soundLayer.volume.returns(0.3);
        soundLayer.subscribeToVolumeChange(cast any).calls(function(args): Void {
            args[0](soundLayer);
        });
        soundManager.addSoundLayer("sfx", soundLayer);

        Assert.areEqual(0.3, soundManager.layerVolumeMap.get(soundLayer));
    }

    @Test
    public function shouldUnsubscribeFromVolumeChangeWhenRemoved(): Void {
        soundLayer.subscribeToVolumeChange(cast any).calls(function(args): Void {
        });
        soundManager.addSoundLayer("sfx", soundLayer);

        soundLayer.volume.returns(0.5);

        soundManager.removeSoundLayerByName("sfx");

        soundLayer.unsubscribeFromVolumeChange(cast any).calls(function(args): Void {
            args[0](soundLayer);
        });

        Assert.isNull(soundManager.layerVolumeMap.get(soundLayer));
        soundLayer.unsubscribeFromVolumeChange(cast any).verify();
    }

    @Test
    public function shouldSetTheVolumeAsAPercentageOfTheLayers(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);
        soundManager.addSoundLayer("ambient", soundLayer2);

        soundManager.masterVolume = 0.5;

        soundLayer.set_volume(0.5).verify();
        soundLayer1.set_volume(0.375).verify();
        soundLayer2.set_volume(0.25).verify();
    }

    @Test
    public function shouldDisposeAllReferences(): Void {
        soundManager.addSoundLayer("sfx", soundLayer);
        soundManager.addSoundLayer("music", soundLayer1);
        soundManager.addSoundLayer("ambient", soundLayer2);

        soundManager.dispose();

        soundLayer.pause().verify();
        soundLayer1.pause().verify();
        soundLayer2.pause().verify();

        soundLayer.unsubscribeFromVolumeChange(cast any).verify();
        soundLayer1.unsubscribeFromVolumeChange(cast any).verify();
        soundLayer2.unsubscribeFromVolumeChange(cast any).verify();

        Assert.isNull(soundManager.allLayers);
        Assert.isNull(soundManager.layerVolumeMap);
    }
}