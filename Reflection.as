package
{
	//http://www.tomauger.com/2013/flash-actionscript/actionscript-3-bitmapdata-draw-offset-and-positioning
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.filters.BlurFilter;
	import flash.events.Event;
	
	public class Reflection extends Sprite
	{
		
		public function Reflection(_objectToReflect:Sprite, _reflectionEnd:Number = 0.6, _reflectionAlpha:Number = 0.7, _fadePower:Number = 5):void
		{
			super();
			objectToReflect = _objectToReflect;
			objectBoundBox = objectToReflect.getBounds(objectToReflect);
			reflectionEnd = _reflectionEnd;
			reflectionAlpha = _reflectionAlpha;
			fadePower = _fadePower;
			reflectionData = new BitmapData(objectBoundBox.width, objectBoundBox.height, true, 0x00FFFFFF);

			startDraw();
		}
		
		private function startDraw():void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(-objectBoundBox.left, objectBoundBox.top);
			matrix.rotate(Math.PI);
			matrix.scale(-1, 1);
			reflectionData.draw(objectToReflect, matrix, null, null, null, true);
			fadeOut();
			reflectionHolder = new Bitmap(reflectionData);
			reflectionHolder.alpha = reflectionAlpha;
			reflectionHolder.filters = [new BlurFilter(4, 4, 3)];
			this.addChild(reflectionHolder);
		}

		private function fadeOut():void {
			reflectionData.lock();
			for (var i:int = 0; i < reflectionData.height; i++) {
				var rowFactor:Number = 1 - Math.pow( (i/reflectionData.height)/reflectionEnd, 1/fadePower);
				if (rowFactor < 0) rowFactor = 0;
				for (var j:int = 0; j < reflectionData.width; j++) {
					var pixelColor:uint = reflectionData.getPixel32(j,i);
					var pixelAlpha:uint = pixelColor >>> 24;
					var pixelRGB:uint = pixelColor & 0x00FFFFFF;
					var resultAlpha:uint = pixelAlpha * rowFactor;
					reflectionData.setPixel32(j,i, resultAlpha << 24 | pixelRGB);
				}
			}
			reflectionData.unlock();
		}
		
		public static function addReflection(_objectToReflect:Sprite, _targetChild = true, _reflectionEnd:Number = 0.6, _reflectionAlpha:Number = 0.7, _fadePower:Number = 5):Reflection
		{
			var reflection:Reflection = new Reflection(_objectToReflect, _reflectionEnd, _reflectionAlpha, _fadePower);
			var objectBoundBox:Rectangle = _objectToReflect.getBounds(_objectToReflect);
			if (_targetChild)
			{
				reflection.x = objectBoundBox.left;
				reflection.y = objectBoundBox.bottom;
				//_objectToReflect.addChildAt(reflection, 0);
				_objectToReflect.mouseEnabled = false;
			} else
			{
				reflection.scaleX = _objectToReflect.scaleX;
				reflection.scaleY = _objectToReflect.scaleY;
				reflection.x = _objectToReflect.x + objectBoundBox.left*_objectToReflect.scaleX;
				reflection.y = _objectToReflect.y + objectBoundBox.bottom*_objectToReflect.scaleY;
				//_objectToReflect.parent.addChildAt(reflection, _objectToReflect.parent.getChildIndex(_objectToReflect));
				//_objectToReflect.mouseEnabled = false;
			}
			reflection.mouseChildren = false;
			reflection.mouseEnabled = false;
			return reflection;
		}

		public function getObjectToReflect():Sprite {
			return objectToReflect;
		}
		
		private var reflectionAlpha:Number, reflectionEnd:Number, fadePower:Number;
		private var objectBoundBox:Rectangle;
		private var objectToReflect:Sprite;
		private var reflectionHolder:Bitmap;
		private var reflectionData:BitmapData;
	}
}