typedef Test<T> = {
	var x:T;
	var y:T;
}

class HelloWorld
{
	static public function main():Void {
		var a = {x:1.0, y:5.0};
		var b:Test<Float> = a;
		trace("Hello World");
	}	
}