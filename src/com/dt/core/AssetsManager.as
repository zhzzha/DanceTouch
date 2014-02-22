package com.dt.core
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class AssetsManager
	{
		//--------------------------------------------------------------------
		private static var _assets:AssetsManager;
		/** 资源管理 */
		public static function get assetsManager():AssetsManager{
			if(!_assets)_assets = new AssetsManager();
			return _assets;
		}
		/** 根据名字查找图片 */
		public static function getAssets(value:String):BitmapData{
			return assetsManager.getBitmapdata(value);
		}
		//--------------------------------------------------------------------
		
		private var _list:Dictionary;
		
		private var _skin:Dictionary;
		
		[Embed(source="/../Image/assets.png")]
		private var AssetsImage:Class;
		
		[Embed(source="/../Image/assets.xml",mimeType="application/octet-stream")]
		private const AssetsXml:Class;
		
		public function AssetsManager()
		{
			_list = new Dictionary();
			_skin = new Dictionary();
			parseAtlasXml(XML(new AssetsXml()),new AssetsImage().bitmapData);
		}
		
		public function getBitmapdata(name:String):BitmapData{
			return _list[name];
		}
		
		private function parseAtlasXml(xml:XML,subBitmapdata:BitmapData):void
		{
			var point:Point = new Point(0,0);
			for each (var subXml:XML in xml.SubTexture)
			{
				var name:String = subXml.attribute("name");
				var x:Number = parseFloat(subXml.attribute("x"));
				var y:Number = parseFloat(subXml.attribute("y"));
				var width:Number = parseFloat(subXml.attribute("width"));
				var height:Number = parseFloat(subXml.attribute("height"));
				
				var rect:Rectangle = new Rectangle(x, y, width, height);
				var bitmapdata:BitmapData = new BitmapData(width,height,true);
				bitmapdata.copyPixels(subBitmapdata,rect,point);
				_list[name] = bitmapdata;
			}
			subBitmapdata.dispose();
		}
	}
}