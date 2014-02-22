package  com.net.servletHandler
{
	import com.net.events.HttpEvent;
	import com.net.httpServer.HttpRequest;
	import com.net.httpServer.HttpResponse;
	import com.net.httpServer.HttpStateCode;
	import com.net.httpServer.IHttpServlet;
	
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class UpLoadResServlet implements IHttpServlet
	{
		private var _request:HttpRequest;
		
		private var _response:HttpResponse;
		
		private var _contentType:String;
		
		private var _boundaryBytes:ByteArray;
		
		private var _fileStream:FileStream;
		
		private var _byteBuffer:ByteArray;//缓冲
		
		private var _dataLength:uint;
		
		public function UpLoadResServlet()
		{
			_byteBuffer = new ByteArray();
		}
		
		public function doGet(request:HttpRequest, response:HttpResponse):void
		{
			response.setReponseType(HttpStateCode.BAD_REQUEST);
			response.sendReponse();
		}
		
		public function doPost(request:HttpRequest, response:HttpResponse):void
		{
			_request = request;
			_response = response;
			_dataLength = parseInt(request.getAttribute("Content-Length"));//数据总长度
			_contentType = request.getAttribute("Content-Type");
			var boundary:String = _contentType.substring(
				_contentType.indexOf("boundary=")+9,_contentType.length);//获取分割定义
			_boundaryBytes = new ByteArray();
			_boundaryBytes.writeUTFBytes(boundary);//分割定义
			
			request.addEventListener(HttpEvent.DATA_ARRIVE,onDataArrive);
		}
		
		private function onDataArrive(event:HttpEvent):void{
			_request.readBytes(_byteBuffer,_byteBuffer.length);
			if(_byteBuffer.length < _dataLength){
				return;
			}
			_response.sendReponse();
			_request.close();
			
			var list:Vector.<ByteArray> = new Vector.<ByteArray>();
			var start:int = 0;
			var index:int = start + 2 + _boundaryBytes.length + 2;//start+"--"+"boundary"+"\r\n"
			for (index ; index < _dataLength ; index++ ){
				if(_byteBuffer[index] == 45  && _byteBuffer[index + 1] == 45){
					var isBoundary:Boolean=true;//校验Boundary
					var length:int = _boundaryBytes.length;
					for(var i:int = 0 ; i < length ; i++ ){
						if(_byteBuffer[index + 2 + i] != _boundaryBytes[i]){
							isBoundary=false;
						}
					}
					if(isBoundary){//分组
						var temp:ByteArray = new ByteArray();
						temp.writeBytes(_byteBuffer,start,index - start);
						list.push(temp);
						start = index;
						index += 2 + _boundaryBytes.length + 2;
					}
				}
			}
			_byteBuffer.clear();
			for each(var bytes:ByteArray in list ){
				bytes.position = 0;
				readLineExpress(bytes)
				var firstLine:String = readLineExpress(bytes);
				var nameIndex:int=firstLine.indexOf("filename=");
				if(nameIndex!=-1){//存在文件名
					var fileName:String = firstLine.substring(nameIndex+10,firstLine.length-1);
					if(fileName == "")fileName=new Date().time.toString();
					var line:String=readLineExpress(bytes);
					while(line!=""){//附加的其他参数
						line=readLineExpress(bytes);
					}
					saveFile(fileName,bytes);
				}//没有 filename 这个段 则跳过
			}
			
		}
		
		private function saveFile(name:String,data:ByteArray):void{
			var file:File = new File(_request.getHttpParameter().getDefaultFolder().
				resolvePath(name).nativePath);
			var stream:FileStream = new FileStream();
			stream.openAsync(file,FileMode.WRITE);
			//stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,onProgress);
			stream.addEventListener(Event.CLOSE,onClose);
			stream.writeBytes(data,data.position,data.length - data.position - 2);
			stream.close();//同步方式写入  没有完全写入则不会关闭流
		}
		
		private function onProgress(event:OutputProgressEvent):void{
			var stream:FileStream = event.currentTarget as FileStream;
		}
		
		private function onClose(event:Event):void{
			var stream:FileStream = event.currentTarget as FileStream;
			stream.removeEventListener(Event.CLOSE,onClose);
			//完全写入
		}
		
		/**
		 * 快速读取一行
		 */
		private function readLineExpress(byte:ByteArray):String{
			var line:ByteArray=new ByteArray();
			var oneByte:int;
			while(true){
				oneByte = byte.readByte();
				if(oneByte==13){
					oneByte=byte.readByte();
					if(oneByte==10){
						return line.toString();
					}
					line.writeByte(13);
				}
				line.writeByte(oneByte);
			}
			return line.toString();
		}
	}
}