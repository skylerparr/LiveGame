package vo;
interface PlayerVO {
    var id(get, null): Int;
    var name(get, null): String;
    var units(get, null): Map<Int, UnitVO>;
}
