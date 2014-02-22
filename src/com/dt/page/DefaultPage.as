package com.dt.page
{
	
	import com.dt.base.Container;
	import com.dt.elements.ElementFactory;
	import com.dt.elements.IElement;
	import com.dt.events.PageEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.html.script.Package;
	
	public class DefaultPage extends Container
	{
		private var _xml:XML;
		
		private var _pageID:String;
		
		private var _isReady:Boolean;
		
		private var _backGround:*;
		
		private var _elementList:Vector.<IElement>;
		
		private var _levelElementList:Vector.<IElement>;
		
		public function DefaultPage(xml:XML)
		{
			_isReady = false;
			_xml = xml;
			_pageID = _xml.@pageID;
		}
		
		/** 初始化 */
		public function init():void{
			if(_isReady){
				activate();
			}else{
				loadElement();
			}
		}
		
		/** 激活页面 */
		public function activate():void{
			this.dispatchEvent(new PageEvent(PageEvent.INIT_COMPLETE));
		}
		
		/** 停用页面 */
		public function forbidden():void{
			
		}
		
		/** 引用ID */
		public function get id():String{
			return _xml.@id;
		}
 		
		/** 标题 */
		public function get title():String{
			return _xml.@title;
		}
		
		/** ID */
		public function get pageID():String{
			return _pageID;
		}
		
		/** 转场效果 */
		public function get transitions():String{
			return _xml.@transitions;
		}
		
		/** 销毁 */
		public function dispose():void{
			
		}
		
		//加载元素
		private function loadElement():void{
			var element:IElement;
			for each(var node:XML in _xml){
				element = ElementFactory.getElement(node.name());
				if(element){
					_elementList.push(element);
					element.init(node);
					addChild(element as DisplayObject);
				}
			}
			this.dispatchEvent(new PageEvent(PageEvent.INIT_COMPLETE));
		}
		
		//加载二级元素
		private function loadLevelElement():void{
			//for each(var node:XML in _xml){
			//	
			//}
		}
	}
}