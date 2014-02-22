package com.dt.core.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MsgFloat extends Sprite
	{
		private var text:TextField;
		
		public function MsgFloat(str:String,color:int)
		{
			super();
			var textformat:TextFormat=new TextFormat();
			textformat.size=24;
			textformat.color=0xffffff;
			
			text=new TextField();
			text.autoSize=TextFieldAutoSize.CENTER;
			text.defaultTextFormat=textformat;
			text.text=str;
			text.mouseEnabled=false;
			text.cacheAsBitmap = true;
			this.addChild(text);
			
			text.x = -text.textWidth/2;
			text.y = -text.textHeight/2;
			
			this.graphics.beginFill(color);
			this.graphics.drawRect(text.x - 5,text.y -5,text.textWidth+10,text.textHeight+10);
			this.graphics.endFill();
			this.cacheAsBitmap = true;
		}
	}
}