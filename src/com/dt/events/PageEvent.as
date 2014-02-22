package com.dt.events
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		/** 页面初始化或激活完成 */
		public static const INIT_COMPLETE:String="init_complete";
		
		/** 转场动画完成 */
		public static const TRANSITION_CONPLETE:String="transitions_complete";
		
		/** 二级页面加载完成 */
		public static const LEVEL_COMPLETE:String="level_complete";
		
		public function PageEvent(type:String)
		{
			super(type);
		}
	}
}