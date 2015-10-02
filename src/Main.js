(function (console) { "use strict";
var HelloWorld = function() { };
HelloWorld.main = function() {
	console.log("Hello World");
};
HelloWorld.main();
})(typeof console != "undefined" ? console : {log:function(){}});
