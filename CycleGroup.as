package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class CycleGroup extends MovieClip
	{
		public function CycleGroup(_input:String) {
			super();
			input = _input;
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		public function initialize(e:Event) {
			//Create the cycles
			var inputParser:InputParser = new InputParser(input);
			var cycle:Cycle;
			for(var i = 0; inputParser.hasNextElement() ; i++) {
				inputParser.nextElement();
				cycle = new Cycle(inputParser.getElementName(), inputParser.getElementContent(), MyFunctions.genColor(i) );
				cycleArray.push(cycle);
			}
			
			//Adjust cycle posisiton and add to display list
			for (var j:int = 0; j < cycleArray.length; j++) {
				cycleArray[j].scaleX = cycleScale;
				cycleArray[j].scaleY = cycleScale;
				var correction:Number = 0.10*cycleGroupRadius;
				setVirtual3DCoord(cycleArray[j], (cycleGroupRadius - correction) * Math.sin((-90+j * (360/cycleArray.length) )*Math.PI/180), 0, (cycleGroupRadius - correction) * Math.cos((-90+j * (360/cycleArray.length) )*Math.PI/180) );
				addChild(cycleArray[j]);
			}
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, turnOnCycle, false, 1);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, startRotate, false, 0);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopRotate, false, 0);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function setVirtual3DCoord(_cycle:Cycle, _x:Number, _y:Number, _z:Number) {
			var coord:Array = MyFunctions.project3D(_x, _y, _z);
			_cycle.x = coord[0];
			_cycle.y = coord[1];
		}
		
		private function startRotate(e:MouseEvent):void {
			var quitButtonClicked:MovieClip = e.target as ModeQuitButton;
			if (!cycleMode && !quitButtonClicked) {
				this.addEventListener(Event.ENTER_FRAME, rotate);
			}
		}
		
		private function stopRotate(e:MouseEvent):void {
				this.removeEventListener(Event.ENTER_FRAME, rotate);
		}
		
		private function rotate(e:Event):void {
			this.rotationY += 1;
			for (var j:int = 0; j < cycleArray.length; j++) {
				cycleArray[j].rotationY = -this.rotationY;
			}
		}
		
		private function turnOnCycle(e:MouseEvent):void {
			var cycleClicked:MovieClip = e.target as Cycle;
			var quitButtonClicked:MovieClip = e.target as ModeQuitButton;
			if (quitButtonClicked) {
				this.removeChild(quitButton);
				for(var i = 0; i < cycleArray.length; i++) {
					if (cycleArray[i] != cycleClicked) {
						cycleArray[i].setColor( MyFunctions.genColor(i) );
						cycleArray[i].cycleNameLabel.setColor(0x000000);
					}
				}
				setChildIndex(lastActiveCycle, lastActiveCycleIndex);
				lastActiveCycle.scaleX = cycleScale;
				lastActiveCycle.scaleY = cycleScale;
				lastActiveCycle.setRotate(false);
				lastActiveCycle = null;
				cycleMode = false;
			}
			else if (cycleClicked && lastActiveCycle == null) {
				cycleMode = true;
				
				/* setChildIndex can later be removed */
				lastActiveCycle = cycleClicked;
				lastActiveCycleIndex = getChildIndex(cycleClicked);
					
				const scaleMutiplier:Number = 7;
				const distanceCorrection:Number = 1.2;
				quitButton.scaleX = cycleClicked.scaleX * scaleMutiplier;
				quitButton.scaleY = cycleClicked.scaleY * scaleMutiplier;
				quitButton.x = cycleClicked.x;
				quitButton.y = cycleClicked.y;
				quitButton.z = cycleClicked.z;
				quitButton.rotationY = cycleClicked.rotationY;
				this.addChildAt(quitButton, numChildren);
				
				for(var j = 0; j < cycleArray.length; j++) {
					if (cycleArray[j] != cycleClicked) {
						cycleArray[j].setColor( MyFunctions.changeColorByHSV(cycleArray[j].getColor(), 0, -95, -10) );
						cycleArray[j].cycleNameLabel.setColor(0xAAAAAA);
					}
				}
				
				setChildIndex(cycleClicked, numChildren-1);
				cycleClicked.scaleX = cycleScale + cycleScaleUp;
				cycleClicked.scaleY = cycleScale + cycleScaleUp;
				cycleClicked.setRotate(true);
			}
		}
		
		public static const cycleGroupRadius:Number = 360;
		public static const cycleScale:Number = 0.5, cycleScaleUp:Number = 0.01;
		private var cycleMode:Boolean = false;
		private var input:String;
		private var cycleArray:Array = new Array();
		private var lastActiveCycle:MovieClip;
		private var lastActiveCycleIndex:int;
		private var quitButton:MovieClip = new ModeQuitButton();
	}
}

