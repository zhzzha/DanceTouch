package com.dt.core.component
{
	import com.dt.controller.Scale9Button;
	import com.dt.core.AssetsManager;
	import com.dt.core.DTConfig;
	import com.greensock.TweenLite;
	import com.touch.MultTouchEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MsgBox extends Sprite
	{
		private var _contant:Sprite;
		
		private var _icon:Bitmap;
		
		private var _label:TextField;
		
		private var _text:TextField;
		
		private var _selectItem:String;
		
		private var _borderButton:Vector.<Scale9Button>;
		
		public function MsgBox(label:String,text:String)
		{
			super();
			_contant = new Sprite();
			_contant.y = 10;
			addChild(_contant);
			_borderButton = new Vector.<Scale9Button>();
			
			_icon = new Bitmap(AssetsManager.getAssets("promptIcon.png"));
			_contant.addChild(_icon);
			
			_label = new TextField();
			_label.defaultTextFormat = 
				new TextFormat(null,32,0xffffff);
			_label.cacheAsBitmap = true;
			_label.mouseEnabled = false;
			_label.x = _icon.width + 10;
			_label.text = label;
			_label.cacheAsBitmap = true;
			_contant.addChild(_label);
			
			_text = new TextField();
			_text.defaultTextFormat = 
				new TextFormat(null,16,0xffffff);
			_text.cacheAsBitmap = true;
			_text.mouseEnabled = false;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.wordWrap = true;
			_text.width = 360;
			_text.y = 35;
			_text.x = _icon.width + 10;
			_text.text = text;
			_text.cacheAsBitmap = true;
			_contant.addChild(_text);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		/** 增加一个选项 */
		public function addOption(str:String):void{
			var button:Scale9Button = new Scale9Button();
			button.label = str;
			button.addEventListener(MultTouchEvent.SELECT,onOptionSelect);
			_borderButton.push(button);
			_contant.addChild(button);
			
			if(_borderButton.length > 1){
				var startX:Number = _borderButton[_borderButton.length-2].x;
				button.x = startX - button.width - 10;
				button.y = _borderButton[_borderButton.length-2].y;
			}else{
				button.x = this.width - button.width - 10;
				var textStandard:Number = _text.y + _text.height + 5;
				var iconStandard:Number = _icon.y + _icon.height - button.height;
				button.y = textStandard > iconStandard ? textStandard:iconStandard;
			}

				

		}
		
		/** 清除引用 */
		public function dispose():void{
			removeEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		/** 选择的项 */
		public function get select():String{
			return _selectItem;
		}
		
		private function onOptionSelect(event:MultTouchEvent):void{
			_selectItem = (event.currentTarget as Scale9Button).label;
			
			TweenLite.to(_contant,0.3,{alpha:0,onComplete:hiddenMsg})
		}
		
		private function onAddStage(event:Event):void{
			graphics.beginFill(DTConfig.MainColor);
			graphics.drawRect(0,0,parent.width,_contant.height + 20);
			graphics.endFill();
			cacheAsBitmap = true;
			
			this.scaleY = 0;
			this.y = parent.height / 2;
			this._contant.alpha = 0;
			this._contant.x = (parent.width - _contant.width)/2;
			TweenLite.to(this,0.3,{y:(parent.height - _contant.height+20)/2,scaleY:1,
				onComplete:showMsg});
		}
		
		private function showMsg():void{
			TweenLite.to(_contant,0.3,{alpha:1})
		}
		
		private function hiddenMsg():void{
			TweenLite.to(this,0.3,{y:parent.height/2,scaleY:0,
				onComplete:result});
		}
		
		private function result():void{
			this.dispatchEvent(new Event(Event.SELECT));
		}
	}
}