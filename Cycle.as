package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Cycle extends Sprite {
		
		public function Cycle(_cycleName:String, _names:Array = null,  _color:uint = 0x0077F9, _canRotate:Boolean = false) {
			// constructor code
			super();
			labelNames = _names;
			cycleName = _cycleName;
			canRotate = _canRotate;
			color = _color;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
			drawBG();
		}

		//Initialize cycle after it is added to the stage
		public function initialize(e:Event):void {
			
			//Add this name of the cycle
			cycleNameLabel = new Label(cycleName, 0x000000);
			this.addChild(cycleNameLabel);
			
			//Add the ChemLabel
			for (var i:int = 0, cycleWidth:int = circleOuterRadius*2, cycleHeight:int = circleOuterRadius*2; i < labelNames.length; i++) {
				var chemLabel:ChemLabel = new ChemLabel(labelNames[i], color);
				var correction:Number = 0.10*(cycleWidth+cycleHeight)/4;
				chemLabels.push(chemLabel);
				addChild(chemLabels[i]);
				chemLabels[i].x = (cycleWidth/2 - correction) *Math.cos((-90+i*(360/labelNames.length))*Math.PI/180);
				chemLabels[i].y = (cycleHeight/2 - correction)*Math.sin((-90+i*(360/labelNames.length))*Math.PI/180);
				chemLabels[i].cacheAsBitmap = true;
			}
			
			//set whether the cycle can rotate or not according to the passed-in parameter
			setRotate(canRotate);
			
			//Remove the initialize listener because it is no longer needed
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		//Control whether or not the cycle can rotate
		public function setRotate(_canRotate:Boolean):void {
			if (_canRotate) {
				this.mouseChildren = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, startRotate);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, stopRotate);
				this.removeChild(transparentCircle);
				for (var i:int = 0; i < chemLabels.length; i++) {
					chemLabels[i].setActive(true);
				}
			}
			else {
				this.mouseChildren = false;
				this.removeEventListener(MouseEvent.MOUSE_DOWN, startRotate);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotate);
				this.addChildAt(transparentCircle, 0);
				for (var j:int = 0; j < chemLabels.length; j++) {
					chemLabels[i].setActive(false);
				}
			}
		}
		
		private function startRotate(e:MouseEvent):void {
			//Calculate the angle difference between the start of the cycle
			// and the mouse
			var thisGlobalPos:Point = this.parent.localToGlobal(new Point(this.x, this.y) );
			mouseAngleDiff = -this.rotation + MyFunctions.getAngle(this.stage.mouseX - thisGlobalPos.x, this.stage.mouseY - thisGlobalPos.y, 0, -1);
			lastX = this.stage.mouseX;
			lastY = this.stage.mouseY;
			this.addEventListener(Event.ENTER_FRAME, rotating);
		}
		
		private function stopRotate(e:MouseEvent):void {
			this.removeEventListener(Event.ENTER_FRAME, rotating);
		}
		
		//rotate the cycle when drag
		//will be called by event listener
		private function rotating(e:Event):void {
			var vecA:Point;
			var vecB:Point;
			var thisGlobalPos:Point = this.parent.localToGlobal(new Point(this.x, this.y) );
			var toTurn:Number = 0;
			var toTurnEase:Number = 0;
		
			//vecA is the vector pointing from the center to the mouse
			vecA = new Point(this.stage.mouseX - thisGlobalPos.x, this.stage.mouseY - thisGlobalPos.y);
		
			//vecB is the vector pointing from the center to the
			// starting point of the cycle
			if (isNaN(lastX) || isNaN(lastY)) {
				lastX = this.stage.mouseX;//Give lastX&Y the position of mouse
				lastY = this.stage.mouseY;// if they haven't been initialized
			}
			vecB = new Point(lastX - thisGlobalPos.x, lastY - thisGlobalPos.y);
		
			//Get the angel between vecA&B,
			//which will be added
			toTurn = MyFunctions.getAngle(vecA.x, vecA.y, vecB.x, vecB.y);
		
			//Easyease for the rotation:
			toTurnEase = ((this.rotation + toTurn) - this.rotation)*0.2;
			if (Math.abs(toTurnEase) < 0.05)	toTurnEase = 0;
		
			//Update the cycle's rotation value
			this.rotation = this.rotation + toTurnEase;
			
			//Update the last position of cycle to the current one
			// for the next frame
			lastX = thisGlobalPos.x + Math.cos((-90+this.rotation+mouseAngleDiff)*Math.PI/180);
			lastY = thisGlobalPos.y + Math.sin((-90+this.rotation+mouseAngleDiff)*Math.PI/180);
			
			updateAfterRotate();
		}
		
		//keep the labels horizontal even when the cycle rotates
		private function updateAfterRotate():void {
			cycleNameLabel.rotation = -this.rotation;
			for (var i:int = 0; i < chemLabels.length; i++) {
				chemLabels[i].rotation = -this.rotation;
			}
		}
		
		//change the color of this cycle and its labels
		public function setColor(_color:uint):void {
			color = _color;
			//cycleNameLabel.setColor(color);
			for (var i:int = 0; i < chemLabels.length; i++) {
				chemLabels[i].setColor(color);
			}
			drawBG();
		}
		
		//calls other methods that draws the background
		private function drawBG():void {
			drawBGCircle(circleOuterRadius, circleInnerRadius);
		}
		
		//draw the background circle
		private function drawBGCircle(_outerRadius:Number, _innerRadius:Number):void {
			circle.graphics.clear();
			transparentCircle.graphics.clear();
			//fill inner transparent circle
			transparentCircle.graphics.beginFill(0xFFFFFF, 0.3);
			transparentCircle.graphics.drawCircle(0, 0, circleInnerRadius+1);
			transparentCircle.graphics.endFill();
			circle.graphics.beginFill(color, 1);
			circle.graphics.drawCircle(0, 0, circleOuterRadius);
			circle.graphics.drawCircle(0, 0, circleInnerRadius);
			circle.graphics.endFill();
			this.addChildAt(transparentCircle, 0);
			this.addChildAt(circle, 1);
		}
		
		public function getColor():uint {return color;}

		//the name of all the labels in this cycle
		public var labelNames:Array;
		//the pointer array to all the labels in this cycle
		private var chemLabels:Array = new Array();
		
		
		//the dimension of the cycle
		public static const circleOuterRadius:Number = 350, circleInnerRadius:Number = 280;
		//the color of this cycle
		private var color:uint;
		private var canRotate:Boolean;
		//the poisition of the mouse at the frame before
		//used to calculate the angle for method 'rotating'
		private var lastX:Number;
		private var lastY:Number;
		//stores the angle of difference between this frame and last frame
		private var mouseAngleDiff:Number;
		//for drawing the background circle
		private var circle:Shape = new Shape();	
		private var transparentCircle:Shape = new Shape();	
		//Variables for displaying the name of the cycle
		public var cycleName:String;
		public var cycleNameLabel:Label;
	}
	
}


