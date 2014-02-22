package com.net.httpServer
{
	public interface IHttpServlet
	{
		/** 当Get请求发送到 */
		function doGet(request:HttpRequest,response:HttpResponse):void;
		
		/** 当Post请求发送到 */
		function doPost(request:HttpRequest,response:HttpResponse):void;
	}
}