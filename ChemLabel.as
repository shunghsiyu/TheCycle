package  {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ChemLabel extends Label {
		
		public function ChemLabel(_labelName:String, _color:uint = 0x000000) {
			// constructor code
			super(_labelName, _color);
			labelName = _labelName;
			color = _color;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
			drawBG();
		}
		
		//Initialize the label after it is added to the stage
		override protected function initialize(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, counterRotates, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, on_MouseDown, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, on_MouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			this.labelNameField.text = labelName;
			this.labelNameField.textColor = getTextColor();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		//keep the label horizontal even when the cycle rotates
		override protected function counterRotates(e:Event):void {
			this.rotation = -parent.rotation;
		}
		
		//scale up when mouse is over the label
		private function onMouseOver(e:MouseEvent):void {
			if (!scaling && !mouseIsDown) {
				scaling = true;
				this.addEventListener(Event.ENTER_FRAME, scaleUp, false, 0 ,true);
			}
		}
		
		//scale down when mouse leaves the label
		/* NEED TO BE FIXED */
		private function onMouseOut(e:MouseEvent):void {
			if (!scaling) {
				scaling = true;
				this.addEventListener(Event.ENTER_FRAME, scaleDown, false, 0 ,true);
			}
		}
		
		//prevent mouse from scaling up when the cycle is dragged
		/* CAN BE MODIFIED TO SAFE MEMORY */
		private function on_MouseDown(e:MouseEvent):void {
			mouseIsDown = true;
		}
		
		private function on_MouseUp(e:MouseEvent):void {
			mouseIsDown = false;
		}
		
		//Scale up the label
		private function scaleUp(e:Event):void {
			this.adjustScale(scaleRate, 1+scaleMax);
		}
		
		//Scale down the label
		private function scaleDown(e:Event):void {
			this.adjustScale(-scaleRate, 1);
		}
		
		//Scale the label according to the input parameter
		private function adjustScale(_changeAmount:Number, _limit:Number):void {
			if (_changeAmount > 0)
				if (this.scaleX >= _limit) {
					this.removeEventListener(Event.ENTER_FRAME, scaleUp);
					this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
					scaling = false;
					return;
				}
			if (_changeAmount < 0)
				if (this.scaleX <= _limit) {
					this.removeEventListener(Event.ENTER_FRAME, scaleDown);
					this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
					scaling = false;
					return;
				}
			if (_changeAmount == 0) {
				this.removeEventListener(Event.ENTER_FRAME, scaleUp);
				this.removeEventListener(Event.ENTER_FRAME, scaleDown);
				scaling = false;
				trace("_changeAmount can't be zero");
				return;
			}
			
			this.scaleX = this.scaleX + _changeAmount;
			this.scaleY = this.scaleY + _changeAmount;
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
	}
	
}

