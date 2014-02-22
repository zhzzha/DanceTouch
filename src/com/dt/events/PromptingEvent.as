package com.events
{
	import flash.events.Event;
	
	public class PromptingEvent extends Event
	{
		public static const Enter_SUCCESS:String="Enter_SUCCESS";//密码输入
		
		public static const MENUS_SELECTION:String="MENUS_SELECTION";//菜单选择
		
		public static const REG_OK:String="REG_OK";//注册界面关闭
		
		public static const EDIT_OK:String="EDIT_OK";//
		
		public static const RBUTTON_CHOISE:String="RBUTTON_CHOISE";//按钮选中
		
		//传递的参数
		public var data:String;
		
		public function PromptingEvent(type:String)
		{
			super(type);
		}
	}
}