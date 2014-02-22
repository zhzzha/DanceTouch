package com.dt.core.component
{
	import com.dt.base.Container;
	import com.dt.controller.CheckButton;
	import com.dt.controller.Scale9Button;
	import com.dt.core.AssetsManager;
	import com.greensock.TweenLite;
	import com.touch.MultTouchEvent;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/** 配置页面 */
	public class DeployMenu extends Container
	{
		private var _simulator:CheckButton;
		
		private var _tuio:CheckButton;
		
		private var _sound:CheckButton;
		
		public function DeployMenu()
		{
			super();
			width = 600;
			height = 350;
			initComponent();
			addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
		}
		
		public function set color(value:int):void{
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		/** 关闭 */
		public function close():void{
			TweenLite.to(this,0.4,{x:parent.width,onComplete:remove});
		}
		
		private function remove():void{
			parent.removeChild(this);
		}
		
		private function onCloseSelect(event:MultTouchEvent):void{
			close();
		}
		
		private function onAddtoStage(event:Event):void{
			this.x = -width;
			this.y = (parent.height - height)/2;
			TweenLite.to(this,0.4,{x:(parent.width - width)/2});
		}
		
		private function initComponent():void{
			var text:TextField = new TextField();
			text.x = 10 ; text.y = 10;
			text.defaultTextFormat = new TextFormat(null,30,0xffffff,true);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.cacheAsBitmap = true;
			text.mouseEnabled = false;
			text.text = "系统设置";
			addChild(text);
			
			var closeButton:Scale9Button = new Scale9Button(
				AssetsManager.getAssets("closeButton.png"),
				AssetsManager.getAssets("closeButtonOn.png"));
			closeButton.width = closeButton.height = 40;
			closeButton.x = 550;closeButton.y = 10;
			closeButton.addEventListener(MultTouchEvent.SELECT,onCloseSelect);
			addChild(closeButton);
			
			_simulator = new CheckButton();
			_simulator.x = 40;_simulator.y = 70;
			_simulator.label = "模拟";
			addChild(_simulator);
			
			_tuio = new CheckButton();
			_tuio.x = 200;_tuio.y = 70;
			_tuio.label = "TUIO";
			addChild(_tuio);
			
			_sound = new CheckButton();
			_sound.x = 360;_sound.y = 70;
			_sound.label = "声音";
			addChild(_sound);
		}
	}
}