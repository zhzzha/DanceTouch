����   2 #  com/org/alarmdemo/AlarmReceiver  java/lang/Object <init> ()V Code 	 java/lang/Error e无法解析的编译问题：
	无法解析导入 android.content.BroadcastReceiver
	无法解析导入 android.content.Context
	无法解析导入 android.content.Intent
	无法解析导入 android.util
	BroadcastReceiver 无法解析为类型
	Override 无法解析为类型
	Context 无法解析为类型
	Intent 无法解析为类型
	无法解析 Log

     (Ljava/lang/String;)V LineNumberTable LocalVariableTable this !Lcom/org/alarmdemo/AlarmReceiver; 	onReceive (LContext;LIntent;)V RuntimeInvisibleAnnotations 
LOverride;  �无法解析的编译问题：
	Override 无法解析为类型
	Context 无法解析为类型
	Intent 无法解析为类型
	无法解析 Log
 
SourceFile AlarmReceiver.java InconsistentHierarchy  BroadcastReceiver  Context ! Intent MissingTypes !               4     
� Y
� �                   
                    4     
� Y� �           
        
                "                                                                                                                                                                                                                                                                                                                                                                                                                                    0;
			_text.y = 35;
			_text.x = _icon.width + 10;
			_text.text = text;
			_text.cacheAsBitmap = true;
			_contant.addChild(_text);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		/** 增加一个选项 */
		public function addOption(str:String):void{
			var button:Scale9Button = new Scale9Button();
			button.label = str;
			button.addEventListener(MultTouchEvent.SELECT,onOptionSelect);
			_borderButton.push(button);
			_contant.addChild(button);
			
			if(_borderButton.length > 1){
				var startX:Number = _borderButton[_borderButton.length-2].x;
				button.x = startX - button.width - 10;
				button.y = _borderButton[_borderButton.length-2].y;
			}else{
				button.x = this.width - button.width - 10;
				var textStandard:Number = _text.y + _text.height + 5;
				var iconStandard:Number = _icon.y + _icon.height - button.height;
				button.y = textStandard > iconStandard ? textStandard:iconStandard;
			}

				

		}
		
		/** 清除引用 */
		public function dispose():void{
			removeEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		/** 选择的项 */
		public function get select():String{
			return _selectItem;
		}
		
		private function onOptionSelect(event:MultTouchEvent):void{
			_selectItem = (event.currentTarget as S