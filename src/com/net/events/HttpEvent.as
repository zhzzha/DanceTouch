package com.net.events
{
	import flash.events.Event;
	
	public class HttpEvent extends Event
	{
		public static const DATA_ARRIVE:String="data_arrive";//
		
		public static const REQUEST_READY:String = "request_ready";
		
		public function HttpEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}