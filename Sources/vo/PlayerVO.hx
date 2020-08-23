package vo;
interface PlayerVO {
    var id(get, null): Int;
    var name(get, null): String;
    var hero(get, null): UnitVO;
    var units(get, null): Map<Int, UnitVO>;
}
