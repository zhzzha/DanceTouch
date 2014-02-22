package com.dt.core.component
{
	import com.dt.base.Container;
	import com.dt.controller.RollOverButton;
	import com.dt.core.AssetsManager;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/** 画图解锁 */
	public class DrawGraphicUnlock extends Container
	{
		private var _image:Bitmap;
		
		private var _drawSprite:Sprite;
		
		private var _buttonList:Vector.<RollOverButton>;
		
		private var _passdword:String;
		
		private var _lastButton:RollOverButton;
		
		/** 画图解锁 */
		public function DrawGraphicUnlock()
		{
			super();
			_passdword = "";
			this.width = 350;
			this.height = 500;
			
			_image = new Bitmap(AssetsManager.getAssets("unlockView.png"));
			addChild(_image);
			_buttonList = new Vector.<RollOverButton>();
			initRollButton();
			_drawSprite = new Sprite();
			_drawSprite.graphics.lineStyle(10,0xffffff,0.7);
			addChild(_drawSprite);
			addEventListener(MultTouchEvent.TOUCH,onTouch);
		}
		
		/** 设置主题色 */
		public function set color(color:int):void{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			cacheAsBitmap = true;
		}
		
		/** 输入的密码 */
		public function get passdword():String{
			return _passdword;
		}
		
		/** 重置 */
		public function reSet():void{
			for each(var button:RollOverButton in _buttonList){
				button.reSet();
			}
			_drawSprite.graphics.clear();
			_drawSprite.graphics.lineStyle(10,0xffffff,0.7);
			_passdword = "";
			_lastButton = null;
		}
		
		//当移出或抬起
		private function onTouch(event:MultTouchEvent):void{
			if((event.touchType == MultTouchPhase.TOUCH_OUT && 
				!this.contains(event.touchPoint.target)) || 
				event.touchType == MultTouchPhase.TOUCH_END){
					this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onSelect(event:Event):void{
			var rollButton:RollOverButton = event.currentTarget as RollOverButton;
			_passdword += rollButton.id;
			if(_lastButton){
				_drawSprite.graphics.moveTo(_lastButton.x,_lastButton.y);
				_drawSprite.graphics.lineTo(rollButton.x,rollButton.y);
			}
			_lastButton = rollButton;
		}
		
		private function initRollButton():void{
			var r1:RollOverButton = new RollOverButton("1");
			r1.addEventListener(Event.SELECT,onSelect);
			r1.x = 75;r1.y =175;addChild(r1);_buttonList.push(r1);
			var r2:RollOverButton = new RollOverButton("2");
			r2.addEventListener(Event.SELECT,onSelect);
			r2.x = 175;r2.y =175;addChild(r2);_buttonList.push(r2);
			var r3:RollOverButton = new RollOverButton("3");
			r3.addEventListener(Event.SELECT,onSelect);
			r3.x = 275;r3.y =175;addChild(r3);_buttonList.push(r3);
			
			var r4:RollOverButton = new RollOverButton("4");
			r4.addEventListener(Event.SELECT,onSelect);
			r4.x = 75;r4.y =275;addChild(r4);_buttonList.push(r4);
			var r5:RollOverButton = new RollOverButton("5");
			r5.addEventListener(Event.SELECT,onSelect);
			r5.x = 175;r5.y =275;addChild(r5);_buttonList.push(r5);
			var r6:RollOverButton = new RollOverButton("6");
			r6.addEventListener(Event.SELECT,onSelect);
			r6.x = 275;r6.y =275;addChild(r6);_buttonList.push(r6);
			
			var r7:RollOverButton = new RollOverButton("7");
			r7.addEventListener(Event.SELECT,onSelect);
			r7.x = 75;r7.y =375;addChild(r7);_buttonList.push(r7);
			var r8:RollOverButton = new RollOverButton("8");
			r8.addEventListener(Event.SELECT,onSelect);
			r8.x = 175;r8.y =375;addChild(r8);_buttonList.push(r8);
			var r9:RollOverButton = new RollOverButton("9");
			r9.addEventListener(Event.SELECT,onSelect);
			r9.x = 275;r9.y =375;addChild(r9);_buttonList.push(r9);
		}
	}
}