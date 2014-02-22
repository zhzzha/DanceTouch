package com.dt.page.transitions
{
	import com.dt.base.Container;

	public class TransitionsFactory
	{
		public static function getTransitions(name:String ,container:Container):ITransitions{
			switch(name){
				case "fold":
					return new FoldTransitions(container);
				case "slide":
					return new SlideTransitions(container);
				case "fall":
					return new FallTransitions(container);
				case "alpha":
					return new AlphaTransitions(container);
				default:
					return null;
			}
			return null
		}
	}
}