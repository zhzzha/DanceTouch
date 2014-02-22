package com.xsqlite
{
	public class Field
	{
		public static const READ_ONLY:String="read";
		
		public static const WRITE_ONLY:String="write";
		
		public static const READ_WRITE:String="readwrite";
		
		
		public var filed:String;
		
		public var type:String;
		
		public var access:String;
		
		public var paramName:String;
		
		public var mode:String;
		
		public function Field()
		{
		}
		
		public function get typeMapping():String{
			if(type == "int"){
				return "INTEGER";
			}
			if(type == "Number"){
				return "FLOAT";
			}
			if(type == "Boolean"){
				return "BOOLEAN";
			}
			if(type == "ByteArray"){
				return "BLOB";
			}
			return "TEXT";
		}
	}
}