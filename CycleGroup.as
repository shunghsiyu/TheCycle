package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class CycleGroup extends Sprite
	{
		public static const cycleGroupRadius:Number = 600;
		public static const cycleScaleRate:Number = 0.5, cycleScaleUp:Number = 0.01;

		public function CycleGroup(_input:String, _is3DMode:Boolean = false) {
			super();
			input = _input;
			isVirtual3D = _is3DMode;
			initialized = false;
			quitButton = new ModeQuitButton();
			if (isVirtual3D) virtual3D = new Virtual3D();
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		public function initialize(e:Event) {
			addCycles();

			var correction:Number = 0.10*cycleGroupRadius;
			for (cycleCount = 0; cycleCount < cycleArray.length; cycleCount++) {
				if (isVirtual3D) virtual3D.addObject(cycleArray[cycleCount],
											/* x= */ (cycleGroupRadius - correction) * Math.sin((-90+cycleCount * (360/cycleArray.length) )*Math.PI/180),
											/* y= */ 0,
											/* z= */ (cycleGroupRadius - correction) * Math.cos((-90+cycleCount * (360/cycleArray.length) )*Math.PI/180)
													);
				else {
					cycleArray[cycleCount].alpha = 0;
					cycleArray[cycleCount].scaleX = 0.5 - tweenScale;
					cycleArray[cycleCount].scaleY = 0.5 - tweenScale;
					cycleArray[cycleCount].x = (1280 - 2*Cycle.circleOuterRadius*(1.2)*cycleArray[cycleCount].scaleX) * cycleCount/(cycleArray.length-1)
									 - 640
									 + Cycle.circleOuterRadius*(1.2)*cycleArray[cycleCount].scaleX
									 - tweenX;
					cycleArray[cycleCount].y = 0 - tweenY;
				}
			}
			cycleCount = 0;
			timer = new Timer(addCycleInterval, cycleArray.length);
			timer.addEventListener(TimerEvent.TIMER, pauseAndAddToList);
			timer.start();

			//Adjust cycle posisiton and add to display list
			
			//Update the projection of the cycles
			if (isVirtual3D) virtual3D.update();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}

		private function addListeners():void {
			//Add listener for the switching between cycle mode and cycleGroup mode
			this.addEventListener(MouseEvent.MOUSE_DOWN, switchMode, false, 1);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, on_KeyDown);
			/*
			this.addEventListener(MouseEvent.MOUSE_OVER, zoomIn, false, 2);
			this.addEventListener(MouseEvent.MOUSE_OUT, zoomOut, false, 2);
			*/

			//Add listener for the CycleGroup instance to start or stop rotate
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, startRotate, false, 0);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopRotate, false, 0);
		}
		
		private function on_KeyDown(e:KeyboardEvent):void {
 			if (e.keyCode==81 && cycleMode) {
        		setCycleGroupMode();
		    }
		}

		private function addCycles():void {
			var inputParser:InputParser = new InputParser(input);
			var cycle:Cycle;
			for(var i = 0; inputParser.hasNextElement() ; i++) {
				inputParser.nextElement();
				cycle = new Cycle(inputParser.getElementName(), inputParser.getElementContent(), MyFunctions.genColor(i) );
				cycleArray.push(cycle);
			}
		}

		private function pauseAndAddToList(e:TimerEvent):void {
			TweenMax.to(cycleArray[cycleCount], tweenTime, 
				{
					alpha: 1,
					x: cycleArray[cycleCount].x + tweenX,
					y: cycleArray[cycleCount].y + tweenY,
					scaleX: cycleArray[cycleCount].scaleX + tweenScale,
					scaleY: cycleArray[cycleCount].scaleY + tweenScale,
					delay: 0.3,
					ease: Cubic.easeOut
				});
			addChild(cycleArray[cycleCount]);
			cycleArray[cycleCount].cacheAsBitmap = true;
			cycleCount++;
			if (cycleCount >= cycleArray.length) {
				addListeners();
				initialized = true;
			}
		}

		/*
		private function zoomIn(e:MouseEvent):void {
			var cycleOver:Cycle = e.target as Cycle;
			if (cycleOver && !cycleMode) {
				lastZoomCycleIndex = getChildIndex(cycleOver);
				setChildIndex(cycleOver, numChildren-1);
			}
		}

		private function zoomOut(e:MouseEvent):void {
			var cycleOut:Cycle = e.target as Cycle;
			if (cycleOut && !cycleMode) {
				setChildIndex(cycleOut, lastZoomCycleIndex);
			}
		}
		*/

		private function startRotate(e:MouseEvent):void {
			var quitButtonClicked:ModeQuitButton = e.target as ModeQuitButton;
			if (!cycleMode && !quitButtonClicked) {
				this.addEventListener(Event.ENTER_FRAME, rotate);
			}
		}
		
		private function stopRotate(e:MouseEvent):void {
				this.removeEventListener(Event.ENTER_FRAME, rotate);
		}
		
		private function rotate(e:Event):void {
			if (isVirtual3D) virtual3D.rotate(0, -1, 0);
		}
		
		private function switchMode(e:MouseEvent):void {
			var cycleClicked:Cycle = e.target as Cycle;
			var quitButtonClicked:ModeQuitButton = e.target as ModeQuitButton;
			if (quitButtonClicked) {
				setCycleGroupMode();
			}
			else if (cycleClicked && !cycleMode) {
				setCycleMode(cycleClicked, e);
			}
		}

		private function setCycleGroupMode():void {
			this.removeChild(quitButton);
			cycleMode = false;

			changeCycleGroupColor();

			setChildIndex(lastActiveCycle, lastActiveCycleIndex);

			cycleScale(lastActiveCycle, -cycleScaleUp);
			
			lastActiveCycle.setRotate(false);
			lastActiveCycle = null;			
		}

		private function setCycleMode(cycleClicked:Cycle, e:MouseEvent):void {
			cycleMode = true;
			lastActiveCycle = cycleClicked;
			lastActiveCycleIndex = getChildIndex(cycleClicked);
				
			addQuitButton(cycleClicked);
			
			changeCycleGroupColor(cycleClicked);
			
			setChildIndex(cycleClicked, numChildren-1);

			cycleScale(cycleClicked, cycleScaleUp);
			
			cycleClicked.setRotate(true);
			cycleClicked.dispatchEvent(e);
		}

		private function cycleScale(targetCycle:Cycle, toScale:Number):void {
			targetCycle.scaleX = targetCycle.scaleX + toScale;
			targetCycle.scaleY = targetCycle.scaleY + toScale;
		}

		private function addQuitButton(cycleClicked):void {
			quitButton.scaleX = cycleClicked.scaleX;
			quitButton.scaleY = cycleClicked.scaleY;
			quitButton.x = cycleClicked.x;
			quitButton.y = cycleClicked.y;
			quitButton.rotationY = cycleClicked.rotationY;
			this.addChildAt(quitButton, numChildren);
		}

		private function changeCycleGroupColor(cycleClicked:Cycle = null):void {
			var targetColor:uint;
			var brightnessToGo:Number;
			for(var i = 0; i < cycleArray.length; i++) {
				if (cycleArray[i] != cycleClicked) {
					if (cycleMode) {
						brightnessToGo = 1 + (dimBrightness - MyFunctions.calBrightness(cycleArray[i].getColor()) )/100;
						TweenMax.to(cycleArray[i], 0.3, {colorMatrixFilter:{amount:1, saturation: 0.1, brightness:brightnessToGo}});
						/*TO FIX -- NOT ALL LABELS GO TO THE SAME BRIGHTNESS! */
						cycleArray[i].cycleNameLabel.setColor(0xAAAAAA);
					}
					else {
						TweenMax.to(cycleArray[i], 0.3, {colorMatrixFilter:{amount:1, saturation:1, brightness: 1}});
						cycleArray[i].cycleNameLabel.setColor(0x000000);
					}
				}
			}
		}
		
		private const tweenX:Number = 100, tweenY:Number = 0, tweenScale:Number = 0.0, tweenTime:Number = 0.5;
		private var initialized:Boolean;
		private var cycleCount:int = 0;
		private const addCycleInterval:Number = 100;
		private var timer:Timer;
		private var isVirtual3D:Boolean, virtual3D:Virtual3D;
		private static const dimBrightness:Number = 200;		
		private var cycleMode:Boolean = false;
		private var input:String;
		private var cycleArray:Array = new Array();
		private var lastActiveCycle:Cycle;
		private var lastActiveCycleIndex:int, lastZoomCycleIndex:int;
		private var quitButton:ModeQuitButton;
	}
}