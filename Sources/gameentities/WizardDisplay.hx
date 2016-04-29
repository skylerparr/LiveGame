package gameentities;
import assets.ImageAsset;
import assets.AssetLocator;
import core.ObjectCreator;
import animation.spec.TexturePackerJSONArrayFrameSpec;
import display.two.kha.KhaSprite;
import display.BitmapNode;
import animation.Animation;
import animation.AnimationController;
import haxe.Json;

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class WizardDisplay extends KhaSprite {
    @inject
    public var objectCreator: ObjectCreator;
    @inject
    public var assetLocator: AssetLocator;

    private var animation: Animation;
    private var image: ImageAsset;
    private var frames: TexturePackerJSONArrayFrameSpec;
    private var animationController: AnimationController;

    public function new() {
        super();
    }

    override public function init():Void {
        super.init();
        createWizard(function(): Void {

        });
    }

    @:async
    private function createWizard():Void {
        image = @await assetLocator.getAssetByName("wizard");

        var wizard: BitmapNode = objectCreator.createInstance(BitmapNode);
        wizard.imageData = image.data;
        addChild(wizard);

        var jsonString = @await assetLocator.getDataAssetByName("wizard_frames_json");
        frames = objectCreator.createInstance(TexturePackerJSONArrayFrameSpec,[Json.parse(cast jsonString)]);

        animation = objectCreator.createInstance(Animation);
        animation.frameTime = 50;
        animation.frames = frames.frames;
        animation.bitmap = wizard;

        animationController = objectCreator.createInstance(AnimationController);
        animationController.animation = animation;
        animationController.start();
    }
}
