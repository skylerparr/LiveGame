package io;
interface OutputStream {
    function writeBoolean( value:Bool ):Void;
    function writeByte( value:Int ):Void;
    function writeDouble( value:Float ):Void;
    function writeFloat( value:Float ):Void;
    function writeInt( value:Int ):Void;
    function writeMultiByte( value:String, charSet:String ):Void;
    function writeObject( object:Dynamic ):Void;
    function writeShort( value:Int ):Void;
    function writeUTF( value:String ):Void;
    function writeUTFBytes( value:String ):Void;
    function writeUnsignedInt( value:Int ):Void;
    function writeBytes(bytes: InputOutputStream, offset: Int = 0, length: Int = 0): Void;
}
