package com.net
{
	import com.net.events.HttpEvent;
	import com.net.httpServer.HttpParameter;
	import com.net.httpServer.HttpRequest;
	import com.net.httpServer.HttpResponse;
	import com.net.httpServer.IHttpServlet;
	import com.net.servletHandler.ResourceServlet;
	import com.net.servletHandler.UpLoadResServlet;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;

	public class HttpServer extends EventDispatcher
	{
		private var _server:ServerSocket;
		
		private var _bindPort:int;
		
		private var _bindHost:String;
		
		private var _httpParameter:HttpParameter;
		
		private var _servlet:Dictionary;
		
		/**
		 * 一个简单的基于http协议的服务器
		 * 可以提供简易WEB服务器功能
		 * 
		 * 可以绑定到端口 指定虚拟目录  可以自定义处理相关请求
		 */
		public function HttpServer(httpParameter:HttpParameter = null,
			host:String="0.0.0.0",port:int=80)
		{
			_bindHost=host;
			_bindPort=port;
			_server=new ServerSocket();
			_servlet = new Dictionary();
			if(!httpParameter){
				_httpParameter = new HttpParameter();
			}else{
				_httpParameter = httpParameter;
			}
			initRequsetHandle();
		}
		
		/**
		 * 启动服务器
		 */
		public function start():void{
			if(_server.listening){
				return;
			}
			try{
				_server.bind(_bindPort,_bindHost);
				_server.addEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
				_server.listen();
			}catch(error:Error){
				//绑定失败
			}
		}
		
		/**
		 * 关闭服务器
		 */
		public function stop():void{
			if(_server.listening){
				_server.close();
			}
		}
		
		/** 增加一个请求处理容器 */
		public function addServlet(url:String,servlet:Class):void{
			if(url != ""){
				_servlet[url] = servlet;
			}
		}
		
		/** 实例化一个处理请求的容器 */
		public function getServlet(url:String):IHttpServlet{
			if(url == "")return new ResourceServlet();
			var type:Class=_servlet[url] as Class;
			if(type==null){
				return new ResourceServlet();
			}
			return new type();
		}
		
		//基本服务
		private function initRequsetHandle():void{
			addServlet("upload.html",UpLoadResServlet);//基础上传服务
		}
		
		//新连接了连接到服务器端口
		private function onConnect(event:ServerSocketConnectEvent):void{
			var request:HttpRequest = new HttpRequest(event.socket,_httpParameter);
			request.addEventListener(HttpEvent.REQUEST_READY,onReady);
		}
		
		//请求已建立
		private function onReady(event:HttpEvent):void{
			var request:HttpRequest = event.currentTarget as HttpRequest;
			var url:String = request.getURL();
			var servlet:IHttpServlet = getServlet(url);
			if(request.getMode() == "GET"){
				servlet.doGet(request,new HttpResponse(request.getSocket()));
			}else if(request.getMode() == "POST"){
				servlet.doPost(request,new HttpResponse(request.getSocket()));
			}else{
				request.close();
			}
		}
	}
}