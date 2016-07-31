package core;
import constants.SettingKeys;
@IgnoreCover
class MapApplicationSettings implements ApplicationSettings {
    public function new() {
    }

    public function getSetting(name:String):Dynamic {
        if(name == SettingKeys.SOCKET_HOST) {
            return "localhost";
        }
        if(name == SettingKeys.SOCKET_PORT) {
            return 1337;
        }
        return null;
    }
}
