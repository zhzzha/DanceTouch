package com.dt.page
{
	import com.dt.base.Container;
	import com.dt.events.PageEvent;
	import com.dt.page.DefaultPage;
	import com.dt.page.transitions.ITransitions;
	import com.dt.page.transitions.TransitionsFactory;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.Timer;
	
	public class PageManager extends Container
	{
		private var _maxPoolCount:int = 0;
		
		private var _timer:Timer;
		
		private var _currentPage:DefaultPage;
		
		private var _currentTransitions:ITransitions;
		
		private var _pagePool:Vector.<DefaultPage>;
		
		private var _xmlList:XMLList;
		
		private var _defaultPageID:String;
		
		private var _welcomePageID:String;
		
		public function PageManager(){
			_pagePool = new Vector.<DefaultPage>();
		}
		
		/** 页面初始化 */
		public function init(xmlList:XMLList):void{
			_xmlList = xmlList;
			
			_defaultPageID = "0";//
			_welcomePageID = "0";//
		}
		
		/** 加载页面 */
		public function loadPageByID(id:String):void{
			var page:DefaultPage = getPage(id);
			if(!page){
				//找不到page
				return;
			}
			page.addEventListener(PageEvent.INIT_COMPLETE,onPageInit);
			page.init();
		}
		
		//页面初始化完成
		private function onPageInit(event:PageEvent):void{
			var page:DefaultPage = event.currentTarget as DefaultPage;
			if(_currentPage){
				switchToPage(page);
			}else{
				_currentPage = page;
				addChild(_currentPage);
			}
		}
		
		//转场动画  跳转到页面
		private function switchToPage(page:DefaultPage):void{
			_currentTransitions = TransitionsFactory.getTransitions(page.transitions,this);
			_currentTransitions.addEventListener(PageEvent.TRANSITION_CONPLETE,onComplete);
			_currentTransitions.start(_currentPage,page);
		}
		
		//转场结束
		private function onComplete(event:PageEvent):void{
			_currentTransitions.removeEventListener(PageEvent.TRANSITION_CONPLETE,onComplete);
			returnPage(_currentTransitions.originalPage);
			_currentPage = _currentTransitions.objectivePage;
			_currentTransitions.dispose();
		}
		
		//从池中找到PAGE  如果没有则实例化
		private function getPage(id:String):DefaultPage{
			var page:DefaultPage;
			if(_maxPoolCount > 0){
				var len:int = _pagePool.length;
				for(var i:int = 0 ; i < len ; i++){
					if(_pagePool[i].pageID == id){
						page = _pagePool[i];
						_pagePool.splice(i,1);
						return page;
					}
				}
			}
			for each(var xml:XML in _xmlList){
				if(xml.@pageID == id){
					return new DefaultPage(xml);
				}
			}
			return null;
		}
		
		//将页面送回池中
		private function returnPage(page:DefaultPage):void{
			page.forbidden();
			_pagePool.push(page);
			if(_pagePool.length > _maxPoolCount){
				_pagePool.shift().dispose();
			}
		}
		
	}
}