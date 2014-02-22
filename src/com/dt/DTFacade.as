package com.dt
{
	import com.dt.core.Configuration;
	import com.dt.core.SettingView;
	import com.dt.page.PageManager;
	import com.dt.servers.ServerFacade;
	import com.touch.MultTouchManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;

	public class DTFacade
	{
		//------------------------------------------------------------
		private static var _current:DTFacade;
		
		public static function get current():DTFacade{
			return _current;
		}
		//------------------------------------------------------------
		private var _stage:Stage;
		
		private var _container:Sprite;
		
		private var _pageManager:PageManager;
		
		private var _setting:SettingView;
		
		private var _configuration:Configuration;
		
		private var _server:ServerFacade;
		
		/** 核心类 初始化舞台与层级 */
		public function DTFacade()
		{
			if(_current)throw new Error("全局只能实例化一个DTFacade");
			_current = this;
		}
		
		/** 初始化 */
		public function init(container:Sprite):void{
			_container = container;
			_stage = _container.stage;
			
			// 1 - 配置文件加载
			_configuration = new Configuration();
			
			// 2 - 页面层级初始化
			_pageManager = new PageManager();
			_container.addChild(_pageManager);
			_setting = new SettingView();
			_container.addChild(_setting);
			_setting.init(_configuration.config);
			
			// 3 - 核心初始化
			MultTouchManager.current.init(container.stage);
			
			// 4 - 服务初始化
			_server = new ServerFacade();
			_server.init(_configuration.setting);
			
			// 5 - 检查Key
			
			
			// 6 - 初始化页面
			//_pageManager.init(null)
		}
		
		/** 舞台大小 */
		public function get width():Number{
			return _stage.stageWidth;
		}
		
		/** 舞台大小 */
		public function get height():Number{
			return _stage.stageHeight;
		}
		
		/** 舞台 */
		public function get stage():Stage{
			return _stage;
		}
		
		/** 服务 */
		public function get server():ServerFacade{
			return _server;
		}
		
		/** 配置信息 */
		public function get configuration():Configuration{
			return _configuration;
		}
		
		/** 页面管理器 */
		public function get pageManager():PageManager{
			return _pageManager;
		}
	}
}