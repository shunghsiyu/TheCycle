package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;

	public class ModeQuitButton extends MovieClip
	{
		public function ModeQuitButton()
		{
			super();
			arrowShape = new Shape();
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}

		private function initialize(e:Event):void {
			arrowShape.graphics.beginFill(0xD6D6D6, 1);
			arrowShape.graphics.drawCircle(0, 0, (Cycle.circleOuterRadius+Cycle.circleInnerRadius)/2);
			arrowShape.graphics.endFill();
			var midx:int = 15, midy:int = 0;
			arrowShape.graphics.beginFill(0xFFFFFF, 1);
			arrowShape.graphics.moveTo(midx + 180,midy - 60);
			arrowShape.graphics.lineTo(midx + 180,midy + 60);
			arrowShape.graphics.lineTo(midx - 120,midy + 70);
			arrowShape.graphics.lineTo(midx - 100,midy + 140);
			arrowShape.graphics.lineTo(midx - 240,midy);
			arrowShape.graphics.lineTo(midx - 100,midy - 140);
			arrowShape.graphics.lineTo(midx - 120,midy - 70);
			arrowShape.graphics.lineTo(midx + 180,midy - 60);
			arrowShape.graphics.endFill();
			
			addChild(arrowShape);

			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}

		private var arrowShape:Shape;
	}
}