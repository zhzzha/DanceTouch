package com.net.httpServer
{
	import com.net.events.HttpEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/** 当出现post数据时 */
	[Event(name="data_arrive", type="com.net.events.HttpEvent")]
	
	/** 当请求已经建立 */
	[Event(name="request_ready", type="com.net.events.HttpEvent")]
	
	public class HttpRequest extends EventDispatcher
	{
		private var _requestParameter:Dictionary;
		
		private var _requestParameterList:Array;
		
		private var _urlParameter:Dictionary;
		
		private var _urlParameterList:Array;
		
		private var _httpPara:HttpParameter;
		
		private var _socket:Socket;
		
		private var _url:String;
		
		private var _file:File;
		
		private var _mode:String;
		
		
		/** Http请求 */
		public function HttpRequest(stream:Socket,parameter:HttpParameter)
		{
			_socket = stream;
			_httpPara = parameter;
			_requestParameter = new Dictionary();
			_urlParameter = new Dictionary();
			_requestParameterList = new Array();
			_urlParameterList = new Array();
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
		}
		
		/** 关闭会话 */
		public function close():void{
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA,onData);
			_socket.flush();
			_socket.close();
		}
		
		/** 请求地址 */
		public function getURL():String{
			return _url;
		}
		
		/** 请求的方法 */
		public　function getMode():String{
			return _mode;
		}
		
		/** 请求的连接 */
		public function getSocket():Socket{
			return _socket;
		}
		
		/** 对应请求参数 */
		public function getAttribute(key:String):String{
			return _requestParameter[key];
		}
		
		/** HTTP配置文件 */
		public function getHttpParameter():HttpParameter{
			return _httpPara;
		}
		
		/** 请求参数列表 */
		public function getAttributeList():Array{
			return _requestParameterList;
		}
		
		/** get参数 */
		public function getParameter(key:String):String{
			return _urlParameter[key];
		}
		
		/** get参数列表 */
		public function getParameterList():Array{
			return _urlParameterList;
		}
		
		/** post数据 */
		public function getPostData():ByteArray{
			
			return null;
		}
		
		/** 如果请求的地址是一个文件返回这个文件 否则返回null */
		public function getFile():File{
			if(_file)return _file;
			_file = _httpPara.getDefaultFolder().resolvePath(_url);
			if(_file.exists && !_file.isDirectory)return _file;
			for each(var name:String in _httpPara.getDefaultPageList()){
				var defaultFile:File = _file.resolvePath(name);
				if(defaultFile.exists && !defaultFile.isDirectory){
					_file = defaultFile;
					return _file;
				}
			}
			_file = null;
			return null;
		}
		
		//----------------------------------------------------------------
		public function get bytesAvailable():int{
			return _socket.bytesAvailable;
		}
		public function readOneByte():int{
			return _socket.readByte();
		}
		public function readBytes(bytes:ByteArray,offset:uint=0,length:uint=0):void{
			return _socket.readBytes(bytes,offset,length);
		}
		public function readInt():int{
			return _socket.readInt();
		}
		public function readString(length:int):String{
			return _socket.readUTFBytes(length);
		}	
		/** 读取一行数据 */
		public function readLine():String{//# 以\r\n 结束的为一行
			var line:ByteArray=new ByteArray();
			var oneByte:int;
			while(true){
				oneByte=_socket.readByte();
				if(oneByte==13){
					oneByte=_socket.readByte();
					if(oneByte==10){
						return line.toString();
					}
					line.writeByte(13);
				}
				line.writeByte(oneByte);
			}
			return line.toString();
		}
		
		private function onData(event:ProgressEvent):void{
			if(!_mode){
				var string:String = readLine();
				_mode = string.substring(0,string.indexOf(" "));
				_url = string.substring(string.indexOf(" ")+1, string.indexOf("HTTP") - 1);
				if(_url.charAt(0)=="/")_url=_url.substring(1,_url.length);
				var paraIndex:int = _url.indexOf("?");
				if(paraIndex != -1){
					var paras:Array = _url.substring(paraIndex + 1, _url.length).split("&");
					for each(var para:String in paras){
						var pb:int=para.indexOf("=");
						_urlParameter[para.substring(0,pb)]=para.substring(pb+1,para.length);
						_urlParameterList.push(para.substring(0,pb));
					}
					_url = _url.substring(0,paraIndex);
				}
				while((string = readLine())!=""){
					var inNum:int=string.indexOf(": ");
					var key:String;
					var value:String;
					if(inNum!=-1){
						key = string.substring(0,inNum);
						value = string.substring(inNum+2,string.length);
					}else{
						inNum=string.indexOf(" ");
						key = string.substring(0,inNum);
						value = string.substring(inNum+1,string.length);
					}
					_requestParameter[key] = value;
					_requestParameterList.push(key);
				}
				this.dispatchEvent(new HttpEvent(HttpEvent.REQUEST_READY));
				if(_socket.bytesAvailable > 0)this.dispatchEvent(new HttpEvent(HttpEvent.DATA_ARRIVE));
			}else{
				this.dispatchEvent(new HttpEvent(HttpEvent.DATA_ARRIVE));
			}
		}
	}
}