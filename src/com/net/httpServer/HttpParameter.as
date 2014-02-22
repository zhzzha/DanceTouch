package com.net.httpServer
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class HttpParameter
	{
		private var _virtualDirectory:File;//虚拟地址
		
		private var _defaultPage:Array;//默认页面
		
		private var _fileType:Vector.<FileType>;
		
		public function HttpParameter(vd:File = null,
			defaultPage:String = "index.html;index.htm")
		{
			if(!vd)_virtualDirectory = File.applicationDirectory;
			if(!_virtualDirectory.isDirectory){
				_virtualDirectory = _virtualDirectory.parent;
			}
			_defaultPage = defaultPage.split(";");
			initType();
		}
		
		/** 根目录 */
		public function getDefaultFolder():File{
			return _virtualDirectory;
		}
		
		/** 默认文件名 */
		public function getDefaultPageList():Array{
			return _defaultPage;
		}
		
		/** 查找类型 */
		public function getTypeByExtension(extension:String):String{
			for each(var ft:FileType in _fileType){
				if(ft.extension == extension){
					return ft.type;
				}
			}
			return "application/octet-stream";
		}
		
		//初始化文件类型
		private function initType():void{
			_fileType = new Vector.<FileType>();
			
			//文本
			_fileType.push(new FileType("html","text/html;charset=utf-8"));
			_fileType.push(new FileType("htm","text/html;charset=utf-8"));
			_fileType.push(new FileType("txt","text/plain;charset=utf-8"));
			_fileType.push(new FileType("xml","text/xml;charset=utf-8"));
			
			//图片 
			_fileType.push(new FileType("png","image/png"));
			_fileType.push(new FileType("jpg","image/jpeg"));
			_fileType.push(new FileType("jpe","image/jpeg"));
			_fileType.push(new FileType("jpeg","image/jpeg"));
			
			//媒体
			_fileType.push(new FileType("swf","application/x-shockwave-flash"));
			_fileType.push(new FileType("bmp","application/x-bmp"));
			_fileType.push(new FileType("css","application/octet-streamcss"));
			_fileType.push(new FileType("js","application/x-javascript"));
			
			//声音视频
			_fileType.push(new FileType("mp3","audio/mp3"));
			_fileType.push(new FileType("wav","audio/wav"));
			_fileType.push(new FileType("wma","audio/x-ms-wma"));
			_fileType.push(new FileType("mp4","video/x-mpg"));
			_fileType.push(new FileType("mpg","video/mpg"));
			_fileType.push(new FileType("mpeg","video/mpg"));
			
			//其他
			_fileType.push(new FileType("ico","application/x-icon"));
		}
	}
}

class FileType{
	
	public var extension:String;
	
	public var type:String;
	
	public function FileType(exten:String,ty:String){
		extension = exten;
		type = ty;
	}
}