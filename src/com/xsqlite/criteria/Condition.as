package com.xsqlite.criteria
{

	public class Condition
	{
		/** 大于等于 */
		public static function greaterEqual(field:String,a:*):Parameter{
			return new Parameter(field,">=",a);
		}
		
		/** 小于等于 */
		public static function lessEqual(field:String,a:*):Parameter{
			return new Parameter(field,"<=",a);
		}
		
		/** 大于 */
		public static function greater(field:String,a:*):Parameter{
			return new Parameter(field,">",a);
		}
		
		/** 小于 */
		public static function less(field:String,a:*):Parameter{
			return new Parameter(field,"<",a);
		}
		
		/** 等于 */
		public static function equal(field:String,a:*):Parameter{
			return new Parameter(field,"=",a);
		}
		
		/** 等于数组内任意值 */
		public static function inVar(field:String,a:Array):Parameter{
			var sql:String =field+ " in (";
			var len:int =a.length;
			for(var i:int=0;i<len;i++){
				sql += ":var" + i + (i == len-1?"":",");//sql += a[i] + (i == len-1?"":",");
			}
			sql += ")";
			var param:Parameter = new Parameter();
			param.sql = sql;
			param.vars = a;
			return param;
		}
		
		/** 在两个值之间 */
		public static function between(field:String,a:*,b:*):Parameter{
			var param:Parameter = new Parameter();
			param.sql = field+" BETWEEN :var0 AND :var1";
			param.vars = [a,b];
			return param;
		}
	}
}