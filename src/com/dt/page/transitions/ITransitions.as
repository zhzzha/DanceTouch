package com.dt.page.transitions
{
	import com.dt.page.DefaultPage;
	
	import flash.events.IEventDispatcher;

	public interface ITransitions extends IEventDispatcher
	{
		function start(original:DefaultPage,objective:DefaultPage):void;
		function get originalPage():DefaultPage;
		function get objectivePage():DefaultPage;
		function dispose():void;
	}
}