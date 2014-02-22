package com.events
{
	import flash.events.Event;
	
	public class VideoPlayEvent extends Event
	{
		/**
		 * 播放器初始化完成
		 */
		public static const INITIALIZE:String="INITIALIZE";
		
		/**
		 * 开始播放
		 */
		public static const BEGIN_PLAY:String="BEGIN_PLAY";
		
		/**
		 * 播放结束
		 */
		public static const PLAY_COMPLETE:String="PLAY_COMPLETE";
		
		/**
		 * 播放进度
		 */
		public static const PLAY_PROGRESS:String="PLAY_PROGRESS";
		
		/**
		 * 播放错误
		 */
		public static const ERROR:String="ERROR";
		
		public function VideoPlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}