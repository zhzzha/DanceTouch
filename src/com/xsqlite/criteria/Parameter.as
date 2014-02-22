package com.xsqlite.criteria
{
	internal class Parameter
	{
		public var field:String;
		
		public var command:String;
		
		public var fieldParam:String
		
		public var vars:*;
		
		public var sql:String;
		
		public function Parameter(field:String="",command:String="",vars:*=null)
		{
			this.field = field;
			this.command = command;
			this.fieldParam = ":"+field;
			this.vars = vars;
			this.sql = this.field+this.command+this.fieldParam;
		}
	}
}