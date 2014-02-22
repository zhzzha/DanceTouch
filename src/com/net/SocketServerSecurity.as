package com.net
{
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class SocketServerSecurity
	{
		//--------------------------------
		//单例模式
		private static var _socketSafe:SocketServerSecurity;
		
		public static function getSocketServersecurity():SocketServerSecurity{
			if(_socketSafe==null){
				_socketSafe=new SocketServerSecurity();
			}
			return _socketSafe;
		}
		//-------------------------------------------------------------------
		private const SECURITY_XML:XML =
			<cross-domain-policy>
				<site-control permitted-cross-domain-policies="all"/>
				<allow-access-from domain="*" to-ports="*"/>
			</cross-domain-policy>;
		
		private var _securityByte:ByteArray;
		
		private var _server:ServerSocket;
		
		/**
		 * 服务器跨域访问安全沙箱
		 */	
		public function SocketServerSecurity()
		{
			_server=new ServerSocket();
			_securityByte = new ByteArray();
		}
		
		/**
		 * 启动安全服务
		 */
		public function start(_ip:String="0.0.0.0",_port:int=843,securityXml:XML=null):void{
			if(_server.listening){
				_server.close();
			}
			_securityByte.clear();
			if(securityXml==null){
				_securityByte.writeUTFBytes(SECURITY_XML);
			}else{
				_securityByte.writeUTFBytes(securityXml);
			}
			_server.bind(_port,_ip);
			_server.addEventListener(ServerSocketConnectEvent.CONNECT,onconnect);
			_server.listen();
		}
		
		/**
		 * 关闭连接
		 */
		public function close():void{
			_server.close();
		}
		
		//出现新请求后发送策略文件
		private function onconnect(event:ServerSocketConnectEvent):void{
			var tempSocket:Socket=event.socket;
			tempSocket.writeBytes(_securityByte);
			tempSocket.flush();
			tempSocket.close();
		}
	}
}