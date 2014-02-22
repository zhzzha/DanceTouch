package com.net.servletHandler
{
	import com.net.httpServer.HttpParameter;
	import com.net.httpServer.HttpRequest;
	import com.net.httpServer.HttpResponse;
	import com.net.httpServer.HttpStateCode;
	import com.net.httpServer.IHttpServlet;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/** 默认的资源请求处理 */
	public class ResourceServlet implements IHttpServlet
	{
		private var _filestream:FileStream;
		
		private var _response:HttpResponse;
		
		private var _request:HttpRequest;
		
		public function ResourceServlet()
		{
			
		}
		
		public function doGet(request:HttpRequest,response:HttpResponse):void{
			_response = response;
			_request = request;
			var file:File = request.getFile();
			if(!file){
				_response.setReponseState(HttpStateCode.NO_FOUND);
				_response.sendReponse();
				_request.close();
				return;
			}
			_filestream=new FileStream();
			_filestream.addEventListener(ProgressEvent.PROGRESS,onDataRead);
			_filestream.addEventListener(Event.COMPLETE,onReadComplete);
			response.setReponseType(
				request.getHttpParameter().getTypeByExtension(file.extension),
				file.size);
			response.sendReponse();
			_filestream.openAsync(file,FileMode.READ);
		}
		
		public function doPost(request:HttpRequest,response:HttpResponse):void{
			_response.setReponseState(HttpStateCode.BAD_REQUEST);
			_response.sendReponse();
			_request.close();
		}
		
		private function onDataRead(event:ProgressEvent):void{
			var bytes:ByteArray=new ByteArray();
			_filestream.readBytes(bytes);
			_response.writeBytes(bytes);
		}
		
		private function onReadComplete(event:Event):void{
			_filestream.close();
			_request.close();
		}
	}
}