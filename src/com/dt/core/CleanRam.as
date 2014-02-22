package com.dt.core
{
	import flash.net.LocalConnection;
	import flash.system.System;

	/**
	 * 清除内存  强制回收
	 */
	public  class CleanRam
	{
		/**  */
		public static function clean():void
		{
			try{
				new LocalConnection().connect("xida");
				new LocalConnection().connect("xida");
			}catch(error:Error){
				
			}
			System.gc();
		}
	}
}