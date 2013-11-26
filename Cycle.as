﻿package  {		import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import fl.motion.Color;	import flash.display.Shape;		public class Cycle extends MovieClip {				public function Cycle(_names:Array = null, _canRotate:Boolean = false, _color:uint = 0x0077F9) {			// constructor code			super();			labelNames = _names;			canRotate = _canRotate;			color = _color;			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);			drawBG();		}		//Initialize cycle after it is added to the stage		public function initialize(e:Event):void {						//Add the labels			for (var i:int = 0, cycleWidth:int = circleOuterRadius*2, cycleHeight:int = circleOuterRadius*2; i < labelNames.length; i++) {				var chemLabel:MovieClip = new ChemLabel(labelNames[i], getLabelColor());				var correction:Number = 0.10*(cycleWidth+cycleHeight)/4;				chemLabels.push(chemLabel);				addChild(chemLabels[i]);				chemLabels[i].x = (cycleWidth/2 - correction) *Math.cos((-90+i*(360/labelNames.length))*Math.PI/180);				chemLabels[i].y = (cycleHeight/2 - correction)*Math.sin((-90+i*(360/labelNames.length))*Math.PI/180);			}						setRotate(canRotate);						//Remove the initialize listener because it is no longer needed			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);		}				//Control whether or not the cycle can rotate		public function setRotate(_canRotate:Boolean):void {			if (_canRotate) {				this.addEventListener(MouseEvent.MOUSE_DOWN, startRotate, false, 0, true);				this.stage.addEventListener(MouseEvent.MOUSE_UP, stopRotate, false, 0, true);			}			else {				this.removeEventListener(MouseEvent.MOUSE_DOWN, startRotate);				this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotate);			}		}				private function startRotate(e:MouseEvent):void {			//Calculate the angle difference between the start of the cycle			// and the mouse			mouseAngleDiff = -this.rotation + MyFunctions.getAngle(this.stage.mouseX - this.x, this.stage.mouseY - this.y, 0, -1);			lastX = this.stage.mouseX;			lastY = this.stage.mouseY;			this.addEventListener(Event.ENTER_FRAME, rotating);		}				private function stopRotate(e:MouseEvent):void {			this.removeEventListener(Event.ENTER_FRAME, rotating);		}				private function rotating(e:Event):void {			var vecAX:Number;			var vecAY:Number;			var vecBX:Number;			var vecBY:Number;			var toTurn:Number = 0;			var toTurnEase:Number = 0;					//vecA is the vector pointing from the center to the mouse			vecAX = (this.stage.mouseX - this.x);			vecAY = (this.stage.mouseY - this.y);					//vecB is the vector pointing from the center to the			// starting point of the cycle			if (isNaN(lastX) || isNaN(lastY)) {				lastX = this.stage.mouseX;//Give lastX&Y the position of mouse				lastY = this.stage.mouseY;// if they haven't been initialized			}			vecBX = (lastX - this.x);			vecBY = (lastY - this.y);					//Get the angel between vecA&B,			//which will be added			toTurn = MyFunctions.getAngle(vecAX,vecAY,vecBX,vecBY);					//Easyease for the rotation:			toTurnEase = ((this.rotation + toTurn) - this.rotation)*0.2;			if (Math.abs(toTurnEase) < 0.05)	toTurnEase = 0;					//Update the cycle's rotation value			this.rotation = this.rotation + toTurnEase;						//Update the last position of cycle to the current one			// for the next frame			lastX = this.x + Math.cos((-90+this.rotation+mouseAngleDiff)*Math.PI/180);			lastY = this.y + Math.sin((-90+this.rotation+mouseAngleDiff)*Math.PI/180);		}		private function getLabelColor():uint {			return MyFunctions.changeColorByHSV(color, -25, -30, -2);		}				public function setColor(_color:uint):void {			color = _color;			for (var i:int = 0; i < chemLabels.length; i++) {				chemLabels[i].setColor(getLabelColor());			}			drawBG();		}				private function drawBG():void {			drawBGCircle(circleOuterRadius, circleInnerRadius);		}				private function drawBGCircle(_outerRadius:Number, _innerRadius:Number):void {			circle.graphics.clear();			circle.graphics.beginFill(color, 1);			circle.graphics.drawCircle(0, 0, circleOuterRadius);			circle.graphics.drawCircle(0, 0, circleInnerRadius);			this.addChildAt(circle, 0);		}		public var labelNames:Array;		public var canRotate:Boolean;				private const circleOuterRadius:Number = 350, circleInnerRadius:Number = 280;		public var color:uint;		private var lastX:Number;		private var lastY:Number;		private var mouseAngleDiff:Number;		private var circle:Shape = new Shape();		private var chemLabels:Array = new Array();}	}