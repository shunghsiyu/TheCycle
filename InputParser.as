package
{
	public class InputParser
	{
		public function InputParser(_input:String = "123: test, test2\n") {
			//Constructor
			input = _input;
			startPos = 0;
		}
		
		public function nextElement():void {
			initialized = true;
			endPos = input.indexOf("\n", startPos);
			working = input.substring(startPos, endPos);
			startPos = endPos + 1;
		}
		
		public function hasNextElement():Boolean {
			if (input.indexOf("\n", startPos) == -1 ) {
				return false;
			}
			else {
				return true;
			}
		}
		
		public function getElementName():String {
			check();
			return working.substring(0, working.indexOf(":") );
		}
		
		public function getElementContent():Array {
			check();
			//NEED TO AVOID SPACES INSIDE A WORD
			var spaces:RegExp = / /gi;
			var temp:String = working.substring(working.indexOf(":") + 1, working.length);
			temp = temp.replace(spaces, '');
			return temp.split(";");
		}
		
		private function check():void {
			if(!initialized) nextElement();
		}
		
		private var initialized:Boolean;
		private var startPos:int, endPos:int;
		private var input:String;
		private var working:String;
	}
}
