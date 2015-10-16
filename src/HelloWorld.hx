typedef Point<T> = {
	var x:T;
	var y:T;
	@:optional var z:T;
}

class HelloWorld
{
	static public function main():Void {
		trace("Hello World");

		var a:Point<Float> = {x:1,y:2.0,o:1};
	}	
}