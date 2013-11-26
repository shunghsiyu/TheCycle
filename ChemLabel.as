﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Stage;
	
	public class ChemLabel extends MovieClip {
		
		public function ChemLabel(_labelName:String, _color:uint = 0x000000) {
			// constructor code
			super();
			labelName = _labelName;
			color = _color;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
			drawBG();
		}
		
		private function initialize(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, counterRotates, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, on_MouseDown, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, on_MouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			this.chemName.text = labelName;
			this.chemName.textColor = getTextColor();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function counterRotates(e:Event):void {
			this.rotation = -parent.rotation;
		}
		
		private function onMouseOver(e:MouseEvent):void {
			if (!scaling && !mouseIsDown) {
				scaling = true;
				this.addEventListener(Event.ENTER_FRAME, scaleUp, false, 0 ,true);
			}
		}
		
		private function onMouseOut(e:MouseEvent):void {
			if (!scaling) {
				scaling = true;
				this.addEventListener(Event.ENTER_FRAME, scaleDown, false, 0 ,true);
			}
		}
		
		private function on_MouseDown(e:MouseEvent):void {
			mouseIsDown = true;
		}
		
		private function on_MouseUp(e:MouseEvent):void {
			mouseIsDown = false;
		}
		
		private function scaleUp(e:Event):void {
			this.adjustScale(0.02, 1.15);
		}

		private function scaleDown(e:Event):void {
			this.adjustScale(-0.02, 1);
		}
		
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
		
		public function setColor(_color:uint):void {
			color = _color;
			this.chemName.textColor = getTextColor();
			drawBG();
		}
		
		private function drawBG():void {
			var drawWidth:int, drawHeight:int;
			
			drawHeight = rectHeight;
			if (labelName.length > minLengthToAdjust)
				drawWidth = expandPerChar*(labelName.length - minLengthToAdjust) + rectWidth;
			else
				drawWidth = rectWidth;
		
			drawBGRect(drawWidth, drawHeight, true);
		}
		
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
		
		private function getTextColor():uint {
			return MyFunctions.changeColorByHSV(color, -5, 0, -10);
		}
		
		public function getColor():uint {return color;}
		private static const rectWidth:Number = 150, rectHeight:Number = 50;
		private static const minLengthToAdjust:int = 7, expandPerChar:int = 14;
		private var mouseIsDown:Boolean, scaling:Boolean;
		private var labelName:String;
		private var rect:Shape = new Shape();
		//The color of this label
		private var color:uint;
	}
	
}

