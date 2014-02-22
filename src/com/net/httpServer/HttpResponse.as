package com.net.httpServer
{
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class HttpResponse
	{
		private const HTTP_VERSION:String = "HTTP/1.1";
		
		private const SERVER_VERSION:String = "DTWebServer/1.2";
		
		private var _state:String;
		
		private var _type:String;
		
		private var _length:uint;
		
		private var _fileName:String;
		
		private var _otherPara:Array;
		
		private var _socket:Socket;
		
		public function HttpResponse(stream:Socket)
		{
			_socket = stream;
			_state = HttpStateCode.OK;
			_type = "text/html";
			_length = 0;
			_fileName = "";
			_otherPara = new Array();
		}
		
		/** 请求的连接 */
		public function getSocket():Socket{
			return _socket;
		}
		
		/** 响应状态码  默认OK  */
		public function setReponseState(state:String):void{
			_state = state;
		}
		
		/** 活动参数 keep-alive */
		public function setKeepAlive(state:String = "Keep-Alive",timeout:int = 5,max:int=99):void{
			
		}
		
		/** 响应附带的数据格式 */
		public function setReponseType(type:String,length:uint = 0,fileName:String = ""):void{
			_type = type;
			_length = length;
			_fileName = fileName;
		}
		
		/** 其他参数 */
		public function setReponsePara(str:String):void{
			_otherPara.push(str)
		}
		
		/** 发送reponse */
		public function sendReponse():void{
			var reponseStr:String = HTTP_VERSION + " " +  _state + "\r\n"
				+"Date: " + new Date().toString()+"\r\n"
				+"Server: "+SERVER_VERSION + "\r\n"
				+"Connection: Keep-Alive" + "\r\n"
				+"Content-Type: " + _type + "\r\n"
				+"Content-Length: " + _length  + "\r\n"
				+ (_fileName != "" ? "Content-disposition: attachment;filename="+_fileName+"\r\n" : "");
			for(var str:String in _otherPara){
				reponseStr += str + "\r\n";
			}
			reponseStr += "\r\n";
			_socket.writeUTFBytes(reponseStr);
			_socket.flush();
		}
		
		//--------------------------------------------------------
		public function writeOneByte(value:int):void{
			return _socket.writeByte(value)
		}
		public function writeBytes(bytes:ByteArray,offset:uint=0,length:uint=0):void{
			return _socket.writeBytes(bytes,offset,length);
		}
		public function writeInt(value:int):void{
			return _socket.writeInt(value);
		}
		public function writeFloat(value:Number):void{
			return _socket.writeFloat(value);
		}
		public function writeString(value:String):void{
			return _socket.writeUTFBytes(value);
		}
		public function writeLint(value:String):void{
			return _socket.writeUTFBytes(value+"\r\n");
		}
	}
}