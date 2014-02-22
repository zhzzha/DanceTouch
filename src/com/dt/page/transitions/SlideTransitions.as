package com.dt.page.transitions
{
	import com.dt.base.Container;
	import com.dt.events.PageEvent;
	import com.dt.page.DefaultPage;
	import com.greensock.TweenLite;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SlideTransitions extends EventDispatcher implements ITransitions
	{
		private var _container:Container;
		
		private var _orginal:DefaultPage;
		
		private var _objective:DefaultPage;
			
		public function SlideTransitions(container:Container)
		{
			_container = container;
		}
		
		public function start(original:DefaultPage, objective:DefaultPage):void
		{
			_orginal = original;
			_objective = objective;
			_objective.x = _container.width;
			_container.addChild(_objective);
			TweenLite.to(_objective,0.6,{x:0,onComplete:onComplete});
		}
		
		public function get originalPage():DefaultPage
		{
			return _orginal;
		}
		
		public function get objectivePage():DefaultPage
		{
			return _objective;
		}
		
		public function dispose():void
		{
			_container = null;
			_orginal = null;
			_objective = null;
		}
		
		private function onComplete():void{
			_container.removeChild(_orginal);
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_CONPLETE))
		}
	}
}