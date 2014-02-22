package com.dt.page.transitions
{
	import com.dt.base.Container;
	import com.dt.events.PageEvent;
	import com.dt.page.DefaultPage;
	import com.greensock.TweenLite;
	
	import flash.events.EventDispatcher;
	
	public class FoldTransitions extends EventDispatcher implements ITransitions
	{
		private var _container:Container;
		
		private var _orginal:DefaultPage;
		
		private var _objective:DefaultPage;
		
		public function FoldTransitions(container:Container)
		{
			_container = container;
		}
		
		public function start(original:DefaultPage, objective:DefaultPage):void
		{
			_orginal = original;
			_objective = objective;
			TweenLite.to(_orginal,0.3,{x:_container.width/2,scaleX:0,onComplete:onNext});
		}
		
		public function get originalPage():DefaultPage{
			return _orginal;
		}
		
		public function get objectivePage():DefaultPage{
			return _objective;
		}
		
		public function dispose():void
		{
			_container = null;
			_orginal = null;
			_objective = null;
		}
		
		private function onNext():void{
			_objective.scaleX = 0;
			_objective.x = _container.width / 2;
			_container.addChild(_objective);
			TweenLite.to(_objective,0.3,{x:0,scaleX:1,onComplete:onComplete});
		}
		
		private function onComplete():void{
			_container.removeChild(_orginal);
			_orginal.x = 0;
			_orginal.scaleX = 1;
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_CONPLETE))
		}
	}
}