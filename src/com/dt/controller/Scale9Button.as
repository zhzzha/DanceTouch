package com.dt.controller
{
	import com.dt.base.Container;
	import com.dt.core.AssetsManager;
	import com.dt.core.DTConfig;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/** 九宫格按钮  在不传入九宫格时将正常显示 */
	public class Scale9Button extends Container
	{
		public static const CENTER:String = "center";
		
		public static const BOTTOM:String = "bottom";
		
		public static const RIGHT:String = "right";
		
		private var _text:TextField;
		
		private var _defaultSkin:Bitmap;
		
		private var _touchOnSkin:Bitmap;
		
		private var _textDirection:String;
		
		/** 九宫格按钮 */
		public function Scale9Button(defaultSkin:BitmapData=null,
									 touchOnSkin:BitmapData=null,
									 scaleRect:Rectangle = null)
		{
			super();
			if(defaultSkin){
				_defaultSkin = new Bitmap(defaultSkin,"auto",true);
				if(scaleRect)_defaultSkin.scale9Grid = scaleRect;
			}else{
				_defaultSkin = new Bitmap(AssetsManager.getAssets("borderButton.png"),"auto",true);
				_defaultSkin.scale9Grid = new Rectangle(2,2,56,21);
			}
			addChild(_defaultSkin);
			if(touchOnSkin){
				_touchOnSkin = new Bitmap(touchOnSkin,"auto",true);
				if(scaleRect)_touchOnSkin.scale9Grid = scaleRect;
			}else{
				_touchOnSkin = new Bitmap(AssetsManager.getAssets("borderButtonOn.png"),"auto",true);
				_touchOnSkin.scale9Grid = new Rectangle(2,2,56,21);
			}
			_touchOnSkin.visible = false;
			addChild(_touchOnSkin);
			initComponent();
			addEventListener(MultTouchEvent.TOUCH,onTouch);
		}
		
		/** 设置文本默认格式 */
		public function set textFormat(value:TextFormat):void{
			_text.defaultTextFormat = value;
		}
		
		/** 按钮显示名称 */
		public function set label(value:String):void{
			_text.text = value;
			if(width < _text.textWidth || height < _text.textHeight){
				width = _text.textWidth + 10;
				height = _text.textHeight + 10;
			}else{
				resizeText();
			}
		}
		
		/** 标签 */
		public function get label():String{
			return _text.text;
		}
		
		/** 設置SKIN */
		public function setSkins(defaultSkin:BitmapData,touchOnSkin:BitmapData,
								scaleRect:Rectangle = null):void{
			_defaultSkin.bitmapData = defaultSkin;
			_touchOnSkin.bitmapData = touchOnSkin;
			if(scaleRect){
				_defaultSkin.scale9Grid = scaleRect;
				_touchOnSkin.scale9Grid = scaleRect;
			}
		}
		
		override protected function resize():void{
			_defaultSkin.width = _touchOnSkin.width = width;
			_defaultSkin.height = _touchOnSkin.height = height;
			resizeText();
		}
		
		private function resizeText():void{
			if(_textDirection == BOTTOM){
				_text.y = this.height;
				_text.x = (width - _text.textWidth - 4)/2;
			}else if(_textDirection == RIGHT){
				_text.x = this.width;
				_text.y = (height - _text.textHeight - 4)/2;
			}else{
				_text.x = (width - _text.textWidth - 4)/2;
				_text.y = (height - _text.textHeight - 4)/2;
			}
		}
		
		private function initComponent():void{
			_textDirection = CENTER;
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(null,16,0xffffff);
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.cacheAsBitmap = true;
			_text.mouseEnabled = false;
			addChild(_text);
			
			width = _defaultSkin.width;
			height = _defaultSkin.height;
		}
		
		private function onTouch(event:MultTouchEvent):void{
			if(event.touchType == MultTouchPhase.TOUCH_BEGAN){
				_touchOnSkin.visible = true;
			}else if(event.touchType == MultTouchPhase.TOUCH_END){
				_touchOnSkin.visible = false;
				if(this.contains(event.touchPoint.startTarget) && 
					this.contains(event.touchPoint.target)){
					this.dispatchEvent(new MultTouchEvent(MultTouchEvent.SELECT));
				}
			}
		}
	}
}