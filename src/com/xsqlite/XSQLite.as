package com.xsqlite
{
	import com.xsqlite.criteria.SelectCriteria;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class XSQLite
	{
		private var _file:File;
		
		private var _conn:SQLConnection;
		
		private var _tableList:Vector.<Table>;
		
		private var _debug:Boolean = true;
		
		public function XSQLite(file:File,isTraceSql:Boolean = false)
		{
			_file=file;
			_debug = isTraceSql;
			_conn=new SQLConnection();
			_tableList = new Vector.<Table>();
		}
		
		/**
		 * 打开数据库
		 * SQLMode
		 */
		public function open(passdword:ByteArray = null):void{
			_conn.open(_file,SQLMode.CREATE,false,1024,passdword);
		}
		
		/**
		 * 关闭数据库
		 */
		public function close():void{
			_conn.close();
		}
		
		
		/**
		 * 加入映射表
		 * 如果数据库中没有发现表则创建一个
		 * @param tableName
		 * @param object
		 */
		public function addTable(tableName:String,objectClass:Class,primaryKey:String,primaryMode:String):void{
			var table:Table = new Table(tableName,objectClass,primaryKey,primaryMode);
			try{
				_conn.loadSchema();
				var array:Array = _conn.getSchemaResult().tables;
				var len:int = array.length;
				for(var i:int =0;i<len;i++){
					var tableSchema:SQLTableSchema=array[i] as SQLTableSchema;
					if(tableSchema.name == tableName){
						_tableList.push(table);
						return;
					}
				}
			}catch(error:Error){
			}finally{
			}
			var sqlstatement:SQLStatement=new SQLStatement();
			sqlstatement.text = Table.createTable(table);
			executeSqlStatement(sqlstatement);
			_tableList.push(table);
		}
		
		/**
		 * 开始事务
		 * 将大量工作放入一个事务中将极大提高性能
		 */
		public function beginTransaction():void{
			_conn.begin();
		}
		
		/**
		 * 提交事务
		 */
		public function commit():void{
			_conn.commit();
		}
		
		/**
		 * 添加数据条目
		 * @param value
		 */		
		public function add(value:*):void{
			var table:Table = findTableByObj(value);
			var sqlstatement:SQLStatement = new SQLStatement();
			sqlstatement.text = table.addSql;
			if(table.needPrimaryKey){
				sqlstatement.parameters[table.primaryField.paramName]=value[table.primaryField.filed];
			}
			for each(var field:Field in table.fieldList){
				sqlstatement.parameters[field.paramName]=value[field.filed];
			}
			value[table.primaryField.filed] = executeSqlStatement(sqlstatement).lastInsertRowID;
		}
		
		/**
		 * 删除数据条目  快捷方式
		 * @param value
		 */		
		public function del(value:*):void{
			var table:Table = findTableByObj(value);
			var sqlstatement:SQLStatement=new SQLStatement();
			sqlstatement.text =table.delSql;
			sqlstatement.parameters[table.primaryField.paramName]=value[table.primaryField.filed];
			executeSqlStatement(sqlstatement);
		}
		
		/**
		 * 更新数据条目   快捷方式
		 * @param value
		 */		
		public function update(value:*):void{
			var table:Table = findTableByObj(value);
			var sqlstatement:SQLStatement=new SQLStatement();
			sqlstatement.text = table.updateSql;
			sqlstatement.parameters[table.primaryField.paramName]=value[table.primaryField.filed];
			for each(var field:Field in table.fieldList){
				sqlstatement.parameters[field.paramName]=value[field.filed];
			}
			executeSqlStatement(sqlstatement);
		}
		
		/**
		 * 执行sql 
		 * 自定义的操作
		 * @param sql 是sql语句
		 */		
		public function executeSql(sql:String):SQLResult{
			var sqlstatement:SQLStatement = sqlstatement=new SQLStatement();
			sqlstatement.text = sql;
			return executeSqlStatement(sqlstatement);
		}
		
		/**
		 * 执行SQLStatement
		 * 自定义的操作
		 * @param sql
		 * @return 
		 */		
		public function executeSqlStatement(sql:SQLStatement):SQLResult{
			sql.sqlConnection = _conn;
			if(_debug)trace(sql.text);
			sql.execute();
			return sql.getResult();
		}
		
		/**
		 * 创建标准条件查询 
		 * @param classObject 可以是表名  也可以是class
		 * @param field 所要查询的字段
		 * @return 
		 */		
		public function createSelect(classObject:*,field:String="*"):SelectCriteria{
			if(classObject is Class){
				return new SelectCriteria(_conn,findTable(classObject),field,_debug);
			}
			if(classObject is String){
				return new SelectCriteria(_conn,findTableByName(classObject),field,_debug);
			}
			throw new Error("类型错误");
			return null;
		}
		
		//通过class查找table
		private function findTable(object:Class):Table{
			var table:Table;
			for each(table in _tableList){
				if(object == table.tableClass){
					return table;
				}
			}
			throw new Error("表不存在");
			return null;
		}
		
		//通过表明查找table
		private function findTableByName(object:String):Table{
			var table:Table;
			for each(table in _tableList){
				if(object == table.tableName){
					return table;
				}
			}
			throw new Error("表不存在");
			return null;
		}
	
		//对比类型查找table
		private function findTableByObj(object:*):Table{
			var table:Table;
			for each(table in _tableList){
				if(object is table.tableClass){
					return table;
				}
			}
			throw new Error("表不存在");
			return null;
		}
	}
}