package com.xsqlite.criteria
{
	import com.xsqlite.Table;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;

	/**
	 * 标准查询 
	 * 结果为绑定的类
	 * @author XIDA
	 */	
	public class SelectCriteria
	{
		private var _sql:String;
		
		private var _table:Table;
		
		private var _printSql:Boolean;
		
		private var _sqlstatement:SQLStatement;
		
		
		private var _limt:String;
		
		private var _whereParam:Vector.<Parameter>;
		
		public function SelectCriteria(conn:SQLConnection,table:Table,field:String,printSql:Boolean = false)
		{
			_table = table;
			_printSql = printSql;
			_sqlstatement = new SQLStatement();
			_sqlstatement.sqlConnection = conn;
			
			_sql = "SELECT "+field+" FROM " + _table.tableName + " ";
			if(field == "*")_sqlstatement.itemClass = _table.tableClass;
		}
		
		/**
		 * 为语句增加条件 
		 * @param condition
		 */		
		public function where(fv:Parameter):SelectCriteria{
			if(!_whereParam)_whereParam=new Vector.<Parameter>();
			_whereParam.push(fv);
			return this;
		}
		
		/**
		 * 查询结果数据长度控制
		 * 如果b值为0  则只限制长度
		 */
		public function limit(a:Number,b:Number = 0):SelectCriteria{
			if(b == 0){
				_limt = "LIMIT "+a;
			}else{
				_limt = "LIMIT "+a+","+b;
			}
			return this;
		}
		
		/**
		 * 执行语句，
		 */
		public function execute():SQLResult{
			var i:int;
			var wLen:int = 0;
			if(_whereParam){
				_sql += "WHERE ";
				wLen= _whereParam.length;
				for(i= 0;i<wLen;i++){
					_sql += _whereParam[i].sql + (i == wLen-1 ? " ":" AND ");
				}
			}			
			if(_limt){
				_sql += _limt;
			}
			_sqlstatement.text = _sql;
			if(wLen>0){
				for(i = 0;i<wLen;i++){
					if(_whereParam[i].vars){
						if(_whereParam[i].vars is Array){
							var vars:Array = _whereParam[i].vars;
							for(var k:int = 0 ;k<vars.length;k++){
								_sqlstatement.parameters[":var"+k] = vars[k];
							}
						}else{
							_sqlstatement.parameters[_whereParam[i].fieldParam] = _whereParam[i].vars;
						}
					}
				}
			}
			if(_printSql)trace(_sqlstatement.text);
			_sqlstatement.execute();
			return _sqlstatement.getResult();
		}
		
		/**
		 * 清空引用 垃圾回收
		 */		
		public function dispose():void{
			_whereParam.splice(0,_whereParam.length);
			_sqlstatement = null;
			_table = null;
		}
	}
}