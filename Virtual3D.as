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
				objectArray[i].zCoord = -objectArray[i].virtualX * Math.sin(rotationY*Math.PI/180) + objectArray[i].virtualZ * Math.cos(rotationY*Math.PI/180);
				objectArray[i].object.scaleX = getScale(objectArray[i]);
				objectArray[i].object.scaleY = getScale(objectArray[i]);
			}
			sortZ();
		}

		private function getScale(_object):Number {
			const MAX = 500;
			var scale:Number = 0.2 + (_object.zCoord*Math.abs(_object.zCoord) )/(MAX*MAX);
			if (scale > 1.5) scale = 1.5;
			else if (scale < 0.05) scale = 0.05;
			return scale;
		}
		
		private var rotationX:Number, rotationY:Number, rotationZ:Number;
		private var objectArray:Array;
		
	}
}