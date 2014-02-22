package com.dt.controller
{
	import com.dt.base.Container;
	import com.dt.core.AssetsManager;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class CheckButton extends Container
	{
		private var _text:TextField;
		
		private var _defaultSkin:Bitmap;
		
		private var _enableSkin:Bitmap;
		
		public function CheckButton()
		{
			super();
			initComponent();
			addEventListener(MultTouchEvent.TOUCH,onTouch);
		}
		
		public function set label(value:String):void{
			_text.text = value;
		}
		
		public function get label():String{
			return _text.text;
		}
		
		public function get select():Boolean{
			return _enableSkin.visible;
		}
		
		public function set select(value:Boolean):void{
			if(value){
				_enableSkin.visible = true;
				_defaultSkin.visible = false;
			}else{
				_defaultSkin.visible = true;
				_enableSkin.visible = false;
			}
		}
		
		/** 设置文本默认格式 */
		public function set textFormat(value:TextFormat):void{
			_text.defaultTextFormat = value;
		}
		
		private function onTouch(event:MultTouchEvent):void{
			if(event.touchType == MultTouchPhase.TOUCH_END){
				if(event.touchPoint.target == event.touchPoint.startTarget){
					select = !select;
				}
			}
		}
		
		private function initComponent():void{
			_defaultSkin = new Bitmap(AssetsManager.getAssets("checkButtonOn.png"),"auto",true);
			addChild(_defaultSkin);
			_enableSkin = new Bitmap(AssetsManager.getAssets("checkButton.png"),"auto",true);
			_enableSkin.visible = false;
			addChild(_enableSkin);
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(null,16,0xffffff);
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.cacheAsBitmap = true;
			_text.mouseEnabled = false;
			addChild(_text);
			
			_text.x = _defaultSkin.width + 5;
			_text.y = 4;//(_defaultSkin.height - _text.textHeight + 4)/2;
		}
	}
}