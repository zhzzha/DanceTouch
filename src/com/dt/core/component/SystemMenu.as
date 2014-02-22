package com.dt.core.component
{
	import com.dt.base.Container;
	import com.dt.controller.RectButton;
	import com.dt.core.AssetsManager;
	import com.dt.core.DTConfig;
	import com.touch.MultTouchEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class SystemMenu extends Container
	{
		private var _menuBg:Bitmap;
		
		private var _select:String;
		
		public function SystemMenu()
		{
			super();
			this.width = 350;
			this.height = 500;
			
			//init
			_menuBg = new Bitmap(AssetsManager.getAssets("menuView.png"));
			addChild(_menuBg);
			
			var close:RectButton = new RectButton(350,65);
			close.y = 117;close.id = DTConfig.MENU_CLOSE;
			close.addEventListener(MultTouchEvent.SELECT,onMenuSelect);
			addChild(close);
			var updata:RectButton = new RectButton(350,65);
			updata.y = 180;updata.id = DTConfig.MENU_UPDATA;
			updata.addEventListener(MultTouchEvent.SELECT,onMenuSelect);
			addChild(updata);
			var unlock:RectButton = new RectButton(350,65);
			unlock.y = 246;unlock.id = DTConfig.MENU_UNLOCK;
			unlock.addEventListener(MultTouchEvent.SELECT,onMenuSelect);
			addChild(unlock);
			var setting:RectButton = new RectButton(350,65);
			setting.y = 310;setting.id = DTConfig.MENU_DEPLOY;
			setting.addEventListener(MultTouchEvent.SELECT,onMenuSelect);
			addChild(setting);
			var about:RectButton = new RectButton(350,65);
			about.y = 374;about.id = DTConfig.MENU_ABOUT;
			about.addEventListener(MultTouchEvent.SELECT,onMenuSelect);
			addChild(about);
		}
		
		/** 设置主题色 */
		public function set color(color:int):void{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			cacheAsBitmap = true;
		}
		
		/** 选择的项 */
		public function get select():String{
			return _select;
		}
		
		//菜单选择
		private function onMenuSelect(event:MultTouchEvent):void{
			var button:RectButton = event.currentTarget as RectButton;
			_select = button.id;
			this.dispatchEvent(new Event(Event.SELECT));
		}
	}
}