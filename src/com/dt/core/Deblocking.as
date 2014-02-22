package com.dt.core
{
	import com.adobe.utils.Base64;
	import com.adobe.utils.MD5;
	
	import flash.events.Event;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.SharedObject;
	
	public class Deblocking
	{
		private var _so:SharedObject;
		
		private var _key:String;
		
		private var _installTime:Date;
		
		private var _lastSetupTime:Date;
		
		private var _setupTime:int;
		
		private var _mec:String;
		
		public function Deblocking(){
			_so = SharedObject.getLocal("DanceTouch");
			_key = _so.data.KEY as String;
			_installTime = _so.data.Install as Date;
			if(!_installTime)_installTime = _so.data.Install = new Date();
			_lastSetupTime = _so.data.LastSetup as Date;
			if(!_lastSetupTime)_lastSetupTime = _so.data.LastSetup = new Date();
			_setupTime = _so.data.Times;
			_so.data.Times = _setupTime += 1;
			initDevice();
		}
		
		/** 启动次数 当错误时返回-1 */
		public function getSetupTime():int{
			var now:Date = new Date();
			if(now < _installTime 
				|| now < _lastSetupTime 
				|| _installTime < _lastSetupTime){
				return -1;
			}
			return _setupTime;
		}
		
		/**
		 * 取出本机注册key
		 */
		public function get readKey():String{
			return _key;
		}
		
		
		/**
		 * 取得本机机器码
		 * 
		 */
		public function get Mec():String{
			return _mec;
		}
		
		/**
		 * 保存注册key
		 */
		public function saveKey(str:String):void{
			_key=str;
			_so.data.KEY=_key;
		}
		
		private function initDevice():void{
			var mn:String="";
			var temp:String;
			var netinfo:Vector.<NetworkInterface>=
				NetworkInfo.networkInfo.findInterfaces();
			if(netinfo.length<1){
				//无法读取
				return;
			}
			for (var i:* in netinfo){
				if(netinfo[i].hardwareAddress!=""){
					temp=netinfo[i].hardwareAddress;
					break;
				}
			}
			while (temp.indexOf("-") > 0)
			{
				temp = temp.replace("-", "");
			}
			temp=parseInt(temp,16).toString();
			for(var k:int=0;k<temp.length;k++){
				mn += temp.charAt(int(temp.slice(k,k+2)));
			}
			_mec=mn;
		}
		
		/** 清空注册 */
		public function clear():void{
			delete _so.data.Install;
			delete _so.data.LastSetup;
			delete _so.data.Times;
			delete _so.data.KEY;
		}
		
		/**
		 * 是否注册
		 */
		public function isRegister():Boolean{
			return _key==MD5.hash(Base64.encode(Mec));
		}
	}
}