package com.dt.core.component
{
	import com.dt.base.Container;
	import com.dt.controller.Scale9Button;
	import com.dt.core.AssetsManager;
	import com.greensock.TweenLite;
	import com.touch.MultTouchEvent;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	
	import org.qrcode.QRCode;
	
	public class RegisterMenu extends Container
	{
		private var _macCode:TextField;
		
		private var _codeInput:TextField;
		
		private var _tdCode:Bitmap;
		
		public function RegisterMenu()
		{
			super();
			this.width = 600;
			this.height = 350;
			init();
			addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
		}
		
		/** 设置主题色 */
		public function set color(value:int):void{
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		/** 设置机器码 */
		public function set mec(value:String):void{
			if(value)
			_macCode.text = value;
			var qrcode:QRCode=new QRCode();
			qrcode.encode(value);
			if(!_tdCode){
				_tdCode = new Bitmap(qrcode.bitmapData);
				_tdCode.x = 230;_tdCode.y = 20;
				_tdCode.width = 140;_tdCode.height = 140;
				addChild(_tdCode);
			}else{
				_tdCode.bitmapData = qrcode.bitmapData;
			}
		}
		
		/** 获取输入的text */
		public function get input():String{
			return _codeInput.text;
		}
		
		/** 关闭 */
		public function close():void{
			TweenLite.to(this,0.4,{x:parent.width,onComplete:remove});
		}
		
		private function onDelect(event:MultTouchEvent):void{
			if(_codeInput.text.length == 0){
				return;
			}
			_codeInput.text = _codeInput.text.substring(0,_codeInput.text.length-1);
		}
		
		private function onEnterComplete(event:MultTouchEvent):void{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onSelect(event:MultTouchEvent):void{
			_codeInput.appendText((event.currentTarget as Scale9Button).label);
		}
		
		private function onAddtoStage(event:Event):void{
			this.x = -width;
			this.y = (parent.height - height)/2;
			TweenLite.to(this,0.4,{x:(parent.width - width)/2});
		}
		
		private function onCloseSelect(event:MultTouchEvent):void{
			close();
		}
		
		private function remove():void{
			parent.removeChild(this);
		}

		
		//初始化组件
		private function init():void{
			var _tdCodeBg:Shape = new Shape();
			_tdCodeBg.graphics.beginFill(0xffffff);
			_tdCodeBg.graphics.drawRect(0,0,140,140);
			_tdCodeBg.graphics.endFill();
			_tdCodeBg.x = 230; _tdCodeBg.y = 20;
			_tdCodeBg.cacheAsBitmap = true;
			addChild(_tdCodeBg);
			
			_macCode  = new TextField();
			_macCode.defaultTextFormat = new TextFormat(null,18,0xffffff);
			_macCode.autoSize = TextFieldAutoSize.CENTER;
			_macCode.x = 100; _macCode.y = 170;
			_macCode.width = 400;
			_macCode.mouseEnabled = false;
			_macCode.cacheAsBitmap = true;
			addChild(_macCode);
			
			var inputBg:Shape = new Shape();
			inputBg.graphics.beginFill(0xffffff);
			inputBg.graphics.drawRect(0,0,400,24);
			inputBg.graphics.endFill();
			inputBg.width = 400;
			inputBg.x = 100;inputBg.y = 200;
			inputBg.cacheAsBitmap = true;
			addChild(inputBg);
			
			_codeInput = new TextField();
			_codeInput.defaultTextFormat = new TextFormat(null,16,0x000000);
			_codeInput.autoSize = TextFieldAutoSize.CENTER;
			_codeInput.x = 100; _codeInput.y = 200;
			_codeInput.width = 400;
			_codeInput.mouseEnabled = false;
			addChild(_codeInput);
			
			var closeButton:Scale9Button = new Scale9Button(
				AssetsManager.getAssets("closeButton.png"),
				AssetsManager.getAssets("closeButtonOn.png"));
			closeButton.width = closeButton.height = 40;
			closeButton.x = 550;closeButton.y = 10;
			closeButton.addEventListener(MultTouchEvent.SELECT,onCloseSelect);
			addChild(closeButton);
			
			var b0:Scale9Button = new Scale9Button();
			b0.width = 40 ;b0.height = 24;
			b0.x = 100 ;b0.y= 250
			b0.label= "0";
			b0.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b0);
			
			var b1:Scale9Button = new Scale9Button();
			b1.width = 40 ;b1.height = 24;
			b1.x = 145 ;b1.y= 250;
			b1.label= "1";
			b1.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b1);
			
			var b2:Scale9Button = new Scale9Button();
			b2.width = 40 ;b2.height = 24;
			b2.x = 190 ;b2.y= 250;
			b2.label= "2";
			b2.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b2);
			
			var b3:Scale9Button = new Scale9Button();
			b3.width = 40 ;b3.height = 24;
			b3.x = 235 ;b3.y= 250;
			b3.label= "3";
			b3.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b3);
			
			var b4:Scale9Button = new Scale9Button();
			b4.width = 40 ;b4.height = 24;
			b4.x = 280 ;b4.y= 250;
			b4.label= "4";
			b4.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b4);
			
			var b5:Scale9Button = new Scale9Button();
			b5.width = 40 ;b5.height = 24;
			b5.x = 325 ;b5.y= 250;
			b5.label= "5";
			b5.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b5);
			
			var b6:Scale9Button = new Scale9Button();
			b6.width = 40 ;b6.height = 24;
			b6.x = 370 ;b6.y= 250;
			b6.label= "6";
			b6.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b6);
			
			var b7:Scale9Button = new Scale9Button();
			b7.width = 40 ;b7.height = 24;
			b7.x = 415 ;b7.y= 250;
			b7.label= "7";
			b7.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b7);
			
			var b8:Scale9Button = new Scale9Button();
			b8.width = 40 ;b8.height = 24;
			b8.x = 100 ;b8.y= 280;
			b8.label= "8";
			b8.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b8);
			
			var b9:Scale9Button = new Scale9Button();
			b9.width = 40 ;b9.height = 24;
			b9.x = 145 ;b9.y= 280;
			b9.label= "9";
			b9.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(b9);
			
			var ba:Scale9Button = new Scale9Button();
			ba.width = 40 ;ba.height = 24;
			ba.x = 190 ;ba.y= 280
			ba.label= "A";
			ba.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(ba);
			
			var bb:Scale9Button = new Scale9Button();
			bb.width = 40 ;bb.height = 24;
			bb.x = 235 ;bb.y= 280
			bb.label= "B";
			bb.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(bb);
			
			var bc:Scale9Button = new Scale9Button();
			bc.width = 40 ;bc.height = 24;
			bc.x = 280 ;bc.y= 280
			bc.label= "C";
			bc.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(bc);
			
			var bd:Scale9Button = new Scale9Button();
			bd.width = 40 ;bd.height = 24;
			bd.x = 325 ;bd.y= 280
			bd.label= "D";
			bd.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(bd);
			
			var be:Scale9Button = new Scale9Button();
			be.width = 40 ;be.height = 24;
			be.x = 370 ;be.y= 280
			be.label= "E";
			be.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(be);
			
			var bf:Scale9Button = new Scale9Button();
			bf.width = 40 ;bf.height = 24;
			bf.x = 415 ;bf.y= 280
			bf.label= "F";
			bf.addEventListener(MultTouchEvent.SELECT,onSelect);
			addChild(bf);
			
			var back:Scale9Button = new Scale9Button();
			back.width = 40 ;back.height = 24;
			back.x = 460 ;back.y= 250
			back.label= "DEL";
			back.addEventListener(MultTouchEvent.SELECT,onDelect);
			addChild(back);
			
			var enter:Scale9Button = new Scale9Button();
			enter.width = 40 ;enter.height = 24;
			enter.x = 460 ;enter.y= 280
			enter.label= "OK";
			enter.addEventListener(MultTouchEvent.SELECT,onEnterComplete);
			addChild(enter);
		}
	}
}