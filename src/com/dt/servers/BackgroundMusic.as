package com.dt.servers
{
	import com.dt.core.DTFile;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class BackgroundMusic
	{
		private var _playList:Vector.<DTFile>;
		
		private var _isPlaying:Boolean;
		
		private var _playIndex:int;
		
		private var _position:Number;
		
		private var _playSound:Sound;
		
		private var _soundChannel:SoundChannel;
		
		private var _volume:SoundTransform;
		
		public function BackgroundMusic()
		{
			_isPlaying = false;
			_volume = new SoundTransform();
			_playList = new Vector.<DTFile>();
		}
		
		/** 设置播放列表 */
		public function setPlaylist(xml:XML,autoPlay:Boolean = true):void{
			if(_isPlaying) stop();
			volume = xml.@volume;
			_playIndex = 0;
			_playList = DTFile.fromXML(xml);
			if(autoPlay)play();
		}
		
		/** 开始播放 */
		public function play():void{
			if(_playList.length < 1)return;
			if(_isPlaying)return;
			if(!_playSound){
				_playSound = new Sound(
					new URLRequest(_playList[_playIndex].relativePath));
			}
			_playSound.addEventListener(IOErrorEvent.IO_ERROR,playError);
			_soundChannel = _playSound.play(_position);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,onPlayComplete);
			_soundChannel.soundTransform = _volume;
			_isPlaying = true;
		}
		
		/** 下一首 */
		public function playNext():void{
			if(_playList.length < 1){
				//没音乐文件
				return;
			}
			if(_isPlaying)stop();
			_playIndex += 1;
			if(_playIndex >= _playList.length){
				_playIndex = 0;
			}
			play();
		}
		
		/** 暂停 */
		public function pause():void{
			_position = _soundChannel.position;
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,onPlayComplete);
			_soundChannel.stop();
			_isPlaying = false;
		}
		
		/** 停止 */
		public function stop():void{
			_position = 0;
			_playSound.removeEventListener(IOErrorEvent.IO_ERROR,playError);
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,onPlayComplete);
			_soundChannel.stop();
			_isPlaying = false;
		}
		
		/** 音量大小  0-1 */
		public function set volume(value:Number):void{
			if(value > 1)value = 1;
			if(value < 0)value = 0;
			_volume.volume = value;
		}
		
		/** 是否正在播放 */
		public function get isPlaying():Boolean{
			return _isPlaying;
		}
		
		//播放完
		private function onPlayComplete(event:Event):void{
			stop();
			playNext();
		}
		
		//无法播放 
		private function playError(event:IOErrorEvent):void{
			_playList.splice(_playIndex,1);
			playNext();
		}
	}
}