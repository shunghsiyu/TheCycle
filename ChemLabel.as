package  {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	
	public class ChemLabel extends Label {
		
		public function ChemLabel(_labelName:String, _color:uint = 0x000000, _active = false) {
			// constructor code
			super(_labelName, _color);
			labelName = _labelName;
			color = _color;
			isEnable = _active;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
			drawBG();
		}
		
		//Initialize the label after it is added to the stage
		override protected function initialize(e:Event):void {
			setActive(isEnable);
			this.labelNameField.text = labelName;
			this.labelNameField.textColor = getTextColor();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function setActive(_enable:Boolean):void {
			if (_enable) {
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			}
			else {
				if (this.hasEventListener(MouseEvent.ROLL_OVER) ) this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				if (this.hasEventListener(MouseEvent.ROLL_OUT) ) this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				if (this.scaleX != 1) TweenMax.to(this, 0.3, {scaleX: 1, scaleY: 1, overwrite: 1});
			}
		}
		
		//scale up when mouse is over the label
		private function onRollOver(e:MouseEvent):void {
			TweenMax.to(this, 0.3, {scaleX: 1+scaleMax, scaleY: 1+scaleMax, overwrite: 1});
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
		}
		
		//scale down when mouse leaves the label
		private function onRollOut(e:MouseEvent):void {
			TweenMax.to(this, 0.3, {scaleX: 1, scaleY: 1, overwrite: 1});
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
		}
		
		override protected function drawBG():void {
			var drawWidth:int, drawHeight:int;
			
			drawHeight = rectHeight;
			if (labelName.length > minLengthToAdjust)
				drawWidth = expandPerChar*(labelName.length - minLengthToAdjust) + rectWidth;
			else
				drawWidth = rectWidth;
			
			drawBGRect(drawWidth, drawHeight, true);
		}
		
		override protected function drawBGRect(_rectWidth:int, _rectHeight:int, _fill:Boolean = true):void {
			var bgColor:uint = 0xFFFFFF;
			rect.graphics.clear();
			rect.graphics.lineStyle(rectThickness, color, 1);
			if (_fill) rect.graphics.beginFill(bgColor, 1);
			rect.graphics.drawRoundRect(-_rectWidth/2, -_rectHeight/2, _rectWidth, _rectHeight, 
				_rectWidth < _rectHeight ? _rectWidth:_rectHeight, 
				_rectWidth < _rectHeight ? _rectWidth:_rectHeight);
			rect.graphics.endFill();
			this.addChildAt(rect, 0);
		}
		
		override public function setColor(_color:uint):void {
			color = _color;
			labelNameField.textColor = getTextColor();
			drawBG();
		}
		
		//The dimension of the background rectangle
		public static const rectWidth:Number = 150, rectHeight:Number = 50, rectThickness:Number = 8;
		//Determines the way the background rectangle expand to fit the text
		private static const minLengthToAdjust:int = 7, expandPerChar:int = 14;
		//Controls the size and rate of scaling when mouse is over
		private static const scaleRate:Number = 0.02, scaleMax:Number = 0.15;
		//Variables to prevent scaling up happening at the same time as scaling down
		private var mouseIsDown:Boolean, scaling:Boolean;
		//Variable that tells whether or not the label is active
		private var isEnable:Boolean;
	}
	
}

