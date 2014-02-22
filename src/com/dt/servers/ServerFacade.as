package com.dt.servers
{
	import com.dt.DTFacade;
	import com.net.HttpServer;
	import com.net.SocketServerSecurity;
	import com.net.httpServer.HttpParameter;
	import com.touch.MultTouchManager;
	import com.touch.extension.RemoteModule;
	import com.touch.extension.TuioModule;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public class ServerFacade
	{
		private var _backgroundMusic:BackgroundMusic;
		
		private var _remoteModule:RemoteModule;
		
		private var _tuioModule:TuioModule;
		
		private var _webServer:HttpServer;
		
		private var _screenShare:ScreenShare;
		
		private var _safeServer:SocketServerSecurity;
		
		public function ServerFacade()
		{
			
		}
		
		/** 初始化 传入设置 */
		public function init(xml:XML):void{
			//启动背景音乐服务
			if(xml.Sound.@enable == "true"){
				if(!_backgroundMusic)_backgroundMusic=new BackgroundMusic();
				_backgroundMusic.setPlaylist(xml.Sound[0],true);
			}else{
				if(_backgroundMusic)_backgroundMusic.stop();
			}
			
			//TUIO协议
			if(xml.Tuio.@enable == "true"){
				if(!_tuioModule){
					_tuioModule = new TuioModule();
					MultTouchManager.current.addModule(_tuioModule);
				}
				_tuioModule.setHost();
			}else{
				if(_tuioModule)_tuioModule.dispose();
			}
			
			//安全协议
			if(xml.Security.@enable == "true"){
				if(!_safeServer){
					_safeServer = new SocketServerSecurity();
					_safeServer.start();
				}
			}
			
			//虚拟触摸服务
			if(xml.Simulator.@enable == "true"){
				if(!_remoteModule){
					_remoteModule=new RemoteModule();
					MultTouchManager.current.addModule(_remoteModule);
				}
				_remoteModule.setHost("0.0.0.0");
			}else{
				if(_remoteModule)_remoteModule.dispose();
			}
			
			//屏幕共享
			if(xml.ScreenShare.@enable == "true"){
				if(!_screenShare){
					_screenShare = new ScreenShare();
				}
				_screenShare.init(DTFacade.current.stage);
			}else{
				if(_screenShare)_screenShare.close();
			}
			
			//webServer
			if(xml.WebServer.@enable == "true"){
				if(!_webServer){
					_webServer = new HttpServer();
				}					
				_webServer.start();
			}else{
				if(_webServer)_webServer.stop();
			}
		}
		
		//根据设置获取IP配置
		//已停用
		private function getIPSetting(mode:String,parameter:String=""):String{
			if(mode == "NetWorkCard"){
				var defaultNetwork:NetworkInterface;
				var networkinfo:Vector.<NetworkInterface>=
					NetworkInfo.networkInfo.findInterfaces();
				for each(var networkinterface:NetworkInterface in networkinfo){
					if(networkinterface.name == parameter){
						defaultNetwork = networkinterface;
						break;
					}
				}
				if(defaultNetwork == null){
					return "";
				}else{
					return defaultNetwork.addresses[0].address;
				}
			}else{
				return parameter;
			}
		}
	}
}