package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CycleGroup extends MovieClip
	{
		public function CycleGroup() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		public function initialize(e:Event) {
			var krebCycleLabels:Array = ["Citrate","cis-Aconitate", "D-Isocitrate", "\u03B1-KetoGlutarate", "Succinyl-CoA", "Succinate", "Fumarate", "Malate", "Oxaloacetate"];
			var krebCycle:MovieClip = new Cycle("Kreb Cycle", krebCycleLabels, MyFunctions.genColor(0) );
			this.addChild(krebCycle);
			krebCycle.scaleX = krebCycle.scaleY = 0.5;
			krebCycle.x = 200;
			krebCycle.y = 360;
			
			var arginineCycleLabels:Array = ["Arginine", "Omithine", "Citrulline", "Argininosuccinate"];
			for(var i = 0; i < 8; i++) {
				var arginineCycle:MovieClip = new Cycle("Arginine Cycle", arginineCycleLabels, MyFunctions.genColor(i+1) );
				this.addChild(arginineCycle);
				arginineCycle.mouseChildren = false;
				arginineCycle.scaleX = arginineCycle.scaleY = 0.5;
				arginineCycle.x = krebCycle.x + (i+1)*100;
				arginineCycle.y = 360;
			}
			
			var calvinCycleLabels:Array = ["Ribulose 1,5-bisphosphate", "3-phosphoglycerate", "1,3-bisphosphoglycerate", "Glyceraldehyde 3-phosphate", "Ribulose 5-phosphate"];
			var calvinCycle:MovieClip = new Cycle("Calvin Cycle ", calvinCycleLabels, MyFunctions.genColor(9), false);
			this.addChild(calvinCycle);
			calvinCycle.scaleX = calvinCycle.scaleY = 0.5;
			calvinCycle.x = 1080;
			calvinCycle.y = 360;
			
			this.addEventListener(Event.ENTER_FRAME, changeColor);
			function changeColor(e:Event):void {
				calvinCycle.setColor(MyFunctions.changeColorByHSV(calvinCycle.getColor(), 1, -1, 0) );
			}
			
			this.addEventListener(MouseEvent.CLICK, turnOnCycle);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function turnOnCycle(e:MouseEvent):void {
			var cycleClicked:MovieClip = e.target as Cycle;
			var quitButtonClicked:MovieClip = e.target as ModeQuitButton;
			if (quitButtonClicked) {
				this.removeChild(quitButton);
				setChildIndex(lastActiveCycle, lastActiveCycleIndex);
				lastActiveCycle.scaleX = 0.5;
				lastActiveCycle.scaleY = 0.5;
				lastActiveCycle.setRotate(false);
				lastActiveCycle = null;
			}
			else if (cycleClicked && lastActiveCycle == null) {
				/* setChildIndex can later be removed */
				lastActiveCycle = cycleClicked;
				lastActiveCycleIndex = getChildIndex(cycleClicked);
					
				const scaleMutiplier:Number = 1.5;
				const distanceCorrection:Number = 1.2;
				quitButton.scaleX = cycleClicked.scaleX * scaleMutiplier;
				quitButton.scaleY = cycleClicked.scaleY * scaleMutiplier;
				quitButton.x = cycleClicked.x - (cycleClicked.scaleX * distanceCorrection * Cycle.circleOuterRadius);
				quitButton.y = cycleClicked.y - (cycleClicked.scaleY * distanceCorrection * Cycle.circleOuterRadius);
				this.addChildAt(quitButton, numChildren-1);
				
				setChildIndex(cycleClicked, numChildren-1);
				cycleClicked.scaleX = 0.6;
				cycleClicked.scaleY = 0.6;
				cycleClicked.setRotate(true);
			}
		}
		
		private var lastActiveCycle:MovieClip;
		private var lastActiveCycleIndex:int;
		private var quitButton:MovieClip = new ModeQuitButton();
	}
}
