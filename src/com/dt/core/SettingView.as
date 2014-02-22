package com.dt.core
{
	import com.dt.DTFacade;
	import com.dt.base.Container;
	import com.dt.controller.RectButton;
	import com.dt.core.component.DrawGraphicUnlock;
	import com.greensock.TweenLite;
	import com.touch.MultTouchEvent;
	
	import flash.events.Event;
	
	/** 设置界面 */
	public class SettingView extends Container
	{
		private var _passdwordInput:DrawGraphicUnlock;
		
		private var _callOutButton:RectButton;
		
		public function SettingView()
		{
			super();
		}
		
		/** 初始化 */
		public function init(config:XML):void{
			DTConfig.MainColor = config.Menu.@color;
			
			_passdwordInput = new DrawGraphicUnlock();
			_passdwordInput.color = DTConfig.MainColor;
			
			_callOutButton = new RectButton(50,50);
			_callOutButton.addEventListener(MultTouchEvent.SELECT,onCalloutSelect);
			addChild(_callOutButton);
		}
		
		//密碼輸入打開
		private function onCalloutSelect(event:MultTouchEvent):void{
			_passdwordInput.addEventListener(Event.COMPLETE,onPassdwordComplete);
			_passdwordInput.x = -_passdwordInput.width;
			addChild(_passdwordInput);
			TweenLite.to(_passdwordInput,0.5,{x:0});
		}
		
		//成功輸入密碼
		private function onPassdwordComplete(event:Event):void{
			_passdwordInput.removeEventListener(Event.COMPLETE,onPassdwordComplete);
			var passdword:String = _passdwordInput.passdword;
			if(passdword == "14789"){
				TweenLite.to(_passdwordInput,0.5,{x:-_passdwordInput.width,onComplete:turnBackComplete});
			}else{
				_passdwordInput.reSet();
				_passdwordInput.addEventListener(Event.COMPLETE,onPassdwordComplete);
			}
		}
		
		//彈回成功
		private function turnBackComplete():void{
			_passdwordInput.reSet();
			removeChild(_passdwordInput);
		}
		
		//打開菜單
		private function openMenu():void{
			
		}
	}
}