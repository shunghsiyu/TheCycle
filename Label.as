package  {
	
	import fl.text.TLFTextField;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		private function initialize(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, counterRotates, false, 0, true);
			this.labelNameField.text = labelName;
			this.labelNameField.textColor = getTextColor();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		//keep the label horizontal even when the cycle rotates
		private function counterRotates(e:Event):void {
			this.rotation = -parent.rotation;
		}
		
		//Change the color of the label
		public function setColor(_color:uint):void {
			color = _color;
			this.labelNameField.textColor = getTextColor();
			drawBG();
		}
		
		//Call other methods that draws the background
		private function drawBG():void {
			var drawWidth:int, drawHeight:int;
			
			drawHeight = rectHeight;
			if (labelName.length > minLengthToAdjust)
				drawWidth = expandPerChar*(labelName.length - minLengthToAdjust) + rectWidth;
			else
				drawWidth = rectWidth;
		
			drawBGRect(drawWidth, drawHeight, true);
		}
		
		//Draws the background rectangle
		private function drawBGRect(_rectWidth:int, _rectHeight:int, _fill:Boolean = true):void {
			var bgColor:uint = 0xFFFFFF;
			rect.graphics.clear();
			rect.graphics.lineStyle(8, this.color, 1);
			if (_fill) rect.graphics.beginFill(bgColor, 1);
			rect.graphics.drawRoundRect(-_rectWidth/2, -_rectHeight/2, _rectWidth, _rectHeight, 
										_rectWidth < _rectHeight ? _rectWidth:_rectHeight, 
										_rectWidth < _rectHeight ? _rectWidth:_rectHeight);
			rect.graphics.endFill();
			this.addChildAt(rect, 0);
		}
		
		//Get the color of the text according to the color of this label
		private function getTextColor():uint {
			return MyFunctions.changeColorByHSV(color, -5, 0, -10);
		}
		
		public function getColor():uint {return color;}
		
		//The dimension of the background rectangle
		private static const rectWidth:Number = 150, rectHeight:Number = 50;
		//Determines the way the background rectangle expand to fit the text
		private static const minLengthToAdjust:int = 7, expandPerChar:int = 14;
		//the text to display in the label
		private var labelName:String;
		//Object for drawing the background rectangel
		private var rect:Shape = new Shape();
		//The color of this label
		private var color:uint;
		//The textfield for the label name
		private var labelNameField:TLFTextField = new TLFTextField();
	}
	
}

