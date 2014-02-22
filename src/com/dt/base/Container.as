package com.dt.base
{
	import com.dt.DTFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="touch", type="com.touch.MultTouchEvent")]
	[Event(name="gesture", type="com.touch.MultTouchEvent")]
	[Event(name="select", type="com.touch.MultTouchEvent")]
	[Event(name="hover", type="com.touch.MultTouchEvent")]
	
	public class Container extends Sprite
	{
		private var container_width:Number;
		
		private var container_height:Number;
		
		/** DT容器基类 */
		public function Container()
		{
			super();
			container_width = 0;
			container_height = 0;
		}
		
		override public function set width(value:Number):void{
			container_width=value;
			resize();
		}
		
		override public function get width():Number{
			return container_width;
		}
		
		override public function set height(value:Number):void{
			container_height=value;
			this.resize();
		}
		
		override public function get height():Number{
			return container_height;
		}
		
		protected function resize():void{
			//trace("resize");
		}
		
		/** 舞台实际的宽 */
		public function get currentWidth():Number{
			return DTFacade.current.width;
		}
		
		/** 舞台实际的高 */
		public function get currentHeight():Number{
			return DTFacade.current.height;
		}
		
		/** 比例位置x 必须在添加到上级容器内操作方可生效*/
		public function set px(value:Number):void{
			if(parent) x = parent.width * value;
		}
		/** 比例位置x 必须在添加到上级容器内操作方可生效*/
		public function get px():Number{
			if(parent) return x / parent.width;
			return 0;
		}
		/** 比例位置y 必须在添加到上级容器内操作方可生效*/
		public function set py(value:Number):void{
			if(parent) y =parent.height*value;
		}
		/** 比例位置y 必须在添加到上级容器内操作方可生效*/
		public function get py():Number{
			if(parent) return y / parent.height;
			return 0;
		}
		
		/** 比例位置 宽 必须在添加到上级容器内操作方可生效*/
		public function set pWidth(value:Number):void{
			if(parent) width = parent.width * value;
		}
		/** 比例位置 宽 必须在添加到上级容器内操作方可生效*/
		public function get pWidth():Number{
			if(parent) return width/parent.width;
			return 1;
		}
		/** 比例位置 高  必须在添加到上级容器内操作方可生效*/
		public function set pHidth(value:Number):void{
			if(parent) height = parent.height*value;
		}
		/** 比例位置 高 必须在添加到上级容器内操作方可生效*/
		public function get pHidth():Number{
			if(parent) return height/parent.height;
			return 1;
		}
	}
}