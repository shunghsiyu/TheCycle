package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CycleGroup extends MovieClip
	{
		public function CycleGroup() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		public function initialize(e:Event) {
			var krebCycleLabels:Array = ["Citrate","cis-Aconitate", "D-Isocitrate", "\u03B1-KetoGlutarate", "Succinyl-CoA", "Succinate", "Fumarate", "Malate", "Oxaloacetate"];
			var krebCycle:MovieClip = new Cycle("Kreb Cycle", krebCycleLabels, true, MyFunctions.genColor(0) );
			this.addChild(krebCycle);
			krebCycle.scaleX = krebCycle.scaleY = 0.5;
			krebCycle.x = 200;
			krebCycle.y = 360;
			
			var arginineCycleLabels:Array = ["Arginine", "Omithine", "Citrulline", "Argininosuccinate"];
			for(var i = 0; i < 8; i++) {
				var arginineCycle:MovieClip = new Cycle("Arginine Cycle", arginineCycleLabels, true, MyFunctions.genColor(i+1) );
				this.addChild(arginineCycle);
				arginineCycle.scaleX = arginineCycle.scaleY = 0.5;
				arginineCycle.x = krebCycle.x + (i+1)*100;
				arginineCycle.y = 360;
			}
			
			var calvinCycleLabels:Array = ["Ribulose 1,5-bisphosphate", "3-phosphoglycerate", "1,3-bisphosphoglycerate", "Glyceraldehyde 3-phosphate", "Ribulose 5-phosphate"];
			var calvinCycle:MovieClip = new Cycle("Calvin Cycle ", calvinCycleLabels, false, MyFunctions.genColor(9) );
			this.addChild(calvinCycle);
			calvinCycle.scaleX = calvinCycle.scaleY = 0.5;
			calvinCycle.x = 1080;
			calvinCycle.y = 360;
			
			this.addEventListener(Event.ENTER_FRAME, changeColor);
			function changeColor(e:Event):void {
				calvinCycle.setColor(MyFunctions.changeColorByHSV(calvinCycle.getColor(), 1, -1, 0) );
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}
}