package handler.input;
class HeroCreated extends UnitCreated {
    public function new() {
        super();
    }

    override public function get_cmdId():UInt {
        return IOCommands.HERO_CREATED;
    }
}
