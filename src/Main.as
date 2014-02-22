package
{
	import com.dt.DTFacade;
	import com.dt.core.MsgManager;
	import com.dt.core.component.MsgBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	[SWF(width="800",height="600",frameRate = "60")]
	public class Main extends Sprite
	{
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void{
			new DTFacade().init(this);
			//new MultTouchHelper(stage,0);
			stage.addEventListener(Event.SELECT,onSelect);
		}
		
		private function onSelect(event:Event):void{
			MsgManager.current.addFloat("测试漂浮");
			var msg:MsgBox = MsgManager.current.
				addMsgBoxEasy("测试状态测试状态 测试状态测试状态 测试状态测试状态",
					"警告",["确定","取消","重试","过一会再试"]);
			msg.addEventListener(Event.SELECT,onClick);
		}
		
		private function onClick(event:Event):void{
			trace((event.currentTarget as MsgBox).select);
		}
	}
}