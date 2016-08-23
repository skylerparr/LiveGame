package handler;
@IgnoreCover
class IOCommands {
    //input commands
    public static inline var PLAYER_CONNECTED: Int = 1;
    public static inline var UNIT_CREATED: Int = 2;
    public static inline var UNIT_MOVE: Int = 3;
    public static inline var HERO_CREATED: Int = 4;
    public static inline var UNIT_CASTING_SPELL: Int = 5;
    public static inline var UNIT_CASTED_SPELL: Int = 6;

    //output commands
    public static inline var PLAYER_CONNECT: Int = 101;
    public static inline var UNIT_MOVE_TO: Int = 103;
    public static inline var UNIT_CAST_SPELL: Int = 104;

    public function new() {
    }
}
