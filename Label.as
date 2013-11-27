package  {
	
	import fl.text.TLFTextField;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Label extends MovieClip {
		
		public function Label(_labelName:String, _color:uint = 0x000000) {
			// constructor code
			super();
			labelName = _labelName;
			color = _color;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
			drawBG();
		}
		
		//Initialize the label after it is added to the stage
		protected function initialize(e:Event):void {			
			/* SHOULD BE CLEANED */
			this.mouseEnabled = false;
			//set up the cycle name label
			labelNameField.text = labelName;
			labelNameField.setTextFormat(labelNameFieldFormat);
			labelNameField.textColor = color;
			labelNameField.selectable = false;
			labelNameField.width = 300;
			labelNameField.height = 70;
			labelNameField.autoSize = flash.text.TextFieldAutoSize.CENTER;
			labelNameField.x = -labelNameField.width/2;
			labelNameField.y = -labelNameField.height/2;
			addChild(labelNameField);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		//Change the color of the label
		public function setColor(_color:uint):void {
			color = _color;
			labelNameField.textColor = getTextColor();
			drawBG();
		}
		
		//Call other methods that draws the background
		protected function drawBG():void {
			var drawWidth:int, drawHeight:int;
			
			drawHeight = rectHeight;
			if (labelName.length > minLengthToAdjust)
				drawWidth = expandPerChar*(labelName.length - minLengthToAdjust) + rectWidth;
			else
				drawWidth = rectWidth;
		
			drawBGRect(drawWidth, drawHeight, false);
		}
		
		//Draws the background rectangle
		protected function drawBGRect(_rectWidth:int, _rectHeight:int, _fill:Boolean = true):void {
			var bgColor:uint = 0xFFFFFF;
			rect.graphics.clear();
			//rect.graphics.lineStyle(rectThickness, color, 1);
			if (_fill) rect.graphics.beginFill(bgColor, 1);
			rect.graphics.drawRoundRect(-_rectWidth/2, -_rectHeight/2, _rectWidth, _rectHeight, 
										_rectWidth < _rectHeight ? _rectWidth:_rectHeight, 
										_rectWidth < _rectHeight ? _rectWidth:_rectHeight);
			rect.graphics.endFill();
			this.addChildAt(rect, 0);
		}
		
		//Get the color of the text according to the color of this label
		protected function getTextColor():uint {
			return MyFunctions.changeColorByHSV(color, -5, 0, -10);
		}
		
		public function getColor():uint {return color;}
		
		//The dimension of the background rectangle
		public static const rectWidth:Number = 150, rectHeight:Number = 100, rectThickness:Number = 0;
		//Determines the way the background rectangle expand to fit the text
		private static const minLengthToAdjust:int = 7, expandPerChar:int = 14;
		//the text to display in the label
		protected var labelName:String;
		//Object for drawing the background rectangel
		protected var rect:Shape = new Shape();
		//The color of this label
		protected var color:uint;
		//The textfield for the label name
		private var labelNameField:TLFTextField = new TLFTextField();
		protected var labelNameFieldFormat:TextFormat = new TextFormat("Tahoma", 35, null, true, null, null, null, null, TextFormatAlign.CENTER);
	}
	
}

