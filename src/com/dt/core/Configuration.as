package com.dt.core
{
	import com.dt.core.component.MsgBox;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Configuration
	{
		private var _xml:XML;
		
		private var _deblocking:Deblocking;
		
		private var _fileStream:FileStream;
		
		private var _file:File;
		
		/** 配置文件 */
		public function Configuration()
		{
			_deblocking = new Deblocking();
			_fileStream=new FileStream();
			_file=new File(File.applicationDirectory.resolvePath("System/content.xml").nativePath);
			
			try{
				_fileStream.open(_file, FileMode.READ);
				_xml= XML(_fileStream.readUTFBytes(_fileStream.bytesAvailable));
				_fileStream.close();
			}catch(error:Error){
				var box:MsgBox = MsgManager.current.addMsgBoxEasy(
					"无法读取文件！请重试！","错误");
				box.addEventListener(Event.SELECT,onSelect);
			}
		}
		
		/** 保存配置文件 */
		public function save():void{
			_fileStream.open(_file,FileMode.WRITE);
			_fileStream.writeUTFBytes(_xml.toString());
			_fileStream.close();
		}
		
		/** 设置参数 */
		public function get setting():XML{
			return _xml.App[0];
		}
		
		/** 讀取頁面 */
		public function get pages():XMLList{
			return _xml.Page;
		}
		
		/** 讀取配置 */
		public function get config():XML{
			return _xml.Config[0];
		}
		
		/** 读取key */
		public function get key():Deblocking{
			return _deblocking;
		}
		
		//无法读取文件  退出
		private function onSelect(event:Event):void{
			NativeApplication.nativeApplication.exit();
		}
	}
}