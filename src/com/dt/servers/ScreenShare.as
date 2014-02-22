package com.dt.servers
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class ScreenShare
	{
		private var _server:ServerSocket;
		
		private var _stage:Stage;
		
		private var _bitmapdata:BitmapData;
		
		private var _cache:ByteArray;
		
		private var _config:JPEGEncoderOptions;
		
		public function ScreenShare()
		{
			_config = new JPEGEncoderOptions(50);
		}
		
		public function init(stage:Stage):void{
			_stage = stage;
			_bitmapdata = new BitmapData(_stage.stageWidth,_stage.stageHeight,false);
			_stage.addEventListener(Event.EXIT_FRAME,onRenderStage);
		}
		
		public function close():void{
			if(_server){
				_server.close();
			}
		}
		
		private function startServer():void{
			if(!_server)_server = new ServerSocket();
			if(_server.bound){
				_server.close();
				_server = new ServerSocket();
			}
			_server.bind(762,"0.0.0.0");
			_server.addEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
		}
		
		private function onRenderStage(event:Event):void{
			_bitmapdata.draw(_stage);
			if(_cache)_cache.clear();
			_cache = _bitmapdata.encode(_bitmapdata.rect,_config);
		}
		
		private function onConnect(event:ServerSocketConnectEvent):void{
			var socket:Socket = event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
			socket.addEventListener(Event.CLOSE,onClose);
		}
		
		private function onData(event:ProgressEvent):void{
			//读出请求内容
			var target:Socket = event.currentTarget as Socket;
			var byte:ByteArray = new ByteArray();
			switch(readLine(target).toString()){
				case "get_image":
					target.writeUTF("get_image"+"\r\n");
					target.writeInt(_cache.length);
					target.writeBytes(_cache);
					target.flush();
					break;
				default:
					return; 
			}
		}
		
		private function onClose(event:Event):void{
			
		}
		
		//读取一行
		private function readLine(target:Socket):ByteArray{
			var line:ByteArray=new ByteArray();
			var oneByte:int;
			var readLength:int = 0;
			while(true){
				if((oneByte = target.readByte()) == 13){
					if((oneByte = target.readByte()) == 10){
						return line;
					}
					line.writeByte(13);
					readLength++;
				}
				line.writeByte(oneByte);
				readLength++;
				if(readLength > 1024*1024*1024){
					target.close();
				}
			}
			return line;
		}
	}
}