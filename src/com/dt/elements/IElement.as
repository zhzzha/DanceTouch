package com.dt.elements
{
	public interface IElement
	{
		function init(xml:XML):void;
		function activate():void;
		function forbidden():void;
		function dispose():void;
		
		//function ex
		
		function get id():String;
		function get title():String;
	}
}