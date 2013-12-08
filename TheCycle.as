package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import fl.controls.UIScrollBar;
	import flash.display.Shape;
	import com.greensock.TweenMax;
	
	public class TheCycle extends MovieClip
	{
		public const STAGEW:int = 1280, STAGEH:int = 720;

		public function TheCycle()
		{
			input = "";
			this.addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}

		private function initialize(e:Event) {
			input += "Kreb Cycle: Citrate; cis-Aconitate; D-Isocitrate; \u03B1-KetoGlutarate; Succinyl-CoA; Succinate; Fumarate; Malate; Oxaloacetate\n\n";
			input += "Arginine Cycle 1: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 2: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 3: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 4: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 5: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 6: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 7: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Arginine Cycle 8: Arginine; Omithine; Citrulline; Argininosuccinate\n\n";
			input += "Calvin Cycle: Ribulose 1,5-bisphosphate; 3-phosphoglycerate; 1,3-bisphosphoglycerate; Glyceraldehyde 3-phosphate; Ribulose 5-phosphate\n";

			inputField.text = input;
			scrollBar = new UIScrollBar()
			scrollBar.scrollTarget =inputField;
			scrollBar.height = inputField.height;
			scrollBar.y = inputField.y;
			scrollBar.x = inputField.x - scrollBar.width;
			this.addChild(scrollBar);

			done = new ChemLabel("Done", 0x000000, true);
			done.x = 1200;
			done.y = 680;
			addChild(done);

			edit = new ChemLabel("Edit", 0x000000, true);
			edit.x = 1200;
			edit.y = 40;
			edit.visible = false;
			addChild(edit);

			done.addEventListener(MouseEvent.CLICK, createCycleGroup);
			edit.addEventListener(MouseEvent.CLICK, editCycleGroup);

			done.alpha = 0
			done.visible = false;
			inputField.alpha = 0;
			inputField.visible = false;
			scrollBar.alpha = 0;
			scrollBar.visible = false;
			edit.visible = true;
			cycleGroup = new CycleGroup(inputField.text);
			cycleGroup.x = STAGEW/2;
			cycleGroup.y = STAGEH/2;
			this.addChild(cycleGroup);
		}

		private function createCycleGroup(e:MouseEvent):void {
			TweenMax.to(done, 0.5, {alpha: 0});
			TweenMax.to(inputField, 0.5, {alpha: 0});
			TweenMax.to(scrollBar, 0.5, {alpha: 0, onComplete:onComplete1});
			
			if (cycleGroup != null && this.contains(cycleGroup) ) removeChild(cycleGroup);
			cycleGroup = new CycleGroup(inputField.text, false);
			cycleGroup.x = STAGEW/2;
			cycleGroup.y = STAGEH/2;
			this.addChild(cycleGroup);
			edit.visible = true;
			TweenMax.to(edit, 0.3, {alpha: 1, delay: 0.3});
		}

		private function onComplete1():void {
			done.visible = false;
			inputField.visible = false;
			scrollBar.visible = false;
		}

		private function editCycleGroup(e:MouseEvent):void {
			TweenMax.to(edit, 0.3, {alpha: 0});
			edit.visible = false;
			this.removeChild(cycleGroup);
			done.visible = true;
			inputField.visible = true;
			scrollBar.visible = true;
			TweenMax.to(done, 0.3, {alpha: 1, delay: 0.3});
			TweenMax.to(inputField, 0.3, {alpha: 1, delay: 0.3});
			TweenMax.to(scrollBar, 0.3, {alpha: 1, delay: 0.3});
		}

		private var scrollBar:UIScrollBar;
		private var done:ChemLabel, edit:ChemLabel;
		private var cycleGroup:CycleGroup;
		private var input:String;
	}
}
