package com.dt.controller
{
	import com.dt.base.Container;
	import com.dt.core.AssetsManager;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class RollOverButton extends Container
	{
		private var _id:String;
		
		private var _select:Boolean;
		
		private var _choiseIcon:Bitmap;
		
		private var _noChoiseIcon:Bitmap;
		
		/** 划过选择 */
		public function RollOverButton(id:String)
		{
			super();
			_id = id;
			_select = false;
			_choiseIcon =new Bitmap(AssetsManager.getAssets("rollOverButtonOn.png")); 
			_choiseIcon.x = -_choiseIcon.width / 2;
			_choiseIcon.y = -_choiseIcon.height / 2;
			_choiseIcon.visible = false;
			addChild(_choiseIcon);
			_noChoiseIcon = new Bitmap(AssetsManager.getAssets("rollOverButton.png")); 
			_noChoiseIcon.x = -_noChoiseIcon.width / 2;
			_noChoiseIcon.y = -_noChoiseIcon.height / 2;
			addChild(_noChoiseIcon);
			
			addEventListener(MultTouchEvent.TOUCH,onTouch);
		}
		
		/** 重置选择状态 */
		public function reSet():void{
			_select = false;
			_choiseIcon.visible = false;
		}
		
		/** ID */
		public function get id():String{
			return _id;
		}
		
		private function onTouch(event:MultTouchEvent):void{
			if(_select)return;
			_select = true;
			_choiseIcon.visible = true;
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}