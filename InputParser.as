package
{
	public class InputParser
	{
		public function InputParser(_input:String) {
			//Constructor
			input = _input + "\n";
			var newlines:RegExp = /;?\n+/gi;
			input = input.replace(newlines, "\n");
			startPos = 0;
			endPos = 0;
		}
		
		//Check if there are next line from the input
		public function hasNextElement():Boolean {
			if (input.indexOf("\n", startPos) == -1) {
				return false;
			}
			else {
				return true;
			}
		}
		
		//Switch to the next line
		public function nextElement():void {
			initialized = true;
			endPos = input.indexOf("\n", startPos);
			working = input.substring(startPos, endPos);
			nameEndPos = working.indexOf(":");
			startPos = endPos + 1;
		}
		
		//Get the name of the cycle that is before ":"
		public function getElementName():String {
			check();
			if (nameEndPos == -1) {
				return "ERROR: NO NAME";
			}
			return working.substring(0, nameEndPos);
		}
		
		//Get the label names of the cycle that is seperated by ";"
		public function getElementContent():Array {
			check();
			if (nameEndPos == -1) {
				return ["ERROR: NO CONTENT"];
			}
			var temp:String = working.substring(nameEndPos + 1, working.length);
			var tempArray:Array = temp.split(";");

			//Replace the white space before and after the label name
			var headAndEndSpaces:RegExp = /^ +| +$/gi;
			for(var i = 0; i < tempArray.length; i++) {
				tempArray[i] = tempArray[i].replace(headAndEndSpaces, '');
			}

			return tempArray;
		}
		
		//Check if the inputParser has been initialized
		private function check():void {
			if(!initialized) nextElement();
		}
		
		//For checing if the inputParser has been initialized
		private var initialized:Boolean;
		//Specify the working area within the input in index number
		private var startPos:int, endPos:int, nameEndPos:int;
		//The input for this inputParser to process
		private var input:String;
		//Stores the working area, a single line from the input
		private var working:String;
		/*TEST*/
		private var count:int;
	}
}
