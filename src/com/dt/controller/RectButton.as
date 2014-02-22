package com.dt.controller
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.display.Sprite;
	
	//區域按鈕  
	public class RectButton extends Sprite
	{
		private var _id:String;
		
		public function RectButton(width:Number,height:Number)
		{
			super();
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			
			this.cacheAsBitmap = true;
			addEventListener(MultTouchEvent.TOUCH,onTouch);
		}
		
		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		private function onTouch(event:MultTouchEvent):void{
			if(event.touchType == MultTouchPhase.TOUCH_END &&
				event.touchPoint.target == this && 
				event.touchPoint.startTarget == this){
				this.dispatchEvent(new MultTouchEvent(MultTouchEvent.SELECT));
			}
		}
	}
}