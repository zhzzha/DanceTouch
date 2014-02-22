package com.dt.core
{
	import com.dt.base.Container;
	import com.dt.core.component.MsgBox;
	import com.dt.core.component.MsgFloat;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class MsgManager extends Container
	{
		//------------------------------------------------------------------
		private static var _msg:MsgManager;
		/** 单例 */
		public static function get current():MsgManager{
			if(!_msg){
				_msg = new MsgManager();
			}
			return _msg;
		}
		//-----------------------------------------------------------------
		
		private var _msgList:Vector.<MsgBox>;
		
		private var _msgMask:Bitmap;
		
		/** 消息管理，提示消息、漂浮消息 */
		public function MsgManager()
		{
			super();
			this.width = currentWidth;
			this.height = currentHeight;
			_msgList = new Vector.<MsgBox>();
			
			_msgMask = new Bitmap(new BitmapData(width,height,true,0x99000000));
		}
		
		/** 漂浮信息 */
		public function addFloat(msg:String):void{
			var msgFloat:MsgFloat = new MsgFloat(msg,DTConfig.MainColor);
			msgFloat.x = (this.width - msgFloat.width)/2;
			//trace("this.width"+this.width+"  msgFloat.width"+ msgFloat.width+" msgFloat.x"+msgFloat.x);
			msgFloat.y = -msgFloat.height;
			addChild(msgFloat);
			TweenLite.to(msgFloat,0.5,{y:80,ease:Back.easeOut,
					onComplete:trunBackMsg,onCompleteParams:[msgFloat]});
		}
		
		/** 提示窗口 */
		public function addMsgBox(msg:MsgBox):void{
			_msgList.push(msg);
			if(_msgList.length == 1){
				showMsgBox();
			}
		}
		
		/** 提示窗口  */
		public function addMsgBoxEasy(text:String,title:String="警告",option:Array = null):MsgBox{
			var msgbox:MsgBox = new MsgBox(title,text);
			if(option){
				while(option.length > 0){
					msgbox.addOption(option.shift() as String);
				}
			}else{
				msgbox.addOption("确定");
			}
			addMsgBox(msgbox);
			return msgbox
		}
		
		//步骤1
		private function trunBackMsg(msgFloat:MsgFloat):void{
			TweenLite.to(msgFloat,0.5,{y:-msgFloat.height,ease:Back.easeIn,delay:3,
				onComplete:removeMsg,onCompleteParams:[msgFloat]});
		}
		
		//步骤2
		private function removeMsg(msgFloat:MsgFloat):void{
			removeChild(msgFloat);
		}
		
		//步骤1 
		private function showMsgBox():void{
			addChild(_msgMask);
			var msg:MsgBox = _msgList[0];
			addChild(msg);
			msg.addEventListener(Event.SELECT,onSelect);
		}
		
		//步骤2
		private function onSelect(event:Event):void{
			removeChild(_msgMask);
			var msg:MsgBox = _msgList.shift();
			msg.removeEventListener(Event.SELECT,onSelect);
			removeChild(msg);
			msg.dispose();
			if(_msgList.length>0){
				showMsgBox();
			}
		}
	}
}