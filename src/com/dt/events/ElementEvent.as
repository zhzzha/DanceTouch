package com.dt.events
{
	import flash.events.Event;
	
	public class ElementEvent extends Event
	{
		public static const COLSE:String="COLSE";
		
		public static const CHOISE:String="CHOISE";
		
		public var data:String;
		
		public function ElementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}