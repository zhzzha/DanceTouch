package com.dt.core
{
	import flash.filesystem.File;

	public class DTFile
	{
		//--------------------------------------------------------------------
		/** 从一组XMLList中读出文件 */
		public static function fromXMLList(list:XMLList):Vector.<DTFile>{
			var fileList:Vector.<DTFile> = new Vector.<DTFile>();
			for each(var node:XML in list){
				if(node.name() == "file"){
					fileList.push(new DTFile(node.@path,null,node.name,node.about));
				}else if(node.name() == "folder"){
					var extension:Array = String(node.@extension).split(";");
					var newList:Vector.<DTFile> = 
						getFileFromPath(node.@path,node.@partName,extension);
					if(newList)fileList = fileList.concat(newList);
				}
			}
			return fileList;
		}
		
		/** 从一个xml中读出文件 */ 
		public static function fromXML(node:XML):Vector.<DTFile>{
			var fileList:Vector.<DTFile> = new Vector.<DTFile>();
			if(node.node == "file"){
				fileList.push(new DTFile(node.@path,null,node.name,node.about));
			}else if(node.name() == "folder"){
				var extension:Array = String(node.@extension).split(";");
				for(var i:int = extension.length - 1 ; i >=0 ;i--){
					if(extension[i] == "")extension.splice(i,1);
				}
				var newList:Vector.<DTFile> = 
					getFileFromPath(node.@path,node.@partName,extension);
				if(newList)fileList = fileList.concat(newList);
			}
			return fileList;
		}
		
		/** 从路径生成对象 */
		public static function fromString(path:String):DTFile{
			return new DTFile(path,null,"","");
		}
		//--------------------------------------------------------------------
		//从路径中查找符合要求的文件
		private static function getFileFromPath(path:String,partName:String = "",
												extensionName:Array = null):Vector.<DTFile>{
			var folder:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(!folder.exists && !folder.isDirectory && folder.isHidden){
				return null;
			}
			var fileList:Array = folder.getDirectoryListing();
			if(!fileList || fileList.length == 0){
				return null;
			}
			var list:Vector.<DTFile> = new Vector.<DTFile>();
			var dtfile:DTFile;
			for each(var file:File in fileList){
				if(!file.isDirectory && !file.isHidden){
					if(partName != "" && file.name.indexOf(partName) == -1){
						continue;
					}
					if(!extensionName && (extensionName.length != 0 && extensionName.indexOf(file.extension) == -1)){
						continue;
					}
					var resolve:String = file.nativePath.substring(startIndex,file.nativePath.length);
					list.push(new DTFile(resolve,file,file.name,""));
				}
			}
			return list;
		}
		
		//转换路径长度
		private static var _startIndex:int;
		private static function get startIndex():int{
			if(_startIndex == 0){
				_startIndex = File.applicationDirectory.nativePath.length + 1;
			}
			return _startIndex;
		}
		//--------------------------------------------------------------------
		
		private var _file:File;
		
		private var _relativePath:String;
		
		private var _name:String;
		
		private var _about:String;
		
		public function DTFile(path:String,file:File=null,name:String="",about:String="")
		{
			_name = name;
			_about = about;
			_file = file;
			_relativePath = path;
		}
		
		/** 文件对象 */
		public function get file():File{
			if(!_file){
				_file = new File(File.applicationDirectory.resolvePath(_relativePath).nativePath);
			}
			return _file;
		}
		
		/** 相对路径 */
		public function get relativePath():String{
			return _relativePath;
		}
		
		/** 标题名字 */
		public function get name():String{
			return _name;
		}
		
		/** 关于 */
		public function get about():String{
			return _about;
		}
	}
}