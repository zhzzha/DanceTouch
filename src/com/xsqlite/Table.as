package com.xsqlite
{
	import flash.data.SQLStatement;
	import flash.utils.describeType;

	public class Table
	{
		private var _tableName:String;
		
		private var _tableClass:Class;
		
		private var _fieldName:Vector.<String>;
		
		private var _fieldParamName:Vector.<String>;
		
		private var _list:Vector.<Field>;
		
		private var _primaryKey:Field;
		
		private var _delSQL:String;
		
		private var _addSQL:String;
		
		private var _updateSQL:String;
		
		private var _needPrimaryKey:Boolean;
		
		public function Table(tableName:String,tableClass:Class,primaryKey:String,primaryMode:String)
		{
			_tableName = tableName;
			_tableClass = tableClass;
			_fieldName = new Vector.<String>();
			_fieldParamName = new Vector.<String>();
			_list = getFiledList(tableClass);
			for(var i:int=_list.length-1 ; i>=0 ; i--){
				if(_list[i].filed == primaryKey){
					_primaryKey = _list[i];
					_primaryKey.mode = primaryMode;
					_list.splice(i,1);
				}else{
					_fieldName.push(_list[i].filed);
					_fieldParamName.push(_list[i].paramName);
				}
			}
			if(_primaryKey.mode == Config.AUTO_INT){
				_needPrimaryKey = false;
			}else{
				_needPrimaryKey = true
			}
			quicklySQL();
		}
		
		public function get tableName():String{
			return _tableName;
		}
		
		public function get tableClass():Class{
			return _tableClass;
		}
		
		public function get fieldParamNameList():Vector.<String>{
			return _fieldParamName;
		}
		
		public function get fieldNameList():Vector.<String>{
			return _fieldName;
		}
		
		public function get fieldList():Vector.<Field>{
			return _list;
		}
		
		public function get primaryField():Field{
			return _primaryKey;
		}
		
		public function get addSql():String{
			return _addSQL;
		}
		
		public function get delSql():String{
			return _delSQL;
		}
		
		public function get updateSql():String{
			return _updateSQL;
		}
		
		public function get needPrimaryKey():Boolean{
			return _needPrimaryKey;
		}
		
		private function quicklySQL():void{
			_delSQL = "DELETE FROM "+_tableName+" WHERE "+_primaryKey.filed+"="+_primaryKey.paramName;
			_addSQL = "INSERT INTO "+_tableName+" (" ;
			var addSQL2:String = " VALUES (";
			_updateSQL = "UPDATE "+_tableName+" SET ";
			if(_needPrimaryKey){
				_addSQL += _primaryKey.filed+",";
				addSQL2 += _primaryKey.paramName+",";
			}
			for each(var field:Field in _list){
				_addSQL += field.filed+",";
				addSQL2 += field.paramName+",";
				_updateSQL += field.filed+"="+field.paramName+",";
			}
			if(_addSQL.charAt(_addSQL.length-1)==","){
				_addSQL = _addSQL.substr(0,_addSQL.length-1);
			}
			if(addSQL2.charAt(addSQL2.length-1)==","){
				addSQL2 = addSQL2.substr(0,addSQL2.length-1);
			}
			if(_updateSQL.charAt(_updateSQL.length-1)==","){
				_updateSQL = _updateSQL.substr(0,_updateSQL.length-1);
			}
			_addSQL += ")"+addSQL2+")";
			_updateSQL += " WHERE "+_primaryKey.filed+"="+_primaryKey.paramName;
		}
		
		//创建表--字段 映射
		private static function getFiledList(objectClass:Class):Vector.<Field>{
			var list:Vector.<Field> = new Vector.<Field>();
			var xml:XML = describeType(objectClass);
			var filedList:XMLList = xml.factory.accessor;
			for each(var filedxml:XML in  filedList){
				if(filedxml.@access == "readwrite"){
					var filed:Field = new Field();
					filed.filed = filedxml.@name;
					filed.access = filedxml.@access;
					filed.type = filedxml.@type;
					filed.paramName = ":"+filedxml.@name;
					list.push(filed);
				}
			}
			return list;
		}
		
		/**
		 * 创建表
		 */
		public static function createTable(table:Table):String{
			var sql:String = "CREATE TABLE IF NOT EXISTS "+ table.tableName+" (";
			if(table.primaryField.mode == "" || table.primaryField.mode == null){
				sql += " id "+table.primaryField.typeMapping+ " PRIMARY KEY " +",";
			}else{
				sql += " id "+table.primaryField.typeMapping+" "+table.primaryField.mode+",";
			}
			for each(var filed:Field in table.fieldList){
				sql += " "+filed.filed + " "+filed.typeMapping+",";
			}
			if(sql.charAt(sql.length-1)==","){
				sql = sql.substr(0,sql.length-1);
			}
			sql += ")";
			return sql;
		}
	}
}