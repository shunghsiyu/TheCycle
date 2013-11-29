package
{
	import flash.display.DisplayObject;

	public class Virtual3D
	{
		public function Virtual3D()
		{
			//Constructor
			objectArray = new Array();
			rotationX = 0;
			rotationY = 0;
			rotationZ = 0;
		}
		
		public function addObject(_object:DisplayObject, _virtualX, _virtualY, _virtualZ) {
			objectArray.push({object: _object, virtualX: _virtualX, virtualY: _virtualY, virtualZ: _virtualZ, zCoord: 0});
		}
		
		public function sortZ():void {
			objectArray.sortOn("zCoord", Array.NUMERIC);
			for(var i = objectArray.length-1; i >= 0 ; i--) {
				objectArray[i].object.parent.setChildIndex(objectArray[i].object, 0);
			}
		}
		
		public function rotate(_xRotate:Number, _yRotate:Number, _zRotate:Number):void {
			rotationX += _xRotate;
			rotationY += _yRotate;
			rotationZ += _zRotate;
			update();
		}
		
		public function update():void {
			for(var i = 0; i < objectArray.length; i++) {
				objectArray[i].object.x = objectArray[i].virtualX * Math.cos(rotationY*Math.PI/180) + objectArray[i].virtualZ * Math.sin(rotationY*Math.PI/180);
				objectArray[i].object.y = objectArray[i].virtualY;
				objectArray[i].zCoord = 1 * (-objectArray[i].virtualX * Math.sin(rotationY*Math.PI/180) + objectArray[i].virtualZ * Math.cos(rotationY*Math.PI/180) );
				objectArray[i].object.scaleX = getScale(objectArray[i]);
				objectArray[i].object.scaleY = getScale(objectArray[i]);
			}
			sortZ();
		}

		
		//STILL NEED TO BE FIXED
		private function getScale(_object):Number {
			const MAX = CycleGroup.cycleGroupRadius * 0.85;
			//var criticalScale:Number = 2 * MAX * Math.sin(Math.PI/objectArray.length) / Cycle.circleOuterRadius;
			var criticalDist:Number = MAX * Math.cos(Math.PI/objectArray.length);
			var scale:Number;
			if (_object.zCoord > criticalDist) scale = 0.4 + 2*(_object.zCoord - criticalDist)/MAX;
			else scale = 0.4 * ((_object.zCoord - criticalDist)/(MAX * 2) + 1);
			if (scale > 2) scale = 2;
			else if (scale < 0.05) scale = 0.05;
			return scale;
		}
		
		private var rotationX:Number, rotationY:Number, rotationZ:Number;
		private var objectArray:Array;
		
	}
}