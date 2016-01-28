(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,__class__: EReg
};
var com_genome2d_proto_IGPrototypable = function() { };
com_genome2d_proto_IGPrototypable.__name__ = true;
com_genome2d_proto_IGPrototypable.prototype = {
	__class__: com_genome2d_proto_IGPrototypable
};
var com_genome2d_components_GComponent = function() {
	this.g2d_currentState = "default";
	this.g2d_active = true;
};
com_genome2d_components_GComponent.__name__ = true;
com_genome2d_components_GComponent.__interfaces__ = [com_genome2d_proto_IGPrototypable];
com_genome2d_components_GComponent.prototype = {
	get_userData: function() {
		if(this.g2d_userData == null) this.g2d_userData = new haxe_ds_StringMap();
		return this.g2d_userData;
	}
	,isActive: function() {
		return this.g2d_active;
	}
	,setActive: function(p_value) {
		this.g2d_active = p_value;
	}
	,get_node: function() {
		return this.g2d_node;
	}
	,init: function() {
	}
	,dispose: function() {
	}
	,g2d_dispose: function() {
		this.dispose();
		this.g2d_active = false;
		this.g2d_node = null;
	}
	,toReference: function() {
		return null;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GComponent");
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_components_GComponent
	,__properties__: {get_node:"get_node",get_userData:"get_userData"}
};
var EmitterUI = function() {
	this.doDrag = false;
	com_genome2d_components_GComponent.call(this);
};
EmitterUI.__name__ = true;
EmitterUI.__super__ = com_genome2d_components_GComponent;
EmitterUI.prototype = $extend(com_genome2d_components_GComponent.prototype,{
	setup: function(p_particleSystem,p_gravity) {
		EmitterUI.g2d_count = (EmitterUI.g2d_count + 1) % 8;
		this.g2d_particleSystem = p_particleSystem;
		this.drag = com_genome2d_node_GNode.createWithComponent(com_genome2d_components_renderable_GSprite);
		this.drag.texture = com_genome2d_textures_GTextureManager.getTexture("assets/atlas_" + EmitterUI.g2d_count);
		this.drag.g2d_node.mouseEnabled = true;
		this.drag.g2d_node.get_onMouseDown().add($bind(this,this.dragMouseDown_handler));
		this.g2d_node.addChild(this.drag.g2d_node);
		this.emitter = new com_genome2d_particles_GEmitter();
		this.emitter.texture = com_genome2d_textures_GTextureManager.getTexture("assets/atlas_particle");
		this.emitter.burstDistribution = [.1,25];
		this.emitter.duration = .3;
		this.emitter.blendMode = 2;
		this.emitter.loop = true;
		this.emitter.addModule(new SPHModule(p_gravity));
		this.emitter.addModule(new SpawnModule(p_gravity));
		this.g2d_particleSystem.addEmitter(this.emitter);
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_onUpdate().add($bind(this,this.update_handler));
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).getContext().onMouseInput.add($bind(this,this.dragMouse_handler));
	}
	,update_handler: function(p_deltaTime) {
		this.emitter.x = this.g2d_node.g2d_localX;
		this.emitter.y = this.g2d_node.g2d_localY;
	}
	,dragMouseDown_handler: function(p_input) {
		this.doDrag = true;
	}
	,dragMouse_handler: function(p_input) {
		var _g = p_input.type;
		switch(_g) {
		case "mouseDown":
			this.doDrag = false;
			break;
		case "mouseUp":
			break;
		case "mouseMove":
			if(this.doDrag) {
				this.g2d_node.setPosition(p_input.contextX,p_input.contextY);
				this.emitter.x = this.g2d_node.g2d_localX;
				this.emitter.y = this.g2d_node.g2d_localY;
			}
			break;
		}
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"EmitterUI");
		return com_genome2d_components_GComponent.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_components_GComponent.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: EmitterUI
});
var com_genome2d_proto_GPrototypeHelper = function() { };
com_genome2d_proto_GPrototypeHelper.__name__ = true;
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
_$List_ListIterator.__name__ = true;
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var com_genome2d_particles_GParticleModule = function() {
	this.enabled = true;
	this.updateModule = false;
	this.spawnModule = false;
};
com_genome2d_particles_GParticleModule.__name__ = true;
com_genome2d_particles_GParticleModule.prototype = {
	spawn: function(p_emitter,p_particle) {
	}
	,update: function(p_emitter,p_particle,p_deltaTime) {
	}
	,__class__: com_genome2d_particles_GParticleModule
};
var SPHModule = function(p_gravity) {
	this.g2d_count = 0;
	com_genome2d_particles_GParticleModule.call(this);
	this.g2d_gravity = p_gravity;
	this.updateModule = true;
};
SPHModule.__name__ = true;
SPHModule.__super__ = com_genome2d_particles_GParticleModule;
SPHModule.prototype = $extend(com_genome2d_particles_GParticleModule.prototype,{
	spawn: function(p_emitter,p_particle) {
		this.g2d_count = ++this.g2d_count % 25;
		p_particle.x += -10 + this.g2d_count % 5 % 10 * 6;
		p_particle.y += -10 + (this.g2d_count / 5 | 0) % 10 * 6;
		p_particle.vy += this.g2d_gravity * 10;
		p_particle.totalEnergy = 1000;
	}
	,update: function(p_emitter,p_particle,p_deltaTime) {
		p_particle.vy += this.g2d_gravity;
		if(p_particle.density > 0) {
			p_particle.vx += p_particle.fx / (p_particle.density * 0.9 + 0.1);
			p_particle.vy += p_particle.fy / (p_particle.density * 0.9 + 0.1);
		}
		p_particle.vx *= 0.99;
		p_particle.vy *= 0.99;
		p_particle.x += p_particle.vx;
		p_particle.y += p_particle.vy;
		if(p_particle.x < 5) p_particle.die = true; else if(p_particle.x > 795) p_particle.die = true;
		if(p_particle.y < 5) p_particle.die = true; else if(p_particle.y > 595) p_particle.die = true;
		p_particle.totalEnergy -= p_deltaTime;
		if(p_particle.totalEnergy <= 0) p_particle.die = true;
	}
	,__class__: SPHModule
});
var SpawnModule = function(p_gravity) {
	this.g2d_count = 0;
	com_genome2d_particles_GParticleModule.call(this);
	this.g2d_gravity = p_gravity;
	this.spawnModule = true;
};
SpawnModule.__name__ = true;
SpawnModule.__super__ = com_genome2d_particles_GParticleModule;
SpawnModule.prototype = $extend(com_genome2d_particles_GParticleModule.prototype,{
	spawn: function(p_emitter,p_particle) {
		this.g2d_count = ++this.g2d_count % 25;
		p_particle.x += -10 + this.g2d_count % 5 % 10 * 6;
		p_particle.y += -10 + (this.g2d_count / 5 | 0) % 10 * 6;
		p_particle.vy += this.g2d_gravity * 10;
		p_particle.totalEnergy = 1000000;
	}
	,__class__: SpawnModule
});
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	add: function(x) {
		this.b += Std.string(x);
	}
	,addSub: function(s,pos,len) {
		if(len == null) this.b += HxOverrides.substr(s,pos,null); else this.b += HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
var Test = function() {
	this.initGenome();
};
Test.__name__ = true;
Test.main = function() {
	var inst = new Test();
};
Test.prototype = {
	initGenome: function() {
		com_genome2d_context_stats_GStats.visible = true;
		if(com_genome2d_Genome2D.g2d_instance == null) {
			com_genome2d_Genome2D.g2d_instantiable = true;
			new com_genome2d_Genome2D();
			com_genome2d_Genome2D.g2d_instantiable = false;
		}
		this.genome = com_genome2d_Genome2D.g2d_instance;
		this.genome.g2d_onFailed.addOnce($bind(this,this.genomeFailed_handler));
		this.genome.g2d_onInitialized.addOnce($bind(this,this.genomeInitialized_handler));
		this.genome.init(new com_genome2d_context_GContextConfig());
	}
	,genomeFailed_handler: function(p_msg) {
	}
	,genomeInitialized_handler: function() {
		this.loadAssets();
	}
	,loadAssets: function() {
		com_genome2d_assets_GAssetManager.addFromUrl("assets/atlas.png");
		com_genome2d_assets_GAssetManager.addFromUrl("assets/atlas.xml");
		com_genome2d_assets_GAssetManager.addFromUrl("assets/texture.png");
		com_genome2d_assets_GAssetManager.g2d_onQueueFailed.add($bind(this,this.assetsFailed_handler));
		com_genome2d_assets_GAssetManager.g2d_onQueueLoaded.addOnce($bind(this,this.assetsLoaded_handler));
		com_genome2d_assets_GAssetManager.loadQueue();
	}
	,assetsFailed_handler: function(p_asset) {
	}
	,assetsLoaded_handler: function() {
		com_genome2d_assets_GAssetManager.generateTextures();
		this.initExample();
	}
	,initExample: function() {
		this.particleSystem = new com_genome2d_particles_GSPHParticleSystem();
		this.particleSystem.setRegion(new com_genome2d_geom_GRectangle(0,0,800,600));
		var emitter = com_genome2d_node_GNode.createWithComponent(EmitterUI);
		emitter.setup(this.particleSystem,.2);
		emitter.g2d_node.setPosition(400,300);
		this.genome.g2d_root.addChild(emitter.g2d_node);
		var emitter1 = com_genome2d_node_GNode.createWithComponent(EmitterUI);
		emitter1.setup(this.particleSystem,-.2);
		emitter1.g2d_node.setPosition(400,100);
		this.genome.g2d_root.addChild(emitter1.g2d_node);
		this.genome.g2d_onUpdate.add($bind(this,this.update_handler));
		this.genome.g2d_onPostRender.add($bind(this,this.postRender_handler));
	}
	,update_handler: function(p_deltaTime) {
		this.particleSystem.update(p_deltaTime);
	}
	,postRender_handler: function() {
		this.particleSystem.render(this.genome.g2d_context,0,0,1,1,1,1,1,1);
	}
	,__class__: Test
};
var Type = function() { };
Type.__name__ = true;
Type.getSuperClass = function(c) {
	return c.__super__;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw new js__$Boot_HaxeError("Too many arguments");
	}
	return null;
};
var Xml = function(nodeType) {
	this.nodeType = nodeType;
	this.children = [];
	this.attributeMap = new haxe_ds_StringMap();
};
Xml.__name__ = true;
Xml.parse = function(str) {
	return haxe_xml_Parser.parse(str);
};
Xml.createElement = function(name) {
	var xml = new Xml(Xml.Element);
	if(xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + xml.nodeType);
	xml.nodeName = name;
	return xml;
};
Xml.createPCData = function(data) {
	var xml = new Xml(Xml.PCData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createCData = function(data) {
	var xml = new Xml(Xml.CData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createComment = function(data) {
	var xml = new Xml(Xml.Comment);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocType = function(data) {
	var xml = new Xml(Xml.DocType);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createProcessingInstruction = function(data) {
	var xml = new Xml(Xml.ProcessingInstruction);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocument = function() {
	return new Xml(Xml.Document);
};
Xml.prototype = {
	get_nodeValue: function() {
		if(this.nodeType == Xml.Document || this.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + this.nodeType);
		return this.nodeValue;
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		return this.attributeMap.get(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		this.attributeMap.set(att,value);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		return this.attributeMap.exists(att);
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		return this.attributeMap.keys();
	}
	,elements: function() {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		var ret;
		var _g = [];
		var _g1 = 0;
		var _g2 = this.children;
		while(_g1 < _g2.length) {
			var child = _g2[_g1];
			++_g1;
			if(child.nodeType == Xml.Element) _g.push(child);
		}
		ret = _g;
		return HxOverrides.iter(ret);
	}
	,elementsNamed: function(name) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		var ret;
		var _g = [];
		var _g1 = 0;
		var _g2 = this.children;
		while(_g1 < _g2.length) {
			var child = _g2[_g1];
			++_g1;
			if(child.nodeType == Xml.Element && (function($this) {
				var $r;
				if(child.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + child.nodeType);
				$r = child.nodeName;
				return $r;
			}(this)) == name) _g.push(child);
		}
		ret = _g;
		return HxOverrides.iter(ret);
	}
	,firstElement: function() {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		var _g = 0;
		var _g1 = this.children;
		while(_g < _g1.length) {
			var child = _g1[_g];
			++_g;
			if(child.nodeType == Xml.Element) return child;
		}
		return null;
	}
	,addChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(x.parent != null) x.parent.removeChild(x);
		this.children.push(x);
		x.parent = this;
	}
	,removeChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(HxOverrides.remove(this.children,x)) {
			x.parent = null;
			return true;
		}
		return false;
	}
	,__class__: Xml
	,__properties__: {get_nodeValue:"get_nodeValue"}
};
var com_genome2d_debug_IGDebuggableInternal = function() { };
com_genome2d_debug_IGDebuggableInternal.__name__ = true;
var com_genome2d_Genome2D = function() {
	this.g2d_renderMatrixIndex = 0;
	this.g2d_runTime = 0;
	this.g2d_currentFrameId = 0;
	this.autoUpdateAndRender = true;
	if(!com_genome2d_Genome2D.g2d_instantiable) com_genome2d_debug_GDebug.error("Can't instantiate singleton directly",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "Genome2D.hx", lineNumber : 201, className : "com.genome2d.Genome2D", methodName : "new"});
	com_genome2d_Genome2D.g2d_instance = this;
	this.g2d_onInitialized = new com_genome2d_callbacks_GCallback0();
	this.g2d_onFailed = new com_genome2d_callbacks_GCallback1();
	this.g2d_onInvalidated = new com_genome2d_callbacks_GCallback0();
	this.g2d_onUpdate = new com_genome2d_callbacks_GCallback1();
	this.g2d_onPreRender = new com_genome2d_callbacks_GCallback0();
	this.g2d_onPostRender = new com_genome2d_callbacks_GCallback0();
	this.g2d_onKeyboardInput = new com_genome2d_callbacks_GCallback1();
};
com_genome2d_Genome2D.__name__ = true;
com_genome2d_Genome2D.__interfaces__ = [com_genome2d_debug_IGDebuggableInternal];
com_genome2d_Genome2D.getInstance = function() {
	if(com_genome2d_Genome2D.g2d_instance == null) {
		com_genome2d_Genome2D.g2d_instantiable = true;
		new com_genome2d_Genome2D();
		com_genome2d_Genome2D.g2d_instantiable = false;
	}
	return com_genome2d_Genome2D.g2d_instance;
};
com_genome2d_Genome2D.prototype = {
	get_onInitialized: function() {
		return this.g2d_onInitialized;
	}
	,get_onFailed: function() {
		return this.g2d_onFailed;
	}
	,get_onInvalidated: function() {
		return this.g2d_onInvalidated;
	}
	,get_onUpdate: function() {
		return this.g2d_onUpdate;
	}
	,get_onPreRender: function() {
		return this.g2d_onPreRender;
	}
	,get_onPostRender: function() {
		return this.g2d_onPostRender;
	}
	,get_onKeyboardInput: function() {
		return this.g2d_onKeyboardInput;
	}
	,getCurrentFrameId: function() {
		return this.g2d_currentFrameId;
	}
	,getRunTime: function() {
		return this.g2d_runTime;
	}
	,getCurrentFrameDeltaTime: function() {
		return this.g2d_currentFrameDeltaTime;
	}
	,get_root: function() {
		return this.g2d_root;
	}
	,getContext: function() {
		return this.g2d_context;
	}
	,init: function(p_config) {
		if(this.g2d_root != null) this.g2d_root.dispose();
		this.g2d_root = com_genome2d_node_GNode.create("root");
		this.g2d_cameras = [];
		this.g2d_renderMatrix = new com_genome2d_geom_GMatrix();
		this.g2d_renderMatrixIndex = 0;
		this.g2d_renderMatrixArray = [];
		if(this.g2d_context != null) this.g2d_context.dispose();
		this.g2d_contextConfig = p_config;
		this.g2d_context = Type.createInstance(p_config.contextClass,[this.g2d_contextConfig]);
		this.g2d_context.onInitialized.add($bind(this,this.g2d_contextInitialized_handler));
		this.g2d_context.onFailed.add($bind(this,this.g2d_contextFailed_handler));
		this.g2d_context.onInvalidated.add($bind(this,this.g2d_contextInvalidated_handler));
		com_genome2d_proto_GPrototypeFactory.initializePrototypes();
		com_genome2d_assets_GAssetManager.init();
		com_genome2d_text_GFontManager.init();
		com_genome2d_textures_GTextureManager.init(this.g2d_context);
		com_genome2d_ui_skin_GUISkinManager.init();
		com_genome2d_transitions_GTransitionManager.init();
		this.g2d_context.init();
	}
	,update: function(p_deltaTime) {
		this.g2d_currentFrameDeltaTime = p_deltaTime;
		this.g2d_onUpdate.dispatch(this.g2d_currentFrameDeltaTime);
	}
	,render: function(p_camera) {
		if(this.g2d_context.begin()) {
			this.g2d_onPreRender.dispatch();
			if(this.g2d_root.g2d_localUseMatrix > 0) {
				this.g2d_renderMatrix.identity();
				this.g2d_renderMatrixArray = [];
			}
			if(p_camera != null) p_camera.render(); else {
				var cameraCount = this.g2d_cameras.length;
				if(cameraCount == 0) this.g2d_root.render(false,false,this.g2d_context.getDefaultCamera(),false,false); else {
					var _g = 0;
					while(_g < cameraCount) {
						var i = _g++;
						this.g2d_cameras[i].render();
					}
				}
			}
			if(this.g2d_onPostRender.hasListeners()) {
				this.g2d_context.setActiveCamera(this.g2d_context.getDefaultCamera());
				this.g2d_context.setRenderTarget(null);
				this.g2d_onPostRender.dispatch();
			}
			this.g2d_context.end();
		}
	}
	,dispose: function() {
		if(this.g2d_root != null) this.g2d_root.dispose();
		this.g2d_root = null;
		this.g2d_onInitialized.removeAll();
		this.g2d_onFailed.removeAll();
		this.g2d_onPostRender.removeAll();
		this.g2d_onPreRender.removeAll();
		this.g2d_onUpdate.removeAll();
		this.g2d_onInvalidated.removeAll();
		this.g2d_onKeyboardInput.removeAll();
		this.g2d_context.dispose();
		this.g2d_context = null;
	}
	,g2d_contextInitialized_handler: function() {
		this.g2d_context.onFrame.add($bind(this,this.g2d_frame_handler));
		this.g2d_context.g2d_onMouseInputInternal = $bind(this,this.g2d_contextMouseInput_handler);
		this.g2d_context.onKeyboardInput.add($bind(this,this.g2d_contextKeyboardInput_handler));
		this.g2d_onInitialized.dispatch();
	}
	,g2d_contextFailed_handler: function(p_error) {
		if(this.g2d_contextConfig.fallbackContextClass != null) {
			this.g2d_context = Type.createInstance(this.g2d_contextConfig.fallbackContextClass,[this.g2d_contextConfig]);
			this.g2d_context.onInitialized.add($bind(this,this.g2d_contextInitialized_handler));
			this.g2d_context.onFailed.add($bind(this,this.g2d_contextFailed_handler));
			this.g2d_context.init();
		}
		this.g2d_onFailed.dispatch(p_error);
	}
	,g2d_contextInvalidated_handler: function() {
		this.g2d_onInvalidated.dispatch();
	}
	,g2d_frame_handler: function(p_deltaTime) {
		if(this.autoUpdateAndRender) {
			this.g2d_currentFrameId++;
			this.g2d_runTime += p_deltaTime;
			this.update(p_deltaTime);
			this.render();
		}
	}
	,getCamera: function(p_id) {
		var _g1 = 0;
		var _g = this.g2d_cameras.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.g2d_cameras[i].id == p_id) return this.g2d_cameras[i];
		}
		return null;
	}
	,g2d_addCameraController: function(p_camera) {
		var _g1 = 0;
		var _g = this.g2d_cameras.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.g2d_cameras[i] == p_camera) return;
		}
		this.g2d_cameras.push(p_camera);
	}
	,g2d_removeCameraController: function(p_camera) {
		var _g1 = 0;
		var _g = this.g2d_cameras.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.g2d_cameras[i] == p_camera) this.g2d_cameras.splice(i,1);
		}
	}
	,g2d_contextMouseInput_handler: function(p_input) {
		if(this.g2d_cameras.length == 0) this.g2d_root.captureMouseInput(p_input); else {
			var _g1 = 0;
			var _g = this.g2d_cameras.length;
			while(_g1 < _g) {
				var i1 = _g1++;
				this.g2d_cameras[i1].g2d_capturedThisFrame = false;
			}
			var i = this.g2d_cameras.length - 1;
			while(i >= 0) {
				this.g2d_cameras[i].captureMouseInput(p_input);
				i--;
			}
		}
	}
	,g2d_contextKeyboardInput_handler: function(p_input) {
		this.g2d_onKeyboardInput.dispatch(p_input);
	}
	,__class__: com_genome2d_Genome2D
	,__properties__: {get_root:"get_root",get_onKeyboardInput:"get_onKeyboardInput",get_onPostRender:"get_onPostRender",get_onPreRender:"get_onPreRender",get_onUpdate:"get_onUpdate",get_onInvalidated:"get_onInvalidated",get_onFailed:"get_onFailed",get_onInitialized:"get_onInitialized"}
};
var com_genome2d_animation_GFrameAnimation = function(p_frameTextures) {
	this.g2d_currentFrame = -1;
	this.g2d_playing = true;
	this.g2d_endIndex = -1;
	this.g2d_startIndex = -1;
	this.g2d_lastUpdatedFrameId = 0;
	this.g2d_accumulatedTime = 0;
	this.g2d_speed = 33.333333333333336;
	this.reversed = false;
	this.repeatable = true;
	this.timeDilation = 1;
	this.g2d_frameTextures = p_frameTextures;
	this.g2d_frameCount = p_frameTextures.length;
	this.g2d_currentFrame = 0;
	if(this.g2d_frameTextures.length > 0) this.currentFrameTexture = this.g2d_frameTextures[0]; else this.currentFrameTexture = null;
	this.g2d_frameTextures;
};
com_genome2d_animation_GFrameAnimation.__name__ = true;
com_genome2d_animation_GFrameAnimation.prototype = {
	get_frameRate: function() {
		return 1000 / this.g2d_speed | 0;
	}
	,set_frameRate: function(p_value) {
		this.g2d_speed = 1000 / p_value;
		return p_value;
	}
	,get_frameCount: function() {
		return this.g2d_frameCount;
	}
	,get_currentFrame: function() {
		return this.g2d_currentFrame;
	}
	,set_frameTextures: function(p_value) {
		this.g2d_frameTextures = p_value;
		this.g2d_frameCount = p_value.length;
		this.g2d_currentFrame = 0;
		if(this.g2d_frameTextures.length > 0) this.currentFrameTexture = this.g2d_frameTextures[0]; else this.currentFrameTexture = null;
		return this.g2d_frameTextures;
	}
	,gotoFrame: function(p_frame) {
		if(this.g2d_frameTextures == null) return;
		this.g2d_currentFrame = p_frame;
		this.g2d_currentFrame %= this.g2d_frameCount;
		this.currentFrameTexture = this.g2d_frameTextures[this.g2d_currentFrame];
	}
	,gotoAndPlay: function(p_frame) {
		this.gotoFrame(p_frame);
		this.play();
	}
	,gotoAndStop: function(p_frame) {
		this.gotoFrame(p_frame);
		this.stop();
	}
	,stop: function() {
		this.g2d_playing = false;
	}
	,play: function() {
		this.g2d_playing = true;
	}
	,update: function(p_deltaTime) {
		if(this.g2d_playing && this.g2d_frameCount > 1) {
			this.g2d_accumulatedTime += p_deltaTime * this.timeDilation;
			if(this.g2d_accumulatedTime >= this.g2d_speed) {
				if(this.reversed) this.g2d_currentFrame += -(this.g2d_accumulatedTime / this.g2d_speed | 0); else this.g2d_currentFrame += this.g2d_accumulatedTime / this.g2d_speed | 0;
				if(this.reversed && this.g2d_currentFrame < 0) {
					if(this.repeatable) this.g2d_currentFrame = this.g2d_frameCount + this.g2d_currentFrame % this.g2d_frameCount; else {
						this.g2d_currentFrame = 0;
						this.g2d_playing = false;
					}
				} else if(!this.reversed && this.g2d_currentFrame >= this.g2d_frameCount) {
					if(this.repeatable) this.g2d_currentFrame = this.g2d_currentFrame % this.g2d_frameCount; else {
						this.g2d_currentFrame = this.g2d_frameCount - 1;
						this.g2d_playing = false;
					}
				}
				this.currentFrameTexture = this.g2d_frameTextures[this.g2d_currentFrame];
			}
			this.g2d_accumulatedTime %= this.g2d_speed;
		}
	}
	,__class__: com_genome2d_animation_GFrameAnimation
	,__properties__: {set_frameTextures:"set_frameTextures",get_currentFrame:"get_currentFrame",get_frameCount:"get_frameCount",set_frameRate:"set_frameRate",get_frameRate:"get_frameRate"}
};
var com_genome2d_assets_GAsset = function(p_url,p_id) {
	if(p_id == null) p_id = "";
	if(p_url == null) p_url = "";
	this.g2d_loaded = false;
	this.g2d_loading = false;
	this.g2d_id = "";
	this.onLoaded = new com_genome2d_callbacks_GCallback1(com_genome2d_assets_GAsset);
	this.onFailed = new com_genome2d_callbacks_GCallback1(com_genome2d_assets_GAsset);
	if(p_id != this.g2d_id && p_id.length > 0) {
		if(com_genome2d_assets_GAssetManager.g2d_references.get(p_id) != null) com_genome2d_debug_GDebug.error("Duplicate asset id: " + p_id,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GAsset.hx", lineNumber : 32, className : "com.genome2d.assets.GAsset", methodName : "set_id"});
		com_genome2d_assets_GAssetManager.g2d_references.set(p_id,this);
		if(com_genome2d_assets_GAssetManager.g2d_references.get(this.g2d_id) != null) com_genome2d_assets_GAssetManager.g2d_references.remove(this.g2d_id);
		this.g2d_id = p_id;
	}
	this.g2d_id;
	this.set_url(p_url);
};
com_genome2d_assets_GAsset.__name__ = true;
com_genome2d_assets_GAsset.prototype = {
	get_id: function() {
		return this.g2d_id;
	}
	,set_id: function(p_value) {
		if(p_value != this.g2d_id && p_value.length > 0) {
			if(com_genome2d_assets_GAssetManager.g2d_references.get(p_value) != null) com_genome2d_debug_GDebug.error("Duplicate asset id: " + p_value,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GAsset.hx", lineNumber : 32, className : "com.genome2d.assets.GAsset", methodName : "set_id"});
			com_genome2d_assets_GAssetManager.g2d_references.set(p_value,this);
			if(com_genome2d_assets_GAssetManager.g2d_references.get(this.g2d_id) != null) com_genome2d_assets_GAssetManager.g2d_references.remove(this.g2d_id);
			this.g2d_id = p_value;
		}
		return this.g2d_id;
	}
	,get_url: function() {
		return this.g2d_url;
	}
	,set_url: function(p_value) {
		if(!this.isLoaded()) {
			this.g2d_url = p_value;
			if(this.g2d_id == "") this.set_id((function($this) {
				var $r;
				var pos = $this.g2d_url.lastIndexOf("\\") + 1;
				$r = HxOverrides.substr($this.g2d_url,pos,null);
				return $r;
			}(this)));
		} else com_genome2d_debug_GDebug.warning("Asset already loaded " + this.g2d_id,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GAsset.hx", lineNumber : 54, className : "com.genome2d.assets.GAsset", methodName : "set_url"});
		return this.g2d_url;
	}
	,isLoading: function() {
		return this.g2d_loading;
	}
	,isLoaded: function() {
		return this.g2d_loaded;
	}
	,load: function() {
	}
	,toReference: function() {
		return null;
	}
	,dispose: function() {
	}
	,__class__: com_genome2d_assets_GAsset
	,__properties__: {set_url:"set_url",get_url:"get_url",set_id:"set_id",get_id:"get_id"}
};
var com_genome2d_assets_GAssetManager = function() { };
com_genome2d_assets_GAssetManager.__name__ = true;
com_genome2d_assets_GAssetManager.__properties__ = {get_onQueueFailed:"get_onQueueFailed",get_onQueueLoaded:"get_onQueueLoaded"}
com_genome2d_assets_GAssetManager.getAssets = function() {
	return com_genome2d_assets_GAssetManager.g2d_references;
};
com_genome2d_assets_GAssetManager.isLoading = function() {
	return com_genome2d_assets_GAssetManager.g2d_loading;
};
com_genome2d_assets_GAssetManager.get_onQueueLoaded = function() {
	return com_genome2d_assets_GAssetManager.g2d_onQueueLoaded;
};
com_genome2d_assets_GAssetManager.get_onQueueFailed = function() {
	return com_genome2d_assets_GAssetManager.g2d_onQueueFailed;
};
com_genome2d_assets_GAssetManager.init = function() {
	com_genome2d_assets_GAssetManager.g2d_loadQueue = [];
	com_genome2d_assets_GAssetManager.g2d_references = new haxe_ds_StringMap();
	com_genome2d_assets_GAssetManager.g2d_onQueueLoaded = new com_genome2d_callbacks_GCallback0();
	com_genome2d_assets_GAssetManager.g2d_onQueueFailed = new com_genome2d_callbacks_GCallback1(com_genome2d_assets_GAsset);
};
com_genome2d_assets_GAssetManager.getAssetById = function(p_id) {
	return com_genome2d_assets_GAssetManager.g2d_references.get(p_id);
};
com_genome2d_assets_GAssetManager.getXmlAssetById = function(p_id) {
	return com_genome2d_assets_GAssetManager.g2d_references.get(p_id);
};
com_genome2d_assets_GAssetManager.getImageAssetById = function(p_id) {
	return com_genome2d_assets_GAssetManager.g2d_references.get(p_id);
};
com_genome2d_assets_GAssetManager.addFromUrl = function(p_url,p_id) {
	if(p_id == null) p_id = "";
	var _g;
	com_genome2d_assets_GAssetManager.PATH_REGEX.match(p_url);
	_g = com_genome2d_assets_GAssetManager.PATH_REGEX.matched(2);
	switch(_g) {
	case "jpg":case "jpeg":case "png":case "atf":
		return new com_genome2d_assets_GImageAsset(p_url,p_id);
	case "xml":case "fnt":
		return new com_genome2d_assets_GXmlAsset(p_url,p_id);
	}
	return null;
};
com_genome2d_assets_GAssetManager.disposeAllAssets = function() {
	var $it0 = com_genome2d_assets_GAssetManager.g2d_references.iterator();
	while( $it0.hasNext() ) {
		var asset = $it0.next();
		asset.dispose();
	}
};
com_genome2d_assets_GAssetManager.loadQueue = function() {
	var $it0 = com_genome2d_assets_GAssetManager.g2d_references.iterator();
	while( $it0.hasNext() ) {
		var asset = $it0.next();
		if(!asset.isLoaded()) com_genome2d_assets_GAssetManager.g2d_loadQueue.push(asset);
	}
	if(!com_genome2d_assets_GAssetManager.g2d_loading) com_genome2d_assets_GAssetManager.g2d_loadQueueNext();
};
com_genome2d_assets_GAssetManager.g2d_loadQueueNext = function() {
	if(com_genome2d_assets_GAssetManager.g2d_loadQueue.length == 0) {
		com_genome2d_assets_GAssetManager.g2d_loading = false;
		com_genome2d_assets_GAssetManager.g2d_onQueueLoaded.dispatch();
	} else {
		com_genome2d_assets_GAssetManager.g2d_loading = true;
		var asset = com_genome2d_assets_GAssetManager.g2d_loadQueue.shift();
		asset.onLoaded.addOnce(com_genome2d_assets_GAssetManager.g2d_assetLoaded_handler);
		asset.onFailed.addOnce(com_genome2d_assets_GAssetManager.g2d_assetFailed_handler);
		asset.load();
	}
};
com_genome2d_assets_GAssetManager.getFileName = function(p_path) {
	com_genome2d_assets_GAssetManager.PATH_REGEX.match(p_path);
	return com_genome2d_assets_GAssetManager.PATH_REGEX.matched(1);
};
com_genome2d_assets_GAssetManager.getFileExtension = function(p_path) {
	com_genome2d_assets_GAssetManager.PATH_REGEX.match(p_path);
	return com_genome2d_assets_GAssetManager.PATH_REGEX.matched(2);
};
com_genome2d_assets_GAssetManager.g2d_assetLoaded_handler = function(p_asset) {
	com_genome2d_assets_GAssetManager.g2d_loadQueueNext();
};
com_genome2d_assets_GAssetManager.g2d_assetFailed_handler = function(p_asset) {
	com_genome2d_assets_GAssetManager.g2d_onQueueFailed.dispatch(p_asset);
	if(com_genome2d_assets_GAssetManager.ignoreFailed) com_genome2d_assets_GAssetManager.g2d_loadQueueNext();
};
com_genome2d_assets_GAssetManager.generateTextures = function(p_scaleFactor,p_overwrite) {
	if(p_overwrite == null) p_overwrite = false;
	if(p_scaleFactor == null) p_scaleFactor = 1;
	var $it0 = com_genome2d_assets_GAssetManager.g2d_references.iterator();
	while( $it0.hasNext() ) {
		var asset = $it0.next();
		if(!js_Boot.__instanceof(asset,com_genome2d_assets_GImageAsset) || !asset.isLoaded()) continue;
		var id = asset.g2d_id.substring(0,asset.g2d_id.lastIndexOf("."));
		var texture = com_genome2d_textures_GTextureManager.getTexture(id);
		if(texture != null) {
			if(p_overwrite) texture.dispose(); else continue;
		}
		texture = com_genome2d_textures_GTextureManager.createTexture(id,asset);
		if(com_genome2d_assets_GAssetManager.getXmlAssetById(id + ".xml") != null) com_genome2d_textures_GTextureManager.createSubTextures(texture,com_genome2d_assets_GAssetManager.getXmlAssetById(id + ".xml").xml); else if(com_genome2d_assets_GAssetManager.getXmlAssetById(id + ".fnt") != null) com_genome2d_text_GFontManager.createTextureFont(texture.g2d_id,texture,com_genome2d_assets_GAssetManager.getXmlAssetById(id + ".fnt").xml);
		texture.invalidateNativeTexture(false);
	}
};
var com_genome2d_assets_GImageAsset = function(p_url,p_id) {
	com_genome2d_assets_GAsset.call(this,p_url,p_id);
};
com_genome2d_assets_GImageAsset.__name__ = true;
com_genome2d_assets_GImageAsset.__super__ = com_genome2d_assets_GAsset;
com_genome2d_assets_GImageAsset.prototype = $extend(com_genome2d_assets_GAsset.prototype,{
	get_imageElement: function() {
		return this.g2d_imageElement;
	}
	,get_type: function() {
		return this.g2d_type;
	}
	,load: function() {
		var _this = window.document;
		this.g2d_imageElement = _this.createElement("img");
		this.g2d_imageElement.onload = $bind(this,this.loadedHandler);
		this.g2d_imageElement.src = this.g2d_url;
	}
	,loadedHandler: function(event) {
		this.g2d_type = 2;
		this.g2d_loaded = true;
		this.onLoaded.dispatch(this);
	}
	,__class__: com_genome2d_assets_GImageAsset
	,__properties__: $extend(com_genome2d_assets_GAsset.prototype.__properties__,{get_type:"get_type",get_imageElement:"get_imageElement"})
});
var com_genome2d_assets_GImageAssetType = function() { };
com_genome2d_assets_GImageAssetType.__name__ = true;
var com_genome2d_assets_GXmlAsset = function(p_url,p_id) {
	com_genome2d_assets_GAsset.call(this,p_url,p_id);
};
com_genome2d_assets_GXmlAsset.__name__ = true;
com_genome2d_assets_GXmlAsset.__super__ = com_genome2d_assets_GAsset;
com_genome2d_assets_GXmlAsset.prototype = $extend(com_genome2d_assets_GAsset.prototype,{
	load: function() {
		var http = new haxe_Http(this.g2d_url);
		http.onData = $bind(this,this.loadedHandler);
		http.onError = $bind(this,this.errorHandler);
		http.request();
	}
	,loadedHandler: function(p_data) {
		this.g2d_loaded = true;
		this.xml = Xml.parse(p_data);
		this.onLoaded.dispatch(this);
	}
	,errorHandler: function(p_error) {
		com_genome2d_debug_GDebug.error(p_error,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GXmlAsset.hx", lineNumber : 37, className : "com.genome2d.assets.GXmlAsset", methodName : "errorHandler"});
	}
	,__class__: com_genome2d_assets_GXmlAsset
});
var com_genome2d_callbacks_GCallback = function(p_valueClasses) {
	this.g2d_listenerCount = 0;
	if(p_valueClasses == null) this.g2d_valueClasses = []; else this.g2d_valueClasses = p_valueClasses;
	this.g2d_listeners = [];
	this.g2d_listenersOnce = [];
};
com_genome2d_callbacks_GCallback.__name__ = true;
com_genome2d_callbacks_GCallback.prototype = {
	hasListeners: function() {
		return this.g2d_listeners.length > 0 || this.g2d_listenersOnce.length > 0;
	}
	,add: function(p_listener) {
		if(p_listener != null && HxOverrides.indexOf(this.g2d_listeners,p_listener,0) == -1 && HxOverrides.indexOf(this.g2d_listenersOnce,p_listener,0) == -1) {
			this.g2d_listeners.push(p_listener);
			this.g2d_listenerCount++;
		}
	}
	,addOnce: function(p_listener) {
		if(p_listener != null && HxOverrides.indexOf(this.g2d_listeners,p_listener,0) == -1 && HxOverrides.indexOf(this.g2d_listenersOnce,p_listener,0) == -1) this.g2d_listenersOnce.push(p_listener);
	}
	,addWithPriority: function(p_listener) {
		if(p_listener != null && HxOverrides.indexOf(this.g2d_listeners,p_listener,0) == -1 && HxOverrides.indexOf(this.g2d_listenersOnce,p_listener,0) == -1) {
			this.g2d_listeners.unshift(p_listener);
			this.g2d_listenerCount++;
		}
	}
	,remove: function(p_listener) {
		var index = HxOverrides.indexOf(this.g2d_listeners,p_listener,0);
		if(index >= 0) {
			if(index <= this.g2d_iteratingDispatch) this.g2d_iteratingDispatch--;
			HxOverrides.remove(this.g2d_listeners,p_listener);
			this.g2d_listenerCount--;
		} else HxOverrides.remove(this.g2d_listenersOnce,p_listener);
	}
	,removeAll: function() {
		this.g2d_listeners = [];
		this.g2d_listenerCount = 0;
		this.g2d_listenersOnce = [];
	}
	,__class__: com_genome2d_callbacks_GCallback
};
var com_genome2d_callbacks_GCallback0 = function() {
	com_genome2d_callbacks_GCallback.call(this,[]);
};
com_genome2d_callbacks_GCallback0.__name__ = true;
com_genome2d_callbacks_GCallback0.__super__ = com_genome2d_callbacks_GCallback;
com_genome2d_callbacks_GCallback0.prototype = $extend(com_genome2d_callbacks_GCallback.prototype,{
	dispatch: function() {
		this.g2d_iteratingDispatch = 0;
		while(this.g2d_iteratingDispatch < this.g2d_listenerCount) {
			this.g2d_listeners[this.g2d_iteratingDispatch]();
			this.g2d_iteratingDispatch++;
		}
		var onceCount = this.g2d_listenersOnce.length;
		var _g = 0;
		while(_g < onceCount) {
			var i = _g++;
			(this.g2d_listenersOnce.shift())();
		}
	}
	,__class__: com_genome2d_callbacks_GCallback0
});
var com_genome2d_callbacks_GCallback1 = function(p_type) {
	com_genome2d_callbacks_GCallback.call(this,[p_type]);
};
com_genome2d_callbacks_GCallback1.__name__ = true;
com_genome2d_callbacks_GCallback1.__super__ = com_genome2d_callbacks_GCallback;
com_genome2d_callbacks_GCallback1.prototype = $extend(com_genome2d_callbacks_GCallback.prototype,{
	dispatch: function(p_value) {
		this.g2d_iteratingDispatch = 0;
		while(this.g2d_iteratingDispatch < this.g2d_listenerCount) {
			this.g2d_listeners[this.g2d_iteratingDispatch](p_value);
			this.g2d_iteratingDispatch++;
		}
		var onceCount = this.g2d_listenersOnce.length;
		var _g = 0;
		while(_g < onceCount) {
			var i = _g++;
			(this.g2d_listenersOnce.shift())(p_value);
		}
	}
	,__class__: com_genome2d_callbacks_GCallback1
});
var com_genome2d_callbacks_GCallback2 = function(p_type1,p_type2) {
	com_genome2d_callbacks_GCallback.call(this,[p_type1,p_type2]);
};
com_genome2d_callbacks_GCallback2.__name__ = true;
com_genome2d_callbacks_GCallback2.__super__ = com_genome2d_callbacks_GCallback;
com_genome2d_callbacks_GCallback2.prototype = $extend(com_genome2d_callbacks_GCallback.prototype,{
	dispatch: function(p_value1,p_value2) {
		this.g2d_iteratingDispatch = 0;
		while(this.g2d_iteratingDispatch < this.g2d_listenerCount) {
			this.g2d_listeners[this.g2d_iteratingDispatch](p_value1,p_value2);
			this.g2d_iteratingDispatch++;
		}
		var onceCount = this.g2d_listenersOnce.length;
		var _g = 0;
		while(_g < onceCount) {
			var i = _g++;
			(this.g2d_listeners.shift())(p_value1,p_value2);
		}
	}
	,__class__: com_genome2d_callbacks_GCallback2
});
var com_genome2d_components_GCameraController = function() {
	this.renderTarget = null;
	this.backgroundAlpha = 0;
	this.backgroundBlue = 0;
	this.backgroundGreen = 0;
	this.backgroundRed = 0;
	this.g2d_capturedThisFrame = false;
	com_genome2d_components_GComponent.call(this);
};
com_genome2d_components_GCameraController.__name__ = true;
com_genome2d_components_GCameraController.__super__ = com_genome2d_components_GComponent;
com_genome2d_components_GCameraController.prototype = $extend(com_genome2d_components_GComponent.prototype,{
	getBackgroundColor: function() {
		var alpha = (this.backgroundAlpha * 255 | 0) << 24;
		var red = (this.backgroundRed * 255 | 0) << 16;
		var green = (this.backgroundGreen * 255 | 0) << 8;
		var blue = this.backgroundBlue * 255 | 0;
		return alpha + red + green + blue;
	}
	,get_contextCamera: function() {
		return this.g2d_contextCamera;
	}
	,setView: function(p_normalizedX,p_normalizedY,p_normalizedWidth,p_normalizedHeight) {
		this.g2d_contextCamera.normalizedViewX = p_normalizedX;
		this.g2d_contextCamera.normalizedViewY = p_normalizedY;
		this.g2d_contextCamera.normalizedViewWidth = p_normalizedWidth;
		this.g2d_contextCamera.normalizedViewHeight = p_normalizedHeight;
	}
	,get_zoom: function() {
		return this.g2d_contextCamera.scaleX;
	}
	,set_zoom: function(p_value) {
		return this.g2d_contextCamera.scaleX = this.g2d_contextCamera.scaleY = p_value;
	}
	,init: function() {
		this.g2d_contextCamera = new com_genome2d_context_GCamera();
		this.g2d_viewRectangle = new com_genome2d_geom_GRectangle();
		if(this.g2d_node != ((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_root() && this.g2d_node.isOnStage()) ((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).g2d_addCameraController(this);
		this.g2d_node.get_onAddedToStage().add($bind(this,this.g2d_onAddedToStage));
		this.g2d_node.get_onRemovedFromStage().add($bind(this,this.g2d_onRemovedFromStage));
	}
	,render: function() {
		if(!this.g2d_node.g2d_active) return;
		this.g2d_renderedNodesCount = 0;
		this.g2d_contextCamera.x = this.g2d_node.g2d_worldX;
		this.g2d_contextCamera.y = this.g2d_node.g2d_worldY;
		this.g2d_contextCamera.rotation = this.g2d_node.g2d_worldRotation;
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).getContext().setActiveCamera(this.g2d_contextCamera);
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).getContext().setRenderTarget(this.renderTarget);
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_root().render(false,false,this.g2d_contextCamera,false,false);
	}
	,captureMouseInput: function(p_input) {
		if(this.g2d_capturedThisFrame || !this.g2d_node.g2d_active) return;
		this.g2d_capturedThisFrame = true;
		var stageRect = ((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).getContext().getStageViewRect();
		this.g2d_viewRectangle.setTo(stageRect.width * this.g2d_contextCamera.normalizedViewX,stageRect.height * this.g2d_contextCamera.normalizedViewY,stageRect.width * this.g2d_contextCamera.normalizedViewWidth,stageRect.height * this.g2d_contextCamera.normalizedViewHeight);
		if(!this.g2d_viewRectangle.contains(p_input.contextX,p_input.contextY)) return;
		var tx = p_input.contextX - this.g2d_viewRectangle.x - this.g2d_viewRectangle.width / 2;
		var ty = p_input.contextY - this.g2d_viewRectangle.y - this.g2d_viewRectangle.height / 2;
		var cos = Math.cos(-this.g2d_node.g2d_worldRotation);
		var sin = Math.sin(-this.g2d_node.g2d_worldRotation);
		var rx = tx * cos - ty * sin;
		var ry = ty * cos + tx * sin;
		rx /= this.g2d_contextCamera.scaleX;
		ry /= this.g2d_contextCamera.scaleX;
		p_input.worldX = rx + this.g2d_node.g2d_worldX;
		p_input.worldY = ry + this.g2d_node.g2d_worldY;
		p_input.camera = this.g2d_contextCamera;
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_root().captureMouseInput(p_input);
	}
	,dispose: function() {
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).g2d_removeCameraController(this);
		this.g2d_node.get_onAddedToStage().remove($bind(this,this.g2d_onAddedToStage));
		this.g2d_node.get_onRemovedFromStage().remove($bind(this,this.g2d_onRemovedFromStage));
		com_genome2d_components_GComponent.prototype.dispose.call(this);
	}
	,g2d_onAddedToStage: function() {
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).g2d_addCameraController(this);
	}
	,g2d_onRemovedFromStage: function() {
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).g2d_removeCameraController(this);
	}
	,setViewport: function(p_width,p_height,p_resize) {
		if(p_resize == null) p_resize = true;
		if(this.viewport != null) this.viewport.dispose();
		this.viewport = new com_genome2d_context_GViewport(this,p_width,p_height,p_resize);
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GCameraController");
		return com_genome2d_components_GComponent.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_components_GComponent.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_components_GCameraController
	,__properties__: $extend(com_genome2d_components_GComponent.prototype.__properties__,{set_zoom:"set_zoom",get_zoom:"get_zoom",get_contextCamera:"get_contextCamera"})
});
var com_genome2d_components_renderable_IGRenderable = function() { };
com_genome2d_components_renderable_IGRenderable.__name__ = true;
com_genome2d_components_renderable_IGRenderable.prototype = {
	__class__: com_genome2d_components_renderable_IGRenderable
};
var com_genome2d_components_renderable_GTexturedQuad = function() {
	this.ignoreMatrix = false;
	this.mousePixelTreshold = 0;
	this.mousePixelEnabled = false;
	this.blendMode = 1;
	com_genome2d_components_GComponent.call(this);
};
com_genome2d_components_renderable_GTexturedQuad.__name__ = true;
com_genome2d_components_renderable_GTexturedQuad.__interfaces__ = [com_genome2d_components_renderable_IGRenderable];
com_genome2d_components_renderable_GTexturedQuad.__super__ = com_genome2d_components_GComponent;
com_genome2d_components_renderable_GTexturedQuad.prototype = $extend(com_genome2d_components_GComponent.prototype,{
	render: function(p_camera,p_useMatrix) {
		if(this.texture != null) {
			if(p_useMatrix && !this.ignoreMatrix) {
				var matrix;
				matrix = ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).g2d_renderMatrix;
				((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().drawMatrix(this.texture,matrix.a,matrix.b,matrix.c,matrix.d,matrix.tx,matrix.ty,this.g2d_node.g2d_worldRed,this.g2d_node.g2d_worldGreen,this.g2d_node.g2d_worldBlue,this.g2d_node.g2d_worldAlpha,this.blendMode,this.filter);
			} else ((function($this) {
				var $r;
				if(com_genome2d_node_GNode.g2d_core == null) {
					if(com_genome2d_Genome2D.g2d_instance == null) {
						com_genome2d_Genome2D.g2d_instantiable = true;
						new com_genome2d_Genome2D();
						com_genome2d_Genome2D.g2d_instantiable = false;
					}
					com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
				}
				$r = com_genome2d_node_GNode.g2d_core;
				return $r;
			}(this))).getContext().draw(this.texture,this.g2d_node.g2d_worldX,this.g2d_node.g2d_worldY,this.g2d_node.g2d_worldScaleX,this.g2d_node.g2d_worldScaleY,this.g2d_node.g2d_worldRotation,this.g2d_node.g2d_worldRed,this.g2d_node.g2d_worldGreen,this.g2d_node.g2d_worldBlue,this.g2d_node.g2d_worldAlpha,this.blendMode,this.filter);
		}
	}
	,hitTest: function(p_x,p_y) {
		var hit = false;
		if(this.texture != null) {
			p_x = p_x / this.texture.get_width() + .5;
			p_y = p_y / this.texture.get_height() + .5;
			hit = p_x >= -this.texture.get_pivotX() / this.texture.get_width() && p_x <= 1 - this.texture.get_pivotX() / this.texture.get_width() && p_y >= -this.texture.get_pivotY() / this.texture.get_height() && p_y <= 1 - this.texture.get_pivotY() / this.texture.get_height() && (!this.mousePixelEnabled || this.texture.getAlphaAtUV(p_x + this.texture.get_pivotX() / this.texture.get_width(),p_y + this.texture.get_pivotY() / this.texture.get_height()) <= this.mousePixelTreshold);
		}
		return hit;
	}
	,captureMouseInput: function(p_input) {
		p_input.g2d_captured = p_input.g2d_captured || this.hitTest(p_input.localX,p_input.localY);
	}
	,getBounds: function(p_bounds) {
		if(this.texture == null) {
			if(p_bounds != null) p_bounds.setTo(0,0,0,0); else p_bounds = new com_genome2d_geom_GRectangle(0,0,0,0);
		} else if(p_bounds != null) p_bounds.setTo(-this.texture.get_width() * .5 - this.texture.get_pivotX(),-this.texture.get_height() * .5 - this.texture.get_pivotY(),this.texture.get_width(),this.texture.get_height()); else p_bounds = new com_genome2d_geom_GRectangle(-this.texture.get_width() * .5 - this.texture.get_pivotX(),-this.texture.get_height() * .5 - this.texture.get_pivotY(),this.texture.get_width(),this.texture.get_height());
		return p_bounds;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GTexturedQuad");
		return com_genome2d_components_GComponent.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_components_GComponent.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_components_renderable_GTexturedQuad
});
var com_genome2d_components_renderable_GSprite = function() {
	com_genome2d_components_renderable_GTexturedQuad.call(this);
};
com_genome2d_components_renderable_GSprite.__name__ = true;
com_genome2d_components_renderable_GSprite.create = function(p_node,p_texture) {
	var sprite;
	if(p_node == null) sprite = com_genome2d_node_GNode.createWithComponent(com_genome2d_components_renderable_GSprite); else sprite = p_node.addComponent(com_genome2d_components_renderable_GSprite);
	sprite.texture = p_texture;
	return sprite;
};
com_genome2d_components_renderable_GSprite.__super__ = com_genome2d_components_renderable_GTexturedQuad;
com_genome2d_components_renderable_GSprite.prototype = $extend(com_genome2d_components_renderable_GTexturedQuad.prototype,{
	init: function() {
	}
	,render: function(p_camera,p_useMatrix) {
		if(this.frameAnimation != null) {
			this.frameAnimation.update(((function($this) {
				var $r;
				if(com_genome2d_node_GNode.g2d_core == null) {
					if(com_genome2d_Genome2D.g2d_instance == null) {
						com_genome2d_Genome2D.g2d_instantiable = true;
						new com_genome2d_Genome2D();
						com_genome2d_Genome2D.g2d_instantiable = false;
					}
					com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
				}
				$r = com_genome2d_node_GNode.g2d_core;
				return $r;
			}(this))).getCurrentFrameDeltaTime());
			this.texture = this.frameAnimation.currentFrameTexture;
		}
		if(this.texture != null) {
			if(p_useMatrix && !this.ignoreMatrix) {
				var matrix;
				matrix = ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).g2d_renderMatrix;
				((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().drawMatrix(this.texture,matrix.a,matrix.b,matrix.c,matrix.d,matrix.tx,matrix.ty,this.g2d_node.g2d_worldRed,this.g2d_node.g2d_worldGreen,this.g2d_node.g2d_worldBlue,this.g2d_node.g2d_worldAlpha,this.blendMode,this.filter);
			} else ((function($this) {
				var $r;
				if(com_genome2d_node_GNode.g2d_core == null) {
					if(com_genome2d_Genome2D.g2d_instance == null) {
						com_genome2d_Genome2D.g2d_instantiable = true;
						new com_genome2d_Genome2D();
						com_genome2d_Genome2D.g2d_instantiable = false;
					}
					com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
				}
				$r = com_genome2d_node_GNode.g2d_core;
				return $r;
			}(this))).getContext().draw(this.texture,this.g2d_node.g2d_worldX,this.g2d_node.g2d_worldY,this.g2d_node.g2d_worldScaleX,this.g2d_node.g2d_worldScaleY,this.g2d_node.g2d_worldRotation,this.g2d_node.g2d_worldRed,this.g2d_node.g2d_worldGreen,this.g2d_node.g2d_worldBlue,this.g2d_node.g2d_worldAlpha,this.blendMode,this.filter);
		}
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GSprite");
		return com_genome2d_components_renderable_GTexturedQuad.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_components_renderable_GTexturedQuad.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_components_renderable_GSprite
});
var com_genome2d_components_renderable_particles_GParticleSystem = function() {
	this.g2d_accumulatedEmission = 0;
	this.g2d_accumulatedSecond = 0;
	this.g2d_accumulatedTime = 0;
	this.emissionPerDuration = true;
	this.loop = true;
	this.duration = 0;
	this.g2d_affectorsCount = 0;
	this.g2d_initializersCount = 0;
	this.emit = true;
	this.timeDilation = 1;
	this.blendMode = 1;
	com_genome2d_components_GComponent.call(this);
};
com_genome2d_components_renderable_particles_GParticleSystem.__name__ = true;
com_genome2d_components_renderable_particles_GParticleSystem.__interfaces__ = [com_genome2d_components_renderable_IGRenderable];
com_genome2d_components_renderable_particles_GParticleSystem.__super__ = com_genome2d_components_GComponent;
com_genome2d_components_renderable_particles_GParticleSystem.prototype = $extend(com_genome2d_components_GComponent.prototype,{
	addInitializer: function(p_initializer) {
		this.g2d_initializers.push(p_initializer);
		this.g2d_initializersCount++;
	}
	,addAffector: function(p_affector) {
		this.g2d_affectors.push(p_affector);
		this.g2d_affectorsCount++;
	}
	,init: function() {
		this.particlePool = com_genome2d_particles_GParticlePool.g2d_defaultPool;
		this.g2d_initializers = [];
		this.g2d_affectors = [];
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_onUpdate().add($bind(this,this.update));
	}
	,reset: function() {
		this.g2d_accumulatedTime = 0;
		this.g2d_accumulatedSecond = 0;
		this.g2d_accumulatedEmission = 0;
	}
	,burst: function(p_emission) {
		var _g = 0;
		while(_g < p_emission) {
			var i = _g++;
			this.activateParticle();
		}
	}
	,update: function(p_deltaTime) {
		p_deltaTime *= this.timeDilation;
		if(this.emit && this.emission != null) {
			var dt = p_deltaTime * .001;
			if(dt > 0) {
				this.g2d_accumulatedTime += dt;
				this.g2d_accumulatedSecond += dt;
				if(this.loop && this.duration != 0 && this.g2d_accumulatedTime > this.duration) this.g2d_accumulatedTime -= this.duration;
				if(this.duration == 0 || this.g2d_accumulatedTime < this.duration) {
					while(this.g2d_accumulatedSecond > 1) this.g2d_accumulatedSecond -= 1;
					var currentEmission;
					if(this.emissionPerDuration && this.duration != 0) currentEmission = this.emission.calculate(this.g2d_accumulatedTime / this.duration); else currentEmission = this.emission.calculate(this.g2d_accumulatedSecond);
					if(currentEmission < 0) currentEmission = 0;
					this.g2d_accumulatedEmission += currentEmission * dt;
					while(this.g2d_accumulatedEmission > 0) {
						this.activateParticle();
						this.g2d_accumulatedEmission--;
					}
				}
			}
		}
		var particle = this.g2d_firstParticle;
		while(particle != null) {
			var next = particle.g2d_next;
			var _g1 = 0;
			var _g = this.g2d_affectorsCount;
			while(_g1 < _g) {
				var i = _g1++;
				this.g2d_affectors[i].update(this,particle,p_deltaTime);
			}
			if(particle.die) this.deactivateParticle(particle);
			particle = next;
		}
	}
	,render: function(p_camera,p_useMatrix) {
		var particle = this.g2d_firstParticle;
		while(particle != null) {
			var next = particle.g2d_next;
			if(particle.overrideRender) particle.render(p_camera,this); else {
				var tx = this.g2d_node.g2d_worldX + (particle.x - this.g2d_node.g2d_worldX);
				var ty = this.g2d_node.g2d_worldY + (particle.y - this.g2d_node.g2d_worldY);
				if(particle.overrideUvs) {
				} else ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().draw(particle.texture,tx,ty,particle.scaleX * this.g2d_node.g2d_worldScaleX,particle.scaleY * this.g2d_node.g2d_worldScaleY,particle.rotation,particle.red * this.g2d_node.g2d_worldRed,particle.green * this.g2d_node.g2d_worldGreen,particle.blue * this.g2d_node.g2d_worldBlue,particle.alpha * this.g2d_node.g2d_worldAlpha,this.blendMode,null);
			}
			particle = next;
		}
	}
	,activateParticle: function() {
		var particle = this.particlePool.g2d_get();
		if(this.g2d_lastParticle != null) {
			particle.g2d_previous = this.g2d_lastParticle;
			this.g2d_lastParticle.g2d_next = particle;
			this.g2d_lastParticle = particle;
		} else {
			this.g2d_firstParticle = particle;
			this.g2d_lastParticle = particle;
		}
		particle.spawn(this);
		var _g1 = 0;
		var _g = this.g2d_initializersCount;
		while(_g1 < _g) {
			var i = _g1++;
			this.g2d_initializers[i].initialize(this,particle);
		}
	}
	,activateParticle2: function() {
		var particle = this.particlePool.g2d_get();
		if(this.g2d_firstParticle != null) {
			particle.g2d_next = this.g2d_firstParticle;
			this.g2d_firstParticle.g2d_previous = particle;
			this.g2d_firstParticle = particle;
		} else {
			this.g2d_firstParticle = particle;
			this.g2d_lastParticle = particle;
		}
		particle.spawn(this);
		var _g1 = 0;
		var _g = this.g2d_initializersCount;
		while(_g1 < _g) {
			var i = _g1++;
			this.g2d_initializers[i].initialize(this,particle);
		}
	}
	,deactivateParticle: function(p_particle) {
		if(p_particle == this.g2d_lastParticle) this.g2d_lastParticle = this.g2d_lastParticle.g2d_previous;
		if(p_particle == this.g2d_firstParticle) this.g2d_firstParticle = this.g2d_firstParticle.g2d_next;
		p_particle.dispose();
	}
	,getBounds: function(p_target) {
		return null;
	}
	,dispose: function() {
		while(this.g2d_firstParticle != null) this.deactivateParticle(this.g2d_firstParticle);
		((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_onUpdate().remove($bind(this,this.update));
		com_genome2d_components_GComponent.prototype.dispose.call(this);
	}
	,captureMouseInput: function(p_input) {
	}
	,hitTest: function(p_x,p_y) {
		return false;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GParticleSystem");
		return com_genome2d_components_GComponent.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_components_GComponent.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_components_renderable_particles_GParticleSystem
});
var com_genome2d_context_GBlendMode = function() { };
com_genome2d_context_GBlendMode.__name__ = true;
com_genome2d_context_GBlendMode.addBlendMode = function(p_normalFactors,p_premultipliedFactors) {
	com_genome2d_context_GBlendMode.blendFactors[0].push(p_normalFactors);
	com_genome2d_context_GBlendMode.blendFactors[1].push(p_premultipliedFactors);
	return com_genome2d_context_GBlendMode.blendFactors[0].length;
};
com_genome2d_context_GBlendMode.setBlendMode = function(p_context,p_mode,p_premultiplied) {
	var p;
	if(p_premultiplied) p = 1; else p = 0;
	p_context.blendFunc(com_genome2d_context_GBlendMode.blendFactors[p][p_mode][0],com_genome2d_context_GBlendMode.blendFactors[p][p_mode][1]);
};
var com_genome2d_context_GCamera = function() {
	this.normalizedViewHeight = 1;
	this.normalizedViewWidth = 1;
	this.normalizedViewY = 0;
	this.normalizedViewX = 0;
	this.mask = 16777215;
	this.y = 0;
	this.x = 0;
	this.scaleY = 1;
	this.scaleX = 1;
	this.rotation = 0;
};
com_genome2d_context_GCamera.__name__ = true;
com_genome2d_context_GCamera.prototype = {
	__class__: com_genome2d_context_GCamera
};
var com_genome2d_context_GContextConfig = function(p_viewRect) {
	this.enableStats = false;
	this.nativeStage = window.document.getElementById("canvas");
	this.viewRect = p_viewRect;
	if(this.nativeStage == null) {
		if(p_viewRect == null) com_genome2d_debug_GDebug.error("No canvas found",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GContextConfig.hx", lineNumber : 38, className : "com.genome2d.context.GContextConfig", methodName : "new"});
		var _this = window.document;
		this.nativeStage = _this.createElement("canvas");
		this.nativeStage.width = this.viewRect.width | 0;
		this.nativeStage.height = this.viewRect.height | 0;
		window.document.body.appendChild(this.nativeStage);
	} else if(this.viewRect == null) this.viewRect = new com_genome2d_geom_GRectangle(0,0,this.nativeStage.width,this.nativeStage.height);
	this.contextClass = com_genome2d_context_IGContext;
};
com_genome2d_context_GContextConfig.__name__ = true;
com_genome2d_context_GContextConfig.prototype = {
	__class__: com_genome2d_context_GContextConfig
};
var com_genome2d_context_GContextFeature = function() { };
com_genome2d_context_GContextFeature.__name__ = true;
var com_genome2d_context_GRequestAnimationFrame = function() { };
com_genome2d_context_GRequestAnimationFrame.__name__ = true;
com_genome2d_context_GRequestAnimationFrame.request = function(method) {
	var requestAnimationFrame = window.requestAnimationFrame || (window.webkitRequestAnimationFrame || (window.mozRequestAnimationFrame || (window.oRequestAnimationFrame || (window.msRequestAnimationFrame || function(method1,element) {
		window.setTimeout(method1,16.666666666666668);
	}))));
	requestAnimationFrame(method);
};
var com_genome2d_context_GViewport = function(p_cameraController,p_viewWidth,p_viewHeight,p_autoResize) {
	if(p_autoResize == null) p_autoResize = true;
	this.g2d_previousZoom = 1;
	this.g2d_hAlign = 1;
	this.g2d_vAlign = 1;
	this.g2d_cameraController = p_cameraController;
	this.viewLeft = 0;
	this.viewTop = 0;
	this.viewRight = p_viewWidth;
	this.viewBottom = p_viewHeight;
	var rect = ((function($this) {
		var $r;
		if(com_genome2d_Genome2D.g2d_instance == null) {
			com_genome2d_Genome2D.g2d_instantiable = true;
			new com_genome2d_Genome2D();
			com_genome2d_Genome2D.g2d_instantiable = false;
		}
		$r = com_genome2d_Genome2D.g2d_instance;
		return $r;
	}(this))).getContext().getStageViewRect();
	this.resize_handler(rect.width,rect.height);
	if(p_autoResize) ((function($this) {
		var $r;
		if(com_genome2d_Genome2D.g2d_instance == null) {
			com_genome2d_Genome2D.g2d_instantiable = true;
			new com_genome2d_Genome2D();
			com_genome2d_Genome2D.g2d_instantiable = false;
		}
		$r = com_genome2d_Genome2D.g2d_instance;
		return $r;
	}(this))).getContext().onResize.addWithPriority($bind(this,this.resize_handler));
};
com_genome2d_context_GViewport.__name__ = true;
com_genome2d_context_GViewport.prototype = {
	get_vAlign: function() {
		return this.g2d_vAlign;
	}
	,set_vAlign: function(p_value) {
		return this.g2d_vAlign = p_value;
	}
	,get_hAlign: function() {
		return this.g2d_hAlign;
	}
	,set_hAlign: function(p_value) {
		return this.g2d_hAlign = p_value;
	}
	,dispose: function() {
		((function($this) {
			var $r;
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			$r = com_genome2d_Genome2D.g2d_instance;
			return $r;
		}(this))).getContext().onResize.remove($bind(this,this.resize_handler));
	}
	,resize_handler: function(p_width,p_height) {
		var aw = p_width / this.viewRight;
		var ah = p_height / this.viewBottom;
		this.aspectRatio = p_width / p_height;
		this.zoom = Math.min(aw,ah);
		this.g2d_cameraController.set_zoom(this.zoom);
		if(aw < ah) {
			this.screenLeft = 0;
			this.screenRight = this.viewRight;
			var _g = this.g2d_vAlign;
			switch(_g) {
			case 1:
				this.screenTop = (this.viewBottom * this.zoom - p_height) / (2 * this.zoom);
				this.screenBottom = this.viewBottom + (p_height - this.zoom * this.viewBottom) / (2 * this.zoom);
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5,this.viewBottom * .5);
				break;
			case 0:
				this.screenTop = 0;
				this.screenBottom = this.viewBottom + (p_height - this.zoom * this.viewBottom) / this.zoom;
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5,this.viewBottom * .5 + (p_height - this.zoom * this.viewBottom) / (2 * this.zoom));
				break;
			case 2:
				this.screenTop = (this.viewBottom * this.zoom - p_height) / this.zoom;
				this.screenBottom = p_height;
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5,this.viewBottom * .5 - (p_height - this.zoom * this.viewBottom) / (2 * this.zoom));
				break;
			}
		} else {
			var _g1 = this.g2d_hAlign;
			switch(_g1) {
			case 1:
				this.screenLeft = (this.zoom * this.viewRight - p_width) / (2 * this.zoom);
				this.screenRight = this.viewRight + (p_width - this.zoom * this.viewRight) / (2 * this.zoom);
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5,this.viewBottom * .5);
				break;
			case 0:
				this.screenLeft = 0;
				this.screenRight = this.viewRight + (p_width - this.zoom * this.viewRight) / this.zoom;
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5 + (p_width - this.zoom * this.viewRight) / (2 * this.zoom),this.viewBottom * .5);
				break;
			case 2:
				this.screenLeft = (this.zoom * this.viewRight - p_width) / this.zoom;
				this.screenRight = p_width;
				this.g2d_cameraController.g2d_node.setPosition(this.viewRight * .5 - (p_width - this.zoom * this.viewRight) / (2 * this.zoom),this.viewBottom * .5);
				break;
			}
			this.screenTop = 0;
			this.screenBottom = this.viewBottom;
		}
	}
	,__class__: com_genome2d_context_GViewport
	,__properties__: {set_hAlign:"set_hAlign",get_hAlign:"get_hAlign",set_vAlign:"set_vAlign",get_vAlign:"get_vAlign"}
};
var com_genome2d_context_IGRenderer = function() { };
com_genome2d_context_IGRenderer.__name__ = true;
com_genome2d_context_IGRenderer.prototype = {
	__class__: com_genome2d_context_IGRenderer
};
var com_genome2d_context_filters_GFilter = function() {
	this.fragmentCode = "";
	this.overrideFragmentShader = false;
	this.g2d_id = Std.string(js_Boot.getClass(this));
};
com_genome2d_context_filters_GFilter.__name__ = true;
com_genome2d_context_filters_GFilter.prototype = {
	__class__: com_genome2d_context_filters_GFilter
};
var com_genome2d_context_stats_IGStats = function() { };
com_genome2d_context_stats_IGStats.__name__ = true;
com_genome2d_context_stats_IGStats.prototype = {
	__class__: com_genome2d_context_stats_IGStats
};
var com_genome2d_context_stats_GStats = function(p_canvas) {
	this.g2d_previousTime = 0;
	this.g2d_frames = 0;
	this.g2d_previousTime = new Date().getTime();
	com_genome2d_context_stats_GStats.fps = 0;
	var _this = window.document;
	this.g2d_container = _this.createElement("div");
	this.g2d_container.id = "stats";
	this.g2d_container.style.cssText = "width:" + p_canvas.clientWidth + "px;opacity:0.9;cursor:pointer";
	this.g2d_container.style.position = "absolute";
	this.g2d_container.style.left = p_canvas.offsetLeft + "px";
	this.g2d_container.style.top = p_canvas.offsetTop + "px";
	var _this1 = window.document;
	this.g2d_fpsDiv = _this1.createElement("div");
	this.g2d_fpsDiv.id = "fps";
	this.g2d_fpsDiv.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#002";
	this.g2d_container.appendChild(this.g2d_fpsDiv);
	var _this2 = window.document;
	this.g2d_fpsText = _this2.createElement("div");
	this.g2d_fpsText.id = "fpsText";
	this.g2d_fpsText.style.cssText = "color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:10px;font-weight:bold;line-height:15px";
	this.g2d_fpsText.innerHTML = "FPS";
	this.g2d_fpsDiv.appendChild(this.g2d_fpsText);
	p_canvas.parentElement.appendChild(this.g2d_container);
};
com_genome2d_context_stats_GStats.__name__ = true;
com_genome2d_context_stats_GStats.__interfaces__ = [com_genome2d_context_stats_IGStats];
com_genome2d_context_stats_GStats.prototype = {
	render: function(p_context) {
		if(com_genome2d_context_stats_GStats.visible) {
			if(this.g2d_fpsDiv.parentElement == null) this.g2d_container.appendChild(this.g2d_fpsDiv);
			var time = new Date().getTime();
			this.g2d_frames++;
			if(time > this.g2d_previousTime + 1000) {
				com_genome2d_context_stats_GStats.fps = Math.round(this.g2d_frames * 1000 / (time - this.g2d_previousTime));
				this.g2d_fpsText.textContent = "FPS: " + com_genome2d_context_stats_GStats.fps + " Drawcalls: " + com_genome2d_context_stats_GStats.drawCalls;
				if(com_genome2d_context_stats_GStats.customStats != null) {
					this.g2d_fpsText.textContent += " ";
					var _g = 0;
					var _g1 = com_genome2d_context_stats_GStats.customStats;
					while(_g < _g1.length) {
						var stat = _g1[_g];
						++_g;
						this.g2d_fpsText.textContent += stat;
					}
				}
				this.g2d_previousTime = time;
				this.g2d_frames = 0;
			}
		} else if(this.g2d_fpsDiv.parentElement != null) this.g2d_container.removeChild(this.g2d_fpsDiv);
	}
	,clear: function() {
		com_genome2d_context_stats_GStats.drawCalls = 0;
	}
	,__class__: com_genome2d_context_stats_GStats
};
var com_genome2d_input_IGInteractive = function() { };
com_genome2d_input_IGInteractive.__name__ = true;
var com_genome2d_context_IGContext = function(p_config) {
	this.g2d_backgroundAlpha = 1;
	this.g2d_backgroundBlue = 0;
	this.g2d_backgroundGreen = 0;
	this.g2d_backgroundRed = 0;
	this.g2d_reinitialize = 0;
	this.g2d_nativeStage = p_config.nativeStage;
	this.g2d_stageViewRect = p_config.viewRect;
	this.g2d_stats = new com_genome2d_context_stats_GStats(this.g2d_nativeStage);
	this.onInitialized = new com_genome2d_callbacks_GCallback0();
	this.onFailed = new com_genome2d_callbacks_GCallback1();
	this.onInvalidated = new com_genome2d_callbacks_GCallback0();
	this.onResize = new com_genome2d_callbacks_GCallback2();
	this.onFrame = new com_genome2d_callbacks_GCallback1();
	this.onMouseInput = new com_genome2d_callbacks_GCallback1();
	this.onKeyboardInput = new com_genome2d_callbacks_GCallback1();
};
com_genome2d_context_IGContext.__name__ = true;
com_genome2d_context_IGContext.__interfaces__ = [com_genome2d_input_IGInteractive];
com_genome2d_context_IGContext.prototype = {
	hasFeature: function(p_feature) {
		switch(p_feature) {
		case 2:
			return true;
		}
		return false;
	}
	,getNativeStage: function() {
		return this.g2d_nativeStage;
	}
	,getNativeContext: function() {
		return this.g2d_nativeContext;
	}
	,setBackgroundColor: function(p_color,p_alpha) {
		if(p_alpha == null) p_alpha = 1;
		this.g2d_backgroundRed = (p_color >> 16 & 255 | 0) / 255;
		this.g2d_backgroundGreen = (p_color >> 8 & 255 | 0) / 255;
		this.g2d_backgroundBlue = (p_color & 255 | 0) / 255;
		this.g2d_backgroundAlpha = p_alpha;
	}
	,getActiveCamera: function() {
		return this.g2d_activeCamera;
	}
	,getDefaultCamera: function() {
		return this.g2d_defaultCamera;
	}
	,getStageViewRect: function() {
		return this.g2d_stageViewRect;
	}
	,init: function() {
		try {
			this.g2d_nativeContext = this.g2d_nativeStage.getContext("webgl");
			if(this.g2d_nativeContext == null) this.g2d_nativeContext = this.g2d_nativeStage.getContext("experimental-webgl");
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
		}
		if(this.g2d_nativeContext == null) {
			this.onFailed.dispatch("No WebGL support detected.");
			return;
		}
		com_genome2d_context_webgl_renderers_GRendererCommon.init();
		this.g2d_drawRenderer = new com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer();
		this.g2d_defaultCamera = new com_genome2d_context_GCamera();
		this.g2d_defaultCamera.x = this.g2d_stageViewRect.width / 2;
		this.g2d_defaultCamera.y = this.g2d_stageViewRect.height / 2;
		this.g2d_activeViewRect = new com_genome2d_geom_GRectangle();
		this.g2d_currentTime = new Date().getTime();
		this.g2d_nativeStage.addEventListener("mousedown",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("mouseup",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("mousemove",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("touchstart",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("touchend",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("touchmove",$bind(this,this.g2d_mouseEventHandler));
		this.g2d_nativeStage.addEventListener("touchcancel",$bind(this,this.g2d_mouseEventHandler));
		window.addEventListener("keyup",$bind(this,this.g2d_keyboardEventHandler));
		window.addEventListener("keydown",$bind(this,this.g2d_keyboardEventHandler));
		this.g2d_nativeContext.pixelStorei(37441,1);
		this.onInitialized.dispatch();
		com_genome2d_context_GRequestAnimationFrame.request($bind(this,this.g2d_enterFrameHandler));
	}
	,resize: function(p_rect) {
		this.g2d_stageViewRect = p_rect;
		this.g2d_defaultCamera.x = this.g2d_stageViewRect.width / 2;
		this.g2d_defaultCamera.y = this.g2d_stageViewRect.height / 2;
	}
	,setActiveCamera: function(p_camera) {
		this.g2d_projectionMatrix = new Float32Array([2.0 / this.g2d_stageViewRect.width,0.0,0.0,-1.0,0.0,-2. / this.g2d_stageViewRect.height,0.0,1.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,1.0]);
	}
	,getMaskRect: function() {
		return null;
	}
	,setMaskRect: function(p_maskRect) {
	}
	,begin: function() {
		this.g2d_stats.clear();
		this.g2d_activeRenderer = null;
		this.g2d_activePremultiply = true;
		this.g2d_activeBlendMode = 1;
		this.setActiveCamera(this.g2d_defaultCamera);
		this.g2d_nativeContext.viewport(0,0,this.g2d_stageViewRect.width | 0,this.g2d_stageViewRect.height | 0);
		this.g2d_nativeContext.clearColor(this.g2d_backgroundRed,this.g2d_backgroundGreen,this.g2d_backgroundBlue,this.g2d_backgroundAlpha);
		this.g2d_nativeContext.clear(16640);
		this.g2d_nativeContext.disable(2929);
		this.g2d_nativeContext.enable(3042);
		com_genome2d_context_GBlendMode.setBlendMode(this.g2d_nativeContext,1,true);
		return true;
	}
	,draw: function(p_texture,p_x,p_y,p_scaleX,p_scaleY,p_rotation,p_red,p_green,p_blue,p_alpha,p_blendMode,p_filter) {
		if(p_blendMode == null) p_blendMode = 1;
		if(p_alpha == null) p_alpha = 1;
		if(p_blue == null) p_blue = 1;
		if(p_green == null) p_green = 1;
		if(p_red == null) p_red = 1;
		if(p_rotation == null) p_rotation = 0;
		if(p_scaleY == null) p_scaleY = 1;
		if(p_scaleX == null) p_scaleX = 1;
		this.setBlendMode(p_blendMode,p_texture.premultiplied);
		this.setRenderer(this.g2d_drawRenderer);
		this.g2d_drawRenderer.draw(p_x,p_y,p_scaleX,p_scaleY,p_rotation,p_red,p_green,p_blue,p_alpha,p_texture);
	}
	,drawMatrix: function(p_texture,p_a,p_b,p_c,p_d,p_tx,p_ty,p_red,p_green,p_blue,p_alpha,p_blendMode,p_filter) {
		if(p_blendMode == null) p_blendMode = 1;
		if(p_alpha == null) p_alpha = 1;
		if(p_blue == null) p_blue = 1;
		if(p_green == null) p_green = 1;
		if(p_red == null) p_red = 1;
	}
	,drawSource: function(p_texture,p_sourceX,p_sourceY,p_sourceWidth,p_sourceHeight,p_sourcePivotX,p_sourcePivotY,p_x,p_y,p_scaleX,p_scaleY,p_rotation,p_red,p_green,p_blue,p_alpha,p_blendMode,p_filter) {
		if(p_blendMode == null) p_blendMode = 1;
		if(p_alpha == null) p_alpha = 1;
		if(p_blue == null) p_blue = 1;
		if(p_green == null) p_green = 1;
		if(p_red == null) p_red = 1;
		if(p_rotation == null) p_rotation = 0;
		if(p_scaleY == null) p_scaleY = 1;
		if(p_scaleX == null) p_scaleX = 1;
	}
	,drawPoly: function(p_texture,p_vertices,p_uvs,p_x,p_y,p_scaleX,p_scaleY,p_rotation,p_red,p_green,p_blue,p_alpha,p_blendMode,p_filter) {
		if(p_blendMode == null) p_blendMode = 1;
		if(p_alpha == null) p_alpha = 1;
		if(p_blue == null) p_blue = 1;
		if(p_green == null) p_green = 1;
		if(p_red == null) p_red = 1;
		if(p_rotation == null) p_rotation = 0;
		if(p_scaleY == null) p_scaleY = 1;
		if(p_scaleX == null) p_scaleX = 1;
	}
	,end: function() {
		this.flushRenderer();
	}
	,setRenderer: function(p_renderer) {
		if(p_renderer != this.g2d_activeRenderer || this.g2d_activeRenderer == null) {
			this.flushRenderer();
			this.g2d_activeRenderer = p_renderer;
			this.g2d_activeRenderer.bind(this,this.g2d_reinitialize);
		}
	}
	,getRenderer: function() {
		return this.g2d_activeRenderer;
	}
	,flushRenderer: function() {
		if(this.g2d_activeRenderer != null) {
			this.g2d_activeRenderer.push();
			this.g2d_activeRenderer.clear();
		}
	}
	,clearStencil: function() {
	}
	,renderToStencil: function(p_stencilLayer) {
	}
	,renderToColor: function(p_stencilLayer) {
	}
	,getRenderTargetMatrix: function() {
		return null;
	}
	,getRenderTarget: function() {
		return null;
	}
	,setRenderTarget: function(p_texture,p_transform,p_clear) {
		if(p_clear == null) p_clear = false;
	}
	,g2d_enterFrameHandler: function() {
		var currentTime = new Date().getTime();
		this.g2d_currentDeltaTime = currentTime - this.g2d_currentTime;
		this.g2d_currentTime = currentTime;
		this.g2d_stats.render(this);
		this.onFrame.dispatch(this.g2d_currentDeltaTime);
		com_genome2d_context_GRequestAnimationFrame.request($bind(this,this.g2d_enterFrameHandler));
	}
	,g2d_mouseEventHandler: function(event) {
		var captured = false;
		event.preventDefault();
		event.stopPropagation();
		var mx;
		var my;
		if(js_Boot.__instanceof(event,MouseEvent)) {
			var me = event;
			mx = me.pageX - this.g2d_nativeStage.offsetLeft;
			my = me.pageY - this.g2d_nativeStage.offsetTop;
		} else {
			var te = event;
			mx = te.targetTouches[0].pageX;
			my = te.targetTouches[0].pageY;
		}
		var input = new com_genome2d_input_GMouseInput(this,this,com_genome2d_input_GMouseInputType.fromNative(event.type),mx,my);
		input.worldX = input.contextX = mx;
		input.worldY = input.contextY = my;
		input.buttonDown = false;
		input.ctrlKey = false;
		input.altKey = false;
		input.shiftKey = false;
		input.delta = 0;
		input.nativeCaptured = captured;
		this.onMouseInput.dispatch(input);
		this.g2d_onMouseInputInternal(input);
	}
	,g2d_keyboardEventHandler: function(event) {
		event.preventDefault();
		event.stopPropagation();
		var keyEvent = event;
		var input = new com_genome2d_input_GKeyboardInput(com_genome2d_input_GKeyboardInputType.fromNative(event.type),keyEvent.keyCode,keyEvent.charCode);
		this.onKeyboardInput.dispatch(input);
	}
	,dispose: function() {
		this.g2d_onMouseInputInternal = null;
	}
	,setDepthTest: function(p_depthMask,p_compareMode) {
	}
	,setRenderTargets: function(p_textures,p_transform,p_clear) {
		if(p_clear == null) p_clear = false;
	}
	,setBlendMode: function(p_blendMode,p_premultiplied) {
		if(p_blendMode != this.g2d_activeBlendMode || p_premultiplied != this.g2d_activePremultiply) {
			if(this.g2d_activeRenderer != null) this.g2d_activeRenderer.push();
			this.g2d_activeBlendMode = p_blendMode;
			this.g2d_activePremultiply = p_premultiplied;
			com_genome2d_context_GBlendMode.setBlendMode(this.g2d_nativeContext,this.g2d_activeBlendMode,this.g2d_activePremultiply);
		}
	}
	,__class__: com_genome2d_context_IGContext
};
var com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer = function() {
	this.g2d_initialized = -1;
	this.g2d_useSeparatedAlphaPipeline = false;
	this.g2d_activeAlpha = false;
	this.g2d_quadCount = 0;
};
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.__name__ = true;
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.__interfaces__ = [com_genome2d_context_IGRenderer];
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.prototype = {
	getShader: function(shaderSrc,shaderType) {
		var shader = this.g2d_nativeContext.createShader(shaderType);
		this.g2d_nativeContext.shaderSource(shader,shaderSrc);
		this.g2d_nativeContext.compileShader(shader);
		if(!this.g2d_nativeContext.getShaderParameter(shader,35713)) {
			com_genome2d_debug_GDebug.error("Shader compilation error: " + this.g2d_nativeContext.getShaderInfoLog(shader),null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GQuadTextureShaderRenderer.hx", lineNumber : 152, className : "com.genome2d.context.webgl.renderers.GQuadTextureShaderRenderer", methodName : "getShader"});
			return null;
		}
		return shader;
	}
	,initialize: function(p_context) {
		this.g2d_context = p_context;
		this.g2d_nativeContext = this.g2d_context.g2d_nativeContext;
		var fragmentShader = this.getShader("\r\n\t\t\t//#ifdef GL_ES\r\n\t\t\tprecision lowp float;\r\n\t\t\t//#endif\r\n\r\n\t\t\tvarying vec2 vTexCoord;\r\n\t\t\tvarying vec4 vColor;\r\n\r\n\t\t\tuniform sampler2D sTexture;\r\n\r\n\t\t\tvoid main(void)\r\n\t\t\t{\r\n\t\t\t\tgl_FragColor = texture2D(sTexture, vTexCoord) * vColor;\r\n\t\t\t}\r\n\t\t",35632);
		var vertexShader = this.getShader("\r\n\t\t\tuniform mat4 projectionMatrix;\r\n\t\t\tuniform vec4 transforms[" + 120 + "];\r\n\r\n\t\t\tattribute vec2 aPosition;\r\n\t\t\tattribute vec2 aTexCoord;\r\n\t\t\tattribute vec4 aConstantIndex;\r\n\r\n\t\t\tvarying vec2 vTexCoord;\r\n\t\t\tvarying vec4 vColor;\r\n\r\n\t\t\tvoid main(void)\r\n\t\t\t{\r\n\t\t\t\tgl_Position = vec4(aPosition.x*transforms[int(aConstantIndex.z)].x, aPosition.y*transforms[int(aConstantIndex.z)].y, 0, 1);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x - transforms[int(aConstantIndex.z)].z, gl_Position.y - transforms[int(aConstantIndex.z)].w, 0, 1);\r\n\t\t\t\tfloat c = cos(transforms[int(aConstantIndex.x)].z);\r\n\t\t\t\tfloat s = sin(transforms[int(aConstantIndex.x)].z);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x * c - gl_Position.y * s, gl_Position.x * s + gl_Position.y * c, 0, 1);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x+transforms[int(aConstantIndex.x)].x, gl_Position.y+transforms[int(aConstantIndex.x)].y, 0, 1);\r\n\t\t\t\tgl_Position = gl_Position * projectionMatrix;\r\n\r\n\t\t\t\tvTexCoord = vec2(aTexCoord.x*transforms[int(aConstantIndex.y)].z+transforms[int(aConstantIndex.y)].x, aTexCoord.y*transforms[int(aConstantIndex.y)].w+transforms[int(aConstantIndex.y)].y);\r\n\t\t\t\tvColor = transforms[int(aConstantIndex.w)];\r\n\t\t\t}\r\n\t\t ",35633);
		this.g2d_program = this.g2d_nativeContext.createProgram();
		this.g2d_nativeContext.attachShader(this.g2d_program,vertexShader);
		this.g2d_nativeContext.attachShader(this.g2d_program,fragmentShader);
		this.g2d_nativeContext.linkProgram(this.g2d_program);
		this.g2d_nativeContext.useProgram(this.g2d_program);
		var vertices = new Float32Array(240);
		var uvs = new Float32Array(240);
		var registerIndices = new Float32Array(360);
		var registerIndicesAlpha = new Float32Array(480);
		var _g = 0;
		while(_g < 30) {
			var i = _g++;
			vertices[i * 8] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[0];
			vertices[i * 8 + 1] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[1];
			vertices[i * 8 + 2] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[2];
			vertices[i * 8 + 3] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[3];
			vertices[i * 8 + 4] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[4];
			vertices[i * 8 + 5] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[5];
			vertices[i * 8 + 6] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[6];
			vertices[i * 8 + 7] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES[7];
			uvs[i * 8] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[0];
			uvs[i * 8 + 1] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[1];
			uvs[i * 8 + 2] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[2];
			uvs[i * 8 + 3] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[3];
			uvs[i * 8 + 4] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[4];
			uvs[i * 8 + 5] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[5];
			uvs[i * 8 + 6] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[6];
			uvs[i * 8 + 7] = com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS[7];
			var index = i * 3;
			registerIndices[index * 4] = index;
			registerIndices[index * 4 + 1] = index + 1;
			registerIndices[index * 4 + 2] = index + 2;
			registerIndices[index * 4 + 3] = index;
			registerIndices[index * 4 + 4] = index + 1;
			registerIndices[index * 4 + 5] = index + 2;
			registerIndices[index * 4 + 6] = index;
			registerIndices[index * 4 + 7] = index + 1;
			registerIndices[index * 4 + 8] = index + 2;
			registerIndices[index * 4 + 9] = index;
			registerIndices[index * 4 + 10] = index + 1;
			registerIndices[index * 4 + 11] = index + 2;
			var index1 = i * 4;
			registerIndicesAlpha[index1 * 4] = index1;
			registerIndicesAlpha[index1 * 4 + 1] = index1 + 1;
			registerIndicesAlpha[index1 * 4 + 2] = index1 + 2;
			registerIndicesAlpha[index1 * 4 + 3] = index1 + 3;
			registerIndicesAlpha[index1 * 4 + 4] = index1;
			registerIndicesAlpha[index1 * 4 + 5] = index1 + 1;
			registerIndicesAlpha[index1 * 4 + 6] = index1 + 2;
			registerIndicesAlpha[index1 * 4 + 7] = index1 + 3;
			registerIndicesAlpha[index1 * 4 + 8] = index1;
			registerIndicesAlpha[index1 * 4 + 9] = index1 + 1;
			registerIndicesAlpha[index1 * 4 + 10] = index1 + 2;
			registerIndicesAlpha[index1 * 4 + 11] = index1 + 3;
			registerIndicesAlpha[index1 * 4 + 12] = index1;
			registerIndicesAlpha[index1 * 4 + 13] = index1 + 1;
			registerIndicesAlpha[index1 * 4 + 14] = index1 + 2;
			registerIndicesAlpha[index1 * 4 + 15] = index1 + 3;
		}
		this.g2d_geometryBuffer = this.g2d_nativeContext.createBuffer();
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_geometryBuffer);
		this.g2d_nativeContext.bufferData(34962,vertices,35040);
		this.g2d_uvBuffer = this.g2d_nativeContext.createBuffer();
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_uvBuffer);
		this.g2d_nativeContext.bufferData(34962,uvs,35040);
		this.g2d_constantIndexBuffer = this.g2d_nativeContext.createBuffer();
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_constantIndexBuffer);
		this.g2d_nativeContext.bufferData(34962,registerIndices,35040);
		this.g2d_constantIndexAlphaBuffer = this.g2d_nativeContext.createBuffer();
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_constantIndexAlphaBuffer);
		this.g2d_nativeContext.bufferData(34962,registerIndicesAlpha,35040);
		var indices = new Uint16Array(180);
		var _g1 = 0;
		while(_g1 < 30) {
			var i1 = _g1++;
			var ao = i1 * 6;
			var io = i1 * 4;
			indices[ao] = io;
			indices[ao + 1] = io + 1;
			indices[ao + 2] = io + 2;
			indices[ao + 3] = io;
			indices[ao + 4] = io + 2;
			indices[ao + 5] = io + 3;
		}
		this.g2d_indexBuffer = this.g2d_nativeContext.createBuffer();
		this.g2d_nativeContext.bindBuffer(34963,this.g2d_indexBuffer);
		this.g2d_nativeContext.bufferData(34963,indices,35044);
		this.g2d_program.samplerUniform = this.g2d_nativeContext.getUniformLocation(this.g2d_program,"sTexture");
		this.g2d_program.positionAttribute = this.g2d_nativeContext.getAttribLocation(this.g2d_program,"aPosition");
		this.g2d_nativeContext.enableVertexAttribArray(this.g2d_program.positionAttribute);
		this.g2d_program.texCoordAttribute = this.g2d_nativeContext.getAttribLocation(this.g2d_program,"aTexCoord");
		this.g2d_nativeContext.enableVertexAttribArray(this.g2d_program.texCoordAttribute);
		this.g2d_program.constantIndexAttribute = this.g2d_nativeContext.getAttribLocation(this.g2d_program,"aConstantIndex");
		this.g2d_nativeContext.enableVertexAttribArray(this.g2d_program.constantIndexAttribute);
		this.g2d_transforms = new Float32Array(480);
	}
	,bind: function(p_context,p_reinitialize) {
		if(p_reinitialize != this.g2d_initialized) this.initialize(p_context);
		this.g2d_initialized = p_reinitialize;
		this.g2d_nativeContext.uniformMatrix4fv(this.g2d_nativeContext.getUniformLocation(this.g2d_program,"projectionMatrix"),false,this.g2d_context.g2d_projectionMatrix);
		this.g2d_nativeContext.bindBuffer(34963,this.g2d_indexBuffer);
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_geometryBuffer);
		this.g2d_nativeContext.vertexAttribPointer(this.g2d_program.positionAttribute,2,5126,false,0,0);
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_uvBuffer);
		this.g2d_nativeContext.vertexAttribPointer(this.g2d_program.texCoordAttribute,2,5126,false,0,0);
		this.g2d_nativeContext.bindBuffer(34962,this.g2d_constantIndexAlphaBuffer);
		this.g2d_nativeContext.vertexAttribPointer(this.g2d_program.constantIndexAttribute,4,5126,false,0,0);
	}
	,draw: function(p_x,p_y,p_scaleX,p_scaleY,p_rotation,p_red,p_green,p_blue,p_alpha,p_texture) {
		var notSameTexture = this.g2d_activeNativeTexture != p_texture.g2d_nativeTexture;
		var useAlpha = !this.g2d_useSeparatedAlphaPipeline && !(p_red == 1 && p_green == 1 && p_blue == 1 && p_alpha == 1);
		var notSameUseAlpha = this.g2d_activeAlpha != useAlpha;
		this.g2d_activeAlpha = useAlpha;
		if(notSameTexture) {
			if(this.g2d_activeNativeTexture != null) {
				if(this.g2d_quadCount > 0) {
					com_genome2d_context_stats_GStats.drawCalls++;
					this.g2d_nativeContext.uniform4fv(this.g2d_nativeContext.getUniformLocation(this.g2d_program,"transforms"),this.g2d_transforms);
					this.g2d_nativeContext.drawElements(4,6 * this.g2d_quadCount,5123,0);
					this.g2d_quadCount = 0;
				}
			}
			if(notSameTexture) {
				this.g2d_activeNativeTexture = p_texture.g2d_nativeTexture;
				this.g2d_nativeContext.activeTexture(33984);
				this.g2d_nativeContext.bindTexture(3553,p_texture.g2d_nativeTexture);
				this.g2d_nativeContext.uniform1i(this.g2d_program.samplerUniform,0);
			}
		}
		if(this.g2d_activeAlpha) {
			p_red *= p_alpha;
			p_green *= p_alpha;
			p_blue *= p_alpha;
		}
		var offset = this.g2d_quadCount * 4 << 2;
		this.g2d_transforms[offset] = p_x;
		this.g2d_transforms[offset + 1] = p_y;
		this.g2d_transforms[offset + 2] = p_rotation;
		this.g2d_transforms[offset + 3] = 0;
		this.g2d_transforms[offset + 4] = p_texture.g2d_u;
		this.g2d_transforms[offset + 5] = p_texture.g2d_v;
		this.g2d_transforms[offset + 6] = p_texture.g2d_uScale;
		this.g2d_transforms[offset + 7] = p_texture.g2d_vScale;
		this.g2d_transforms[offset + 8] = p_scaleX * (p_texture.g2d_nativeWidth * p_texture.g2d_scaleFactor);
		this.g2d_transforms[offset + 9] = p_scaleY * (p_texture.g2d_nativeHeight * p_texture.g2d_scaleFactor);
		this.g2d_transforms[offset + 10] = p_scaleX * (p_texture.g2d_pivotX * p_texture.g2d_scaleFactor);
		this.g2d_transforms[offset + 11] = p_scaleY * (p_texture.g2d_pivotY * p_texture.g2d_scaleFactor);
		this.g2d_transforms[offset + 12] = p_red;
		this.g2d_transforms[offset + 13] = p_green;
		this.g2d_transforms[offset + 14] = p_blue;
		this.g2d_transforms[offset + 15] = p_alpha;
		this.g2d_quadCount++;
		if(this.g2d_quadCount == 30) {
			if(this.g2d_quadCount > 0) {
				com_genome2d_context_stats_GStats.drawCalls++;
				this.g2d_nativeContext.uniform4fv(this.g2d_nativeContext.getUniformLocation(this.g2d_program,"transforms"),this.g2d_transforms);
				this.g2d_nativeContext.drawElements(4,6 * this.g2d_quadCount,5123,0);
				this.g2d_quadCount = 0;
			}
		}
	}
	,push: function() {
		if(this.g2d_quadCount > 0) {
			com_genome2d_context_stats_GStats.drawCalls++;
			this.g2d_nativeContext.uniform4fv(this.g2d_nativeContext.getUniformLocation(this.g2d_program,"transforms"),this.g2d_transforms);
			this.g2d_nativeContext.drawElements(4,6 * this.g2d_quadCount,5123,0);
			this.g2d_quadCount = 0;
		}
	}
	,clear: function() {
		this.g2d_activeNativeTexture = null;
	}
	,__class__: com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer
};
var com_genome2d_context_webgl_renderers_GRendererCommon = function() { };
com_genome2d_context_webgl_renderers_GRendererCommon.__name__ = true;
com_genome2d_context_webgl_renderers_GRendererCommon.init = function() {
	com_genome2d_context_webgl_renderers_GRendererCommon.DEFAULT_CONSTANTS = [1,0,0,.5];
	com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_VERTICES = [-.5,.5,-.5,-.5,.5,-.5,.5,.5];
	com_genome2d_context_webgl_renderers_GRendererCommon.NORMALIZED_UVS = [.0,1.0,.0,.0,1.0,.0,1.0,1.0];
};
var com_genome2d_debug_GDebug = function() { };
com_genome2d_debug_GDebug.__name__ = true;
com_genome2d_debug_GDebug.__properties__ = {get_onDebug:"get_onDebug"}
com_genome2d_debug_GDebug.get_onDebug = function() {
	if(com_genome2d_debug_GDebug.g2d_onDebug == null) com_genome2d_debug_GDebug.g2d_onDebug = new com_genome2d_callbacks_GCallback1(String);
	return com_genome2d_debug_GDebug.g2d_onDebug;
};
com_genome2d_debug_GDebug.debug = function(p_priority,p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20,pos) {
	if(com_genome2d_debug_GDebug.showPriority <= p_priority) com_genome2d_debug_GDebug.g2d_internal(p_priority,pos,p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20);
};
com_genome2d_debug_GDebug.dump = function(p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20,pos) {
};
com_genome2d_debug_GDebug.dump_args = function(p_args,pos) {
	if(com_genome2d_debug_GDebug.showPriority <= 2) com_genome2d_debug_GDebug.g2d_internal_args(2,pos,p_args);
};
com_genome2d_debug_GDebug.info = function(p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20,pos) {
};
com_genome2d_debug_GDebug.warning = function(p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20,pos) {
	if(com_genome2d_debug_GDebug.showPriority <= 4) com_genome2d_debug_GDebug.g2d_internal(4,pos,p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20);
};
com_genome2d_debug_GDebug.warning_handler = function(p_arg) {
	com_genome2d_debug_GDebug.g2d_internal(4,null,p_arg,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
};
com_genome2d_debug_GDebug.error = function(p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20,pos) {
	com_genome2d_debug_GDebug.g2d_internal(5,pos,p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20);
};
com_genome2d_debug_GDebug.error_handler = function(p_arg) {
	com_genome2d_debug_GDebug.g2d_internal(5,null,p_arg,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
};
com_genome2d_debug_GDebug.g2d_internal = function(p_priority,p_pos,p_arg1,p_arg2,p_arg3,p_arg4,p_arg5,p_arg6,p_arg7,p_arg8,p_arg9,p_arg10,p_arg11,p_arg12,p_arg13,p_arg14,p_arg15,p_arg16,p_arg17,p_arg18,p_arg19,p_arg20) {
	var args = [];
	if(p_arg1 != null) args.push(p_arg1);
	if(p_arg2 != null) args.push(p_arg2);
	if(p_arg3 != null) args.push(p_arg3);
	if(p_arg4 != null) args.push(p_arg4);
	if(p_arg5 != null) args.push(p_arg5);
	if(p_arg6 != null) args.push(p_arg6);
	if(p_arg7 != null) args.push(p_arg7);
	if(p_arg8 != null) args.push(p_arg8);
	if(p_arg9 != null) args.push(p_arg9);
	if(p_arg10 != null) args.push(p_arg10);
	if(p_arg11 != null) args.push(p_arg11);
	if(p_arg12 != null) args.push(p_arg12);
	if(p_arg13 != null) args.push(p_arg13);
	if(p_arg14 != null) args.push(p_arg14);
	if(p_arg15 != null) args.push(p_arg15);
	if(p_arg16 != null) args.push(p_arg16);
	if(p_arg17 != null) args.push(p_arg17);
	if(p_arg18 != null) args.push(p_arg18);
	if(p_arg19 != null) args.push(p_arg19);
	if(p_arg20 != null) args.push(p_arg20);
	com_genome2d_debug_GDebug.g2d_internal_args(p_priority,p_pos,args);
};
com_genome2d_debug_GDebug.g2d_internal_args = function(p_priority,p_pos,p_args) {
	var msg;
	switch(p_priority) {
	case 0:
		msg = "INTERNAL_DUMP: ";
		break;
	case 1:
		msg = "AUTO_DUMP: ";
		break;
	case 2:
		msg = "DUMP: ";
		break;
	case 3:
		msg = "INFO: ";
		break;
	case 4:
		msg = "WARNING: ";
		break;
	case 5:
		msg = "ERROR: ";
		break;
	default:
		msg = "";
	}
	if(p_pos != null) msg += p_pos.fileName + ":" + p_pos.lineNumber + " : " + p_pos.methodName;
	if(p_args.length > 0) msg += " : " + p_args.toString();
	com_genome2d_debug_GDebug.g2d_console += msg;
	console.log(msg);
	if(com_genome2d_debug_GDebug.g2d_onDebug != null) com_genome2d_debug_GDebug.g2d_onDebug.dispatch(msg);
	if(p_priority == 5) throw new js__$Boot_HaxeError(msg);
};
com_genome2d_debug_GDebug.trace = function(p_msg) {
	com_genome2d_debug_GDebug.g2d_console += p_msg;
	console.log(p_msg);
	if(com_genome2d_debug_GDebug.g2d_onDebug != null) com_genome2d_debug_GDebug.g2d_onDebug.dispatch(p_msg);
};
var com_genome2d_debug_GDebugPriority = function() { };
com_genome2d_debug_GDebugPriority.__name__ = true;
var com_genome2d_geom_GCurve = function(p_start) {
	if(p_start == null) p_start = 0;
	this.start = p_start;
	this.g2d_segments = [];
	this.g2d_pathLength = 0;
	this.g2d_totalStrength = 0;
};
com_genome2d_geom_GCurve.__name__ = true;
com_genome2d_geom_GCurve.createLine = function(p_end,p_strength) {
	if(p_strength == null) p_strength = 1;
	return new com_genome2d_geom_GCurve().line(p_end,p_strength);
};
com_genome2d_geom_GCurve.prototype = {
	addSegment: function(p_segment) {
		this.g2d_segments.push(p_segment);
		this.g2d_totalStrength += p_segment.strength;
		this.g2d_pathLength++;
	}
	,clear: function() {
		this.g2d_pathLength = 0;
		this.g2d_segments = [];
		this.g2d_totalStrength = 0;
	}
	,line: function(p_end,p_strength) {
		if(p_strength == null) p_strength = 1;
		this.addSegment(new com_genome2d_geom_LinearSegment(p_end,p_strength));
		return this;
	}
	,getEnd: function() {
		if(this.g2d_pathLength > 0) return this.g2d_segments[this.g2d_pathLength - 1].end; else {
			return NaN;
		}
	}
	,calculate: function(k) {
		if(this.g2d_pathLength == 0) return this.start; else if(this.g2d_pathLength == 1) return this.g2d_segments[0].calculate(this.start,k); else {
			var ratio = k * this.g2d_totalStrength;
			var lastEnd = this.start;
			var _g1 = 0;
			var _g = this.g2d_pathLength;
			while(_g1 < _g) {
				var i = _g1++;
				var path = this.g2d_segments[i];
				if(ratio > path.strength) {
					ratio -= path.strength;
					lastEnd = path.end;
				} else return path.calculate(lastEnd,ratio / path.strength);
			}
		}
		return 0;
	}
	,quadraticBezier: function(p_end,p_control,p_strength) {
		if(p_strength == null) p_strength = 1;
		this.addSegment(new com_genome2d_geom_QuadraticBezierSegment(p_end,p_strength,p_control));
		return this;
	}
	,cubicBezier: function(p_end,p_control1,p_control2,p_strength) {
		if(p_strength == null) p_strength = 1;
		this.addSegment(new com_genome2d_geom_CubicBezierSegment(p_end,p_strength,p_control1,p_control2));
		return this;
	}
	,__class__: com_genome2d_geom_GCurve
};
var com_genome2d_geom_Segment = function(p_end,p_strength) {
	this.end = p_end;
	this.strength = p_strength;
};
com_genome2d_geom_Segment.__name__ = true;
com_genome2d_geom_Segment.prototype = {
	calculate: function(p_start,p_d) {
		return NaN;
	}
	,__class__: com_genome2d_geom_Segment
};
var com_genome2d_geom_LinearSegment = function(p_end,p_strength) {
	com_genome2d_geom_Segment.call(this,p_end,p_strength);
};
com_genome2d_geom_LinearSegment.__name__ = true;
com_genome2d_geom_LinearSegment.__super__ = com_genome2d_geom_Segment;
com_genome2d_geom_LinearSegment.prototype = $extend(com_genome2d_geom_Segment.prototype,{
	calculate: function(p_start,p_d) {
		return p_start + p_d * (this.end - p_start);
	}
	,__class__: com_genome2d_geom_LinearSegment
});
var com_genome2d_geom_QuadraticBezierSegment = function(p_end,p_strength,p_control) {
	com_genome2d_geom_Segment.call(this,p_end,p_strength);
	this.control = p_control;
};
com_genome2d_geom_QuadraticBezierSegment.__name__ = true;
com_genome2d_geom_QuadraticBezierSegment.__super__ = com_genome2d_geom_Segment;
com_genome2d_geom_QuadraticBezierSegment.prototype = $extend(com_genome2d_geom_Segment.prototype,{
	calculate: function(p_start,p_d) {
		var inv = 1 - p_d;
		return inv * inv * p_start + 2 * inv * p_d * this.control + p_d * p_d * this.end;
	}
	,__class__: com_genome2d_geom_QuadraticBezierSegment
});
var com_genome2d_geom_CubicBezierSegment = function(p_end,p_strength,p_control1,p_control2) {
	com_genome2d_geom_Segment.call(this,p_end,p_strength);
	this.control1 = p_control1;
	this.control2 = p_control2;
};
com_genome2d_geom_CubicBezierSegment.__name__ = true;
com_genome2d_geom_CubicBezierSegment.__super__ = com_genome2d_geom_Segment;
com_genome2d_geom_CubicBezierSegment.prototype = $extend(com_genome2d_geom_Segment.prototype,{
	calculate: function(p_start,p_d) {
		var inv = 1 - p_d;
		var inv2 = inv * inv;
		var d2 = p_d * p_d;
		return inv2 * inv * p_start + 3 * inv2 * p_d * this.control1 + 3 * inv * d2 * this.control2 + d2 * p_d * this.end;
	}
	,__class__: com_genome2d_geom_CubicBezierSegment
});
var com_genome2d_geom_GMatrix = function(p_a,p_b,p_c,p_d,p_tx,p_ty) {
	if(p_ty == null) p_ty = 0;
	if(p_tx == null) p_tx = 0;
	if(p_d == null) p_d = 1;
	if(p_c == null) p_c = 0;
	if(p_b == null) p_b = 0;
	if(p_a == null) p_a = 1;
	this.a = p_a;
	this.b = p_b;
	this.c = p_c;
	this.d = p_d;
	this.tx = p_tx;
	this.ty = p_ty;
};
com_genome2d_geom_GMatrix.__name__ = true;
com_genome2d_geom_GMatrix.prototype = {
	copyFrom: function(p_from) {
		this.a = p_from.a;
		this.b = p_from.b;
		this.c = p_from.c;
		this.d = p_from.d;
		this.tx = p_from.tx;
		this.ty = p_from.ty;
	}
	,setTo: function(p_a,p_b,p_c,p_d,p_tx,p_ty) {
		this.a = p_a;
		this.b = p_b;
		this.c = p_c;
		this.d = p_d;
		this.tx = p_tx;
		this.ty = p_ty;
	}
	,identity: function() {
		this.a = 1;
		this.b = 0;
		this.c = 0;
		this.d = 1;
		this.tx = 0;
		this.ty = 0;
	}
	,concat: function(p_matrix) {
		var a1 = this.a * p_matrix.a + this.b * p_matrix.c;
		this.b = this.a * p_matrix.b + this.b * p_matrix.d;
		this.a = a1;
		var c1 = this.c * p_matrix.a + this.d * p_matrix.c;
		this.d = this.c * p_matrix.b + this.d * p_matrix.d;
		this.c = c1;
		var tx1 = this.tx * p_matrix.a + this.ty * p_matrix.c + p_matrix.tx;
		this.ty = this.tx * p_matrix.b + this.ty * p_matrix.d + p_matrix.ty;
		this.tx = tx1;
	}
	,invert: function() {
		var n = this.a * this.d - this.b * this.c;
		if(n == 0) {
			this.a = this.b = this.c = this.d = 0;
			this.tx = -this.tx;
			this.ty = -this.ty;
		} else {
			n = 1 / n;
			var a1 = this.d * n;
			this.d = this.a * n;
			this.a = a1;
			this.b *= -n;
			this.c *= -n;
			var tx1 = -this.a * this.tx - this.c * this.ty;
			this.ty = -this.b * this.tx - this.d * this.ty;
			this.tx = tx1;
		}
		return this;
	}
	,__class__: com_genome2d_geom_GMatrix
};
var com_genome2d_geom_GMatrix3D = function() {
};
com_genome2d_geom_GMatrix3D.__name__ = true;
com_genome2d_geom_GMatrix3D.prototype = {
	identity: function() {
	}
	,prependTranslation: function(p_x,p_y,p_z) {
	}
	,__class__: com_genome2d_geom_GMatrix3D
};
var com_genome2d_geom_GMatrixUtils = function() { };
com_genome2d_geom_GMatrixUtils.__name__ = true;
com_genome2d_geom_GMatrixUtils.prependMatrix = function(p_matrix,p_by) {
	p_matrix.setTo(p_matrix.a * p_by.a + p_matrix.c * p_by.b,p_matrix.b * p_by.a + p_matrix.d * p_by.b,p_matrix.a * p_by.c + p_matrix.c * p_by.d,p_matrix.b * p_by.c + p_matrix.d * p_by.d,p_matrix.tx + p_matrix.a * p_by.tx + p_matrix.c * p_by.ty,p_matrix.ty + p_matrix.b * p_by.tx + p_matrix.d * p_by.ty);
};
var com_genome2d_geom_GPoint = function(p_x,p_y) {
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
};
com_genome2d_geom_GPoint.__name__ = true;
com_genome2d_geom_GPoint.prototype = {
	__class__: com_genome2d_geom_GPoint
};
var com_genome2d_geom_GRectangle = function(p_x,p_y,p_width,p_height) {
	if(p_height == null) p_height = 0;
	if(p_width == null) p_width = 0;
	if(p_y == null) p_y = 0;
	if(p_x == null) p_x = 0;
	this.x = p_x;
	this.y = p_y;
	this.width = p_width;
	this.height = p_height;
};
com_genome2d_geom_GRectangle.__name__ = true;
com_genome2d_geom_GRectangle.prototype = {
	get_bottom: function() {
		return this.y + this.height;
	}
	,set_bottom: function(p_value) {
		this.height = p_value - this.y;
		return p_value;
	}
	,get_left: function() {
		return this.x;
	}
	,set_left: function(p_value) {
		this.width -= p_value - this.x;
		this.x = p_value;
		return p_value;
	}
	,get_right: function() {
		return this.x + this.width;
	}
	,set_right: function(p_value) {
		this.width = p_value - this.x;
		return p_value;
	}
	,get_top: function() {
		return this.y;
	}
	,set_top: function(p_value) {
		this.height -= p_value - this.y;
		this.y = p_value;
		return p_value;
	}
	,setTo: function(p_x,p_y,p_width,p_height) {
		this.x = p_x;
		this.y = p_y;
		this.width = p_width;
		this.height = p_height;
	}
	,clone: function() {
		return new com_genome2d_geom_GRectangle(this.x,this.y,this.width,this.height);
	}
	,intersection: function(p_rect) {
		var result;
		var x0;
		if(this.x < p_rect.x) x0 = p_rect.x; else x0 = this.x;
		var x1;
		if(this.get_right() > p_rect.get_right()) x1 = p_rect.get_right(); else x1 = this.get_right();
		if(x1 <= x0) result = new com_genome2d_geom_GRectangle(); else {
			var y0;
			if(this.y < p_rect.y) y0 = p_rect.y; else y0 = this.y;
			var y1;
			if(this.get_bottom() > p_rect.get_bottom()) y1 = p_rect.get_bottom(); else y1 = this.get_bottom();
			if(y1 <= y0) result = new com_genome2d_geom_GRectangle(); else result = new com_genome2d_geom_GRectangle(x0,y0,x1 - x0,y1 - y0);
		}
		return result;
	}
	,contains: function(p_x,p_y) {
		return p_x >= this.x && p_y >= this.y && p_x < this.get_right() && p_y < this.get_bottom();
	}
	,__class__: com_genome2d_geom_GRectangle
	,__properties__: {set_top:"set_top",get_top:"get_top",set_right:"set_right",get_right:"get_right",set_left:"set_left",get_left:"get_left",set_bottom:"set_bottom",get_bottom:"get_bottom"}
};
var com_genome2d_input_GFocusManager = function() { };
com_genome2d_input_GFocusManager.__name__ = true;
com_genome2d_input_GFocusManager.setFocus = function(p_interactive) {
	com_genome2d_input_GFocusManager.activeFocus = p_interactive;
};
var com_genome2d_input_GKeyboardInput = function(p_type,p_keyCode,p_charCode) {
	this.type = p_type;
	this.keyCode = p_keyCode;
	this.charCode = p_charCode;
};
com_genome2d_input_GKeyboardInput.__name__ = true;
com_genome2d_input_GKeyboardInput.prototype = {
	__class__: com_genome2d_input_GKeyboardInput
};
var com_genome2d_input_GKeyboardInputType = function() { };
com_genome2d_input_GKeyboardInputType.__name__ = true;
com_genome2d_input_GKeyboardInputType.fromNative = function(p_nativeType) {
	var type = "";
	switch(p_nativeType) {
	case "keyup":
		type = "keyUp";
		break;
	case "keydown":
		type = "keyDown";
		break;
	}
	return type;
};
var com_genome2d_input_GMouseInput = function(p_target,p_dispatcher,p_type,p_localX,p_localY) {
	this.delta = 0;
	this.nativeCaptured = false;
	this.shiftKey = false;
	this.altKey = false;
	this.ctrlKey = false;
	this.buttonDown = false;
	this.g2d_captured = false;
	this.dispatcher = p_dispatcher;
	this.target = p_target;
	this.type = p_type;
	this.localX = p_localX;
	this.localY = p_localY;
};
com_genome2d_input_GMouseInput.__name__ = true;
com_genome2d_input_GMouseInput.prototype = {
	clone: function(p_target,p_dispatcher,p_type) {
		var input = new com_genome2d_input_GMouseInput(p_target,p_dispatcher,p_type,this.localX,this.localY);
		input.contextX = this.contextX;
		input.contextY = this.contextY;
		input.worldX = this.worldX;
		input.worldY = this.worldY;
		input.buttonDown = this.buttonDown;
		input.ctrlKey = this.ctrlKey;
		input.altKey = this.altKey;
		input.shiftKey = this.shiftKey;
		input.nativeCaptured = this.nativeCaptured;
		input.delta = this.delta;
		input.camera = this.camera;
		input.g2d_captured = this.g2d_captured;
		return input;
	}
	,__class__: com_genome2d_input_GMouseInput
};
var com_genome2d_input_GMouseInputType = function() { };
com_genome2d_input_GMouseInputType.__name__ = true;
com_genome2d_input_GMouseInputType.fromNative = function(p_nativeType) {
	var type = "";
	switch(p_nativeType) {
	case "mousemove":case "touchmove":
		type = "mouseMove";
		break;
	case "mousedown":case "touchstart":
		type = "mouseDown";
		break;
	case "mouseup":case "touchend":case "touchcancel":
		type = "mouseUp";
		break;
	}
	return type;
};
var com_genome2d_macros_MGBuildID = function() { };
com_genome2d_macros_MGBuildID.__name__ = true;
var com_genome2d_macros_MGDebug = function() { };
com_genome2d_macros_MGDebug.__name__ = true;
var com_genome2d_macros_MGPrototypeProcessor = function() { };
com_genome2d_macros_MGPrototypeProcessor.__name__ = true;
var com_genome2d_node_GNode = function() {
	this.g2d_currentState = "default";
	this.g2d_localAlpha = 1;
	this.g2d_worldAlpha = 1;
	this.g2d_localBlue = 1;
	this.g2d_worldBlue = 1;
	this.g2d_localGreen = 1;
	this.g2d_worldGreen = 1;
	this.g2d_localRed = 1;
	this.g2d_worldRed = 1;
	this.g2d_localRotation = 0;
	this.g2d_worldRotation = 0;
	this.g2d_localScaleY = 1;
	this.g2d_worldScaleY = 1;
	this.g2d_localScaleX = 1;
	this.g2d_worldScaleX = 1;
	this.g2d_localUseMatrix = 0;
	this.g2d_localY = 0;
	this.g2d_worldY = 0;
	this.g2d_localX = 0;
	this.g2d_worldX = 0;
	this.visible = true;
	this.useWorldColor = false;
	this.useWorldSpace = false;
	this.g2d_colorDirty = false;
	this.g2d_transformDirty = false;
	this.g2d_matrixDirty = true;
	this.g2d_childCount = 0;
	this.g2d_componentCount = 0;
	this.mousePixelTreshold = 0;
	this.mousePixelEnabled = false;
	this.mouseEnabled = false;
	this.mouseChildren = true;
	this.g2d_disposed = false;
	this.g2d_active = true;
	this.g2d_usedAsMask = 0;
	this.cameraGroup = 0;
	this.g2d_id = com_genome2d_node_GNode.g2d_nodeCount++;
	this.name = "GNode#" + this.g2d_id;
	if(com_genome2d_node_GNode.g2d_cachedMatrix == null) {
		com_genome2d_node_GNode.g2d_cachedMatrix = new com_genome2d_geom_GMatrix();
		com_genome2d_node_GNode.g2d_cachedTransformMatrix = new com_genome2d_geom_GMatrix();
		com_genome2d_node_GNode.g2d_activeMasks = [];
	}
};
com_genome2d_node_GNode.__name__ = true;
com_genome2d_node_GNode.__interfaces__ = [com_genome2d_proto_IGPrototypable,com_genome2d_input_IGInteractive];
com_genome2d_node_GNode.create = function(p_name) {
	if(p_name == null) p_name = "";
	var node = new com_genome2d_node_GNode();
	if(p_name != "") node.name = p_name;
	return node;
};
com_genome2d_node_GNode.createWithComponent = function(p_componentClass,p_name) {
	if(p_name == null) p_name = "";
	var node = new com_genome2d_node_GNode();
	if(p_name != "") node.name = p_name;
	return node.addComponent(p_componentClass);
};
com_genome2d_node_GNode.createFromPrototype = function(p_prototype) {
	if(p_prototype == null) com_genome2d_debug_GDebug.error("Null proto",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 82, className : "com.genome2d.node.GNode", methodName : "createFromPrototype"});
	if(p_prototype.prototypeName != com_genome2d_node_GNode.PROTOTYPE_NAME) com_genome2d_debug_GDebug.error("Incorrect GNode prototype",p_prototype.prototypeName,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 84, className : "com.genome2d.node.GNode", methodName : "createFromPrototype"});
	var node = new com_genome2d_node_GNode();
	node.bindPrototype(p_prototype);
	var components = p_prototype.getGroup("components");
	if(components != null) {
		var _g = 0;
		while(_g < components.length) {
			var prototype = components[_g];
			++_g;
			node.addComponentPrototype(prototype);
		}
	}
	var children = p_prototype.getGroup("children");
	if(children != null) {
		var _g1 = 0;
		while(_g1 < children.length) {
			var prototype1 = children[_g1];
			++_g1;
			node.addChild(com_genome2d_node_GNode.createFromPrototype(prototype1));
		}
	}
	return node;
};
com_genome2d_node_GNode.prototype = {
	get_core: function() {
		if(com_genome2d_node_GNode.g2d_core == null) {
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
		}
		return com_genome2d_node_GNode.g2d_core;
	}
	,get_mask: function() {
		return this.g2d_mask;
	}
	,set_mask: function(p_value) {
		if(!((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).getContext().hasFeature(1)) com_genome2d_debug_GDebug.error("Stencil masking feature not supported.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 151, className : "com.genome2d.node.GNode", methodName : "set_mask"});
		if(this.g2d_mask != null) this.g2d_mask.g2d_usedAsMask--;
		this.g2d_mask = p_value;
		this.g2d_mask.g2d_usedAsMask++;
		return this.g2d_mask;
	}
	,isActive: function() {
		return this.g2d_active;
	}
	,setActive: function(p_value) {
		if(p_value != this.g2d_active) {
			if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 177, className : "com.genome2d.node.GNode", methodName : "setActive"});
			this.g2d_active = p_value;
			var _g1 = 0;
			var _g = this.g2d_componentCount;
			while(_g1 < _g) {
				var i = _g1++;
				this.g2d_components[i].setActive(p_value);
			}
			var child = this.g2d_firstChild;
			while(child != null) {
				var next = child.g2d_next;
				child.setActive(p_value);
				child = next;
			}
		}
	}
	,get_id: function() {
		return this.g2d_id;
	}
	,get_parent: function() {
		return this.g2d_parent;
	}
	,isDisposed: function() {
		return this.g2d_disposed;
	}
	,dispose: function() {
		if(this.g2d_disposed) return;
		this.disposeChildren();
		this.disposeComponents();
		if(this.g2d_parent != null) this.g2d_parent.removeChild(this);
		this.disposeCallbacks();
		this.g2d_disposed = true;
	}
	,disposeCallbacks: function() {
		if(this.g2d_onAddedToStage != null) {
			this.g2d_onAddedToStage.removeAll();
			this.g2d_onAddedToStage = null;
		}
		if(this.g2d_onRemovedFromStage != null) {
			this.g2d_onRemovedFromStage.removeAll();
			this.g2d_onRemovedFromStage = null;
		}
		if(this.g2d_onMouseClick != null) {
			this.g2d_onMouseClick.removeAll();
			this.g2d_onMouseClick = null;
		}
		if(this.g2d_onMouseDown != null) {
			this.g2d_onMouseDown.removeAll();
			this.g2d_onMouseDown = null;
		}
		if(this.g2d_onMouseMove != null) {
			this.g2d_onMouseMove.removeAll();
			this.g2d_onMouseMove = null;
		}
		if(this.g2d_onMouseOut != null) {
			this.g2d_onMouseOut.removeAll();
			this.g2d_onMouseOut = null;
		}
		if(this.g2d_onMouseOver != null) {
			this.g2d_onMouseOver.removeAll();
			this.g2d_onMouseOver = null;
		}
		if(this.g2d_onMouseUp != null) {
			this.g2d_onMouseUp.removeAll();
			this.g2d_onMouseUp = null;
		}
		if(this.g2d_onRightMouseClick != null) {
			this.g2d_onRightMouseClick.removeAll();
			this.g2d_onRightMouseClick = null;
		}
		if(this.g2d_onRightMouseDown != null) {
			this.g2d_onRightMouseDown.removeAll();
			this.g2d_onRightMouseDown = null;
		}
		if(this.g2d_onRightMouseUp != null) {
			this.g2d_onRightMouseUp.removeAll();
			this.g2d_onRightMouseUp = null;
		}
	}
	,hitTest: function(p_x,p_y,p_hierarchy) {
		if(p_hierarchy == null) p_hierarchy = false;
		if(this.g2d_active && this.visible) {
			if(p_hierarchy) {
				var child = this.g2d_lastChild;
				while(child != null) {
					var previous = child.g2d_previous;
					if(child.hitTest(p_x,p_y,true)) return true;
					child = previous;
				}
			}
			if(this.g2d_renderable != null || this.g2d_defaultRenderable != null) {
				var tx = p_x - this.g2d_worldX;
				var ty = p_y - this.g2d_worldY;
				if(this.g2d_worldRotation != 0) {
					var cos = Math.cos(-this.g2d_worldRotation);
					var sin = Math.sin(-this.g2d_worldRotation);
					var ox = tx;
					tx = tx * cos - ty * sin;
					ty = ty * cos + ox * sin;
				}
				tx /= this.g2d_worldScaleX;
				ty /= this.g2d_worldScaleY;
				if(this.g2d_defaultRenderable != null?this.g2d_defaultRenderable.hitTest(tx,ty):this.g2d_renderable.hitTest(tx,ty)) return true;
			}
		}
		return false;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = this.getPrototypeDefault(p_prototype);
		var _g1 = 0;
		var _g = this.g2d_componentCount;
		while(_g1 < _g) {
			var i = _g1++;
			p_prototype.addChild(this.g2d_components[i].getPrototype(),"components");
		}
		var child = this.g2d_firstChild;
		while(child != null) {
			var next = child.g2d_next;
			p_prototype.addChild(child.getPrototype(),"children");
			child = next;
		}
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		this.bindPrototypeDefault(p_prototype);
	}
	,get_onMouseDown: function() {
		if(this.g2d_onMouseDown == null) this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseDown;
	}
	,get_onMouseMove: function() {
		if(this.g2d_onMouseMove == null) this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseMove;
	}
	,get_onMouseClick: function() {
		if(this.g2d_onMouseClick == null) this.g2d_onMouseClick = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseClick;
	}
	,get_onMouseUp: function() {
		if(this.g2d_onMouseUp == null) this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseUp;
	}
	,get_onMouseOver: function() {
		if(this.g2d_onMouseOver == null) this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseOver;
	}
	,get_onMouseOut: function() {
		if(this.g2d_onMouseOut == null) this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseOut;
	}
	,captureMouseInput: function(p_input) {
		if(!this.g2d_active || !this.visible || p_input.camera != null && (this.cameraGroup & p_input.camera.mask) == 0 && this.cameraGroup != 0) return;
		if(this.mouseChildren) {
			var child = this.g2d_lastChild;
			while(child != null) {
				var previous = child.g2d_previous;
				child.captureMouseInput(p_input);
				child = previous;
			}
		}
		if(this.mouseEnabled) {
			if(p_input.g2d_captured && p_input.type == "mouseUp") this.g2d_mouseDownNode = null;
			var previouslyCaptured = p_input.g2d_captured;
			if(this.g2d_renderable != null || this.g2d_defaultRenderable != null) {
				var tx = p_input.worldX - this.g2d_worldX;
				var ty = p_input.worldY - this.g2d_worldY;
				if(this.g2d_worldRotation != 0) {
					var cos = Math.cos(-this.g2d_worldRotation);
					var sin = Math.sin(-this.g2d_worldRotation);
					var ox = tx;
					tx = tx * cos - ty * sin;
					ty = ty * cos + ox * sin;
				}
				if(this.g2d_worldScaleX == 0) {
					p_input.localX = Infinity;
				} else p_input.localX = tx / this.g2d_worldScaleX;
				if(this.g2d_worldScaleY == 0) {
					p_input.localY = Infinity;
				} else p_input.localY = ty / this.g2d_worldScaleY;
				if(this.g2d_defaultRenderable != null) p_input.g2d_captured = p_input.g2d_captured || this.g2d_defaultRenderable.hitTest(p_input.localX,p_input.localY); else this.g2d_renderable.captureMouseInput(p_input);
			}
			if(!previouslyCaptured && p_input.g2d_captured) {
				this.g2d_dispatchMouseCallback(p_input.type,this,p_input);
				if(this.g2d_mouseOverNode != this) this.g2d_dispatchMouseCallback("mouseOver",this,p_input);
			} else if(this.g2d_mouseOverNode == this) this.g2d_dispatchMouseCallback("mouseOut",this,p_input);
		}
	}
	,g2d_dispatchMouseCallback: function(p_type,p_object,p_input) {
		if(this.mouseEnabled) {
			var mouseInput = p_input.clone(this,p_object,p_type);
			switch(p_type) {
			case "mouseDown":
				this.g2d_mouseDownNode = p_object;
				if(this.g2d_onMouseDown != null) this.g2d_onMouseDown.dispatch(mouseInput);
				break;
			case "mouseMove":
				if(this.g2d_onMouseMove != null) this.g2d_onMouseMove.dispatch(mouseInput);
				break;
			case "mouseUp":
				if(this.g2d_mouseDownNode == p_object && this.g2d_onMouseClick != null) {
					var mouseClickInput = p_input.clone(this,p_object,"mouseUp");
					this.g2d_onMouseClick.dispatch(mouseClickInput);
				}
				this.g2d_mouseDownNode = null;
				if(this.g2d_onMouseUp != null) this.g2d_onMouseUp.dispatch(mouseInput);
				break;
			case "mouseOver":
				this.g2d_mouseOverNode = p_object;
				if(this.g2d_onMouseOver != null) this.g2d_onMouseOver.dispatch(mouseInput);
				break;
			case "mouseOut":
				this.g2d_mouseOverNode = null;
				if(this.g2d_onMouseOut != null) this.g2d_onMouseOut.dispatch(mouseInput);
				break;
			}
		}
		if(this.g2d_parent != null) this.g2d_parent.g2d_dispatchMouseCallback(p_type,p_object,p_input);
	}
	,getComponent: function(p_componentClass) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 588, className : "com.genome2d.node.GNode", methodName : "getComponent"});
		var _g1 = 0;
		var _g = this.g2d_componentCount;
		while(_g1 < _g) {
			var i = _g1++;
			var component = this.g2d_components[i];
			if(js_Boot.__instanceof(component,p_componentClass)) return component;
		}
		return null;
	}
	,getComponents: function() {
		return this.g2d_components;
	}
	,hasComponent: function(p_componentLookupClass) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 604, className : "com.genome2d.node.GNode", methodName : "hasComponent"});
		return this.getComponent(p_componentLookupClass) != null;
	}
	,addComponent: function(p_componentClass) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 614, className : "com.genome2d.node.GNode", methodName : "addComponent"});
		var lookup = this.getComponent(p_componentClass);
		if(lookup != null) return lookup;
		var component = Type.createInstance(p_componentClass,[]);
		if(component == null) com_genome2d_debug_GDebug.error("Invalid components.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 621, className : "com.genome2d.node.GNode", methodName : "addComponent"});
		component.g2d_node = this;
		if(js_Boot.__instanceof(component,com_genome2d_components_renderable_GSprite)) this.g2d_defaultRenderable = component; else if(js_Boot.__instanceof(component,com_genome2d_components_renderable_IGRenderable)) this.g2d_renderable = component;
		if(this.g2d_components == null) this.g2d_components = [];
		this.g2d_components.push(component);
		this.g2d_componentCount++;
		component.init();
		return component;
	}
	,addComponentPrototype: function(p_prototype) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 641, className : "com.genome2d.node.GNode", methodName : "addComponentPrototype"});
		var component = this.addComponent(p_prototype.prototypeClass);
		component.bindPrototype(p_prototype);
		return component;
	}
	,removeComponent: function(p_componentClass) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 657, className : "com.genome2d.node.GNode", methodName : "removeComponent"});
		var component = this.getComponent(p_componentClass);
		if(component == null) return;
		HxOverrides.remove(this.g2d_components,component);
		this.g2d_componentCount--;
		if(js_Boot.__instanceof(component,com_genome2d_components_renderable_GSprite)) this.g2d_defaultRenderable = null; else if(js_Boot.__instanceof(component,com_genome2d_components_renderable_IGRenderable)) this.g2d_renderable = null;
		component.g2d_dispose();
	}
	,disposeComponents: function() {
		while(this.g2d_componentCount > 0) {
			this.g2d_components.pop().g2d_dispose();
			this.g2d_componentCount--;
		}
		this.g2d_defaultRenderable = null;
		this.g2d_renderable = null;
	}
	,get_firstChild: function() {
		return this.g2d_firstChild;
	}
	,get_lastChild: function() {
		return this.g2d_lastChild;
	}
	,get_next: function() {
		return this.g2d_next;
	}
	,get_previous: function() {
		return this.g2d_previous;
	}
	,get_childCount: function() {
		return this.g2d_childCount;
	}
	,get_onAddedToStage: function() {
		if(this.g2d_onAddedToStage == null) this.g2d_onAddedToStage = new com_genome2d_callbacks_GCallback0();
		return this.g2d_onAddedToStage;
	}
	,get_onRemovedFromStage: function() {
		if(this.g2d_onRemovedFromStage == null) this.g2d_onRemovedFromStage = new com_genome2d_callbacks_GCallback0();
		return this.g2d_onRemovedFromStage;
	}
	,addChild: function(p_child,p_before) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 750, className : "com.genome2d.node.GNode", methodName : "addChild"});
		if(p_child == this) com_genome2d_debug_GDebug.error("Can't add child to itself.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 751, className : "com.genome2d.node.GNode", methodName : "addChild"});
		if(p_child.g2d_parent != null) p_child.g2d_parent.removeChild(p_child);
		p_child.g2d_parent = this;
		if(this.g2d_firstChild == null) {
			this.g2d_firstChild = p_child;
			this.g2d_lastChild = p_child;
		} else if(p_before == null) {
			this.g2d_lastChild.g2d_next = p_child;
			p_child.g2d_previous = this.g2d_lastChild;
			this.g2d_lastChild = p_child;
		} else {
			if(p_before != this.g2d_firstChild) p_before.g2d_previous.g2d_next = p_child; else this.g2d_firstChild = p_child;
			p_child.g2d_previous = p_before.g2d_previous;
			p_child.g2d_next = p_before;
			p_before.g2d_previous = p_child;
		}
		this.g2d_childCount++;
		if(this.g2d_childCount == 1 && (this.g2d_localScaleX != this.g2d_localScaleY && this.g2d_localRotation != 0)) {
			var _g = this;
			var _g1 = _g.g2d_localUseMatrix;
			_g.set_g2d_useMatrix(_g1 + 1);
			_g1;
		}
		if(this.isOnStage()) p_child.g2d_addedToStage();
		return p_child;
	}
	,addChildAt: function(p_child,p_index) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 782, className : "com.genome2d.node.GNode", methodName : "addChildAt"});
		if(p_child == this) com_genome2d_debug_GDebug.error("Can't add child to itself.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 783, className : "com.genome2d.node.GNode", methodName : "addChildAt"});
		if(p_child.g2d_parent != null) p_child.g2d_parent.removeChild(p_child);
		var i = 0;
		var after = this.g2d_firstChild;
		while(i < p_index && after != null) {
			after = after.g2d_next;
			i++;
		}
		return this.addChild(p_child,after == null?null:after);
	}
	,getChildAt: function(p_index) {
		if(p_index >= this.g2d_childCount) com_genome2d_debug_GDebug.error("Index out of bounds.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 796, className : "com.genome2d.node.GNode", methodName : "getChildAt"});
		var child = this.g2d_firstChild;
		var _g = 0;
		while(_g < p_index) {
			var i = _g++;
			child = child.g2d_next;
		}
		return child;
	}
	,getChildIndex: function(p_child) {
		if(p_child.g2d_parent != this) return -1;
		var child = this.g2d_firstChild;
		var _g1 = 0;
		var _g = this.g2d_childCount;
		while(_g1 < _g) {
			var i = _g1++;
			if(child == p_child) return i;
			child = child.g2d_next;
		}
		return -1;
	}
	,setChildIndex: function(p_child,p_index) {
		if(p_child.g2d_parent != this) com_genome2d_debug_GDebug.error("Not a child of this node.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 815, className : "com.genome2d.node.GNode", methodName : "setChildIndex"});
		if(p_index >= this.g2d_childCount) com_genome2d_debug_GDebug.error("Index out of bounds.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 816, className : "com.genome2d.node.GNode", methodName : "setChildIndex"});
		var index = 0;
		var child = this.g2d_firstChild;
		while(child != null && index < p_index) {
			child = child.g2d_next;
			index++;
		}
		if(index == p_index && child != p_child) {
			if(p_child != this.g2d_lastChild) p_child.g2d_next.g2d_previous = p_child.g2d_previous; else this.g2d_lastChild = p_child.g2d_previous;
			if(p_child != this.g2d_firstChild) p_child.g2d_previous.g2d_next = p_child.g2d_next; else this.g2d_firstChild = p_child.g2d_next;
			if(child != this.g2d_firstChild) child.g2d_previous.g2d_next = p_child; else this.g2d_firstChild = p_child;
			p_child.g2d_previous = child.g2d_previous;
			p_child.g2d_next = child;
			child.g2d_previous = p_child;
		}
	}
	,swapChildrenAt: function(p_index1,p_index2) {
		this.swapChildren(this.getChildAt(p_index1),this.getChildAt(p_index2));
	}
	,swapChildren: function(p_child1,p_child2) {
		if(p_child1.g2d_parent != this || p_child2.g2d_parent != this) return;
		var temp = p_child1.g2d_next;
		if(p_child2.g2d_next == p_child1) p_child1.g2d_next = p_child2; else {
			p_child1.g2d_next = p_child2.g2d_next;
			if(p_child1.g2d_next != null) p_child1.g2d_next.g2d_previous = p_child1;
		}
		if(temp == p_child2) p_child2.g2d_next = p_child1; else {
			p_child2.g2d_next = temp;
			if(p_child2.g2d_next != null) p_child2.g2d_next.g2d_previous = p_child2;
		}
		temp = p_child1.g2d_previous;
		if(p_child2.g2d_previous == p_child1) p_child1.g2d_previous = p_child2; else {
			p_child1.g2d_previous = p_child2.g2d_previous;
			if(p_child1.g2d_previous != null) p_child1.g2d_previous.g2d_next = p_child1;
		}
		if(temp == p_child2) p_child2.g2d_previous = p_child1; else {
			p_child2.g2d_previous = temp;
			if(p_child2.g2d_previous != null) p_child2.g2d_previous.g2d_next = p_child2;
		}
		if(p_child1 == this.g2d_firstChild) this.g2d_firstChild = p_child2; else if(p_child2 == this.g2d_firstChild) this.g2d_firstChild = p_child1;
		if(p_child1 == this.g2d_lastChild) this.g2d_lastChild = p_child2; else if(p_child2 == this.g2d_lastChild) this.g2d_lastChild = p_child1;
	}
	,putChildToFront: function(p_child) {
		if(p_child.g2d_parent != this || p_child == this.g2d_lastChild) return;
		if(p_child.g2d_next != null) p_child.g2d_next.g2d_previous = p_child.g2d_previous;
		if(p_child.g2d_previous != null) p_child.g2d_previous.g2d_next = p_child.g2d_next;
		if(p_child == this.g2d_firstChild) this.g2d_firstChild = this.g2d_firstChild.g2d_next;
		if(this.g2d_lastChild != null) this.g2d_lastChild.g2d_next = p_child;
		p_child.g2d_previous = this.g2d_lastChild;
		p_child.g2d_next = null;
		this.g2d_lastChild = p_child;
	}
	,putChildToBack: function(p_child) {
		if(p_child.g2d_parent != this || p_child == this.g2d_firstChild) return;
		if(p_child.g2d_next != null) p_child.g2d_next.g2d_previous = p_child.g2d_previous;
		if(p_child.g2d_previous != null) p_child.g2d_previous.g2d_next = p_child.g2d_next;
		if(p_child == this.g2d_lastChild) this.g2d_lastChild = this.g2d_lastChild.g2d_previous;
		if(this.g2d_firstChild != null) this.g2d_firstChild.g2d_previous = p_child;
		p_child.g2d_previous = null;
		p_child.g2d_next = this.g2d_firstChild;
		this.g2d_firstChild = p_child;
	}
	,removeChild: function(p_child) {
		if(this.g2d_disposed) com_genome2d_debug_GDebug.error("Node already disposed.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 921, className : "com.genome2d.node.GNode", methodName : "removeChild"});
		if(p_child.g2d_parent != this) return null;
		if(p_child.g2d_previous != null) p_child.g2d_previous.g2d_next = p_child.g2d_next; else this.g2d_firstChild = this.g2d_firstChild.g2d_next;
		if(p_child.g2d_next != null) p_child.g2d_next.g2d_previous = p_child.g2d_previous; else this.g2d_lastChild = this.g2d_lastChild.g2d_previous;
		p_child.g2d_next = p_child.g2d_previous = p_child.g2d_parent = null;
		this.g2d_childCount--;
		if(this.g2d_childCount == 0 && (this.g2d_localScaleX != this.g2d_localScaleY && this.g2d_localRotation != 0)) {
			var _g = this;
			var _g1 = _g.g2d_localUseMatrix;
			_g.set_g2d_useMatrix(_g1 - 1);
			_g1;
		}
		if(this.isOnStage()) p_child.g2d_removedFromStage();
		return p_child;
	}
	,removeChildAt: function(p_index) {
		if(p_index >= this.g2d_childCount) com_genome2d_debug_GDebug.error("Index out of bounds.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GNode.hx", lineNumber : 945, className : "com.genome2d.node.GNode", methodName : "removeChildAt"});
		var index = 0;
		var child = this.g2d_firstChild;
		while(child != null && index < p_index) {
			child = child.g2d_next;
			index++;
		}
		return this.removeChild(child);
	}
	,disposeChildren: function() {
		while(this.g2d_firstChild != null) this.g2d_firstChild.dispose();
	}
	,g2d_addedToStage: function() {
		if(this.g2d_onAddedToStage != null) this.g2d_onAddedToStage.dispatch();
		com_genome2d_context_stats_GStats.nodeCount++;
		var child = this.g2d_firstChild;
		while(child != null) {
			var next = child.g2d_next;
			child.g2d_addedToStage();
			child = next;
		}
	}
	,g2d_removedFromStage: function() {
		if(this.g2d_onRemovedFromStage != null) this.g2d_onRemovedFromStage.dispatch();
		com_genome2d_context_stats_GStats.nodeCount--;
		var child = this.g2d_firstChild;
		while(child != null) {
			var next = child.g2d_next;
			child.g2d_removedFromStage();
			child = next;
		}
	}
	,isOnStage: function() {
		if(this == ((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_root()) return true; else if(this.g2d_parent == null) return false; else return this.g2d_parent.isOnStage();
	}
	,getBounds: function(p_targetSpace,p_bounds) {
		if(p_targetSpace == null) p_targetSpace = ((function($this) {
			var $r;
			if(com_genome2d_node_GNode.g2d_core == null) {
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
			}
			$r = com_genome2d_node_GNode.g2d_core;
			return $r;
		}(this))).get_root();
		if(p_bounds == null) p_bounds = new com_genome2d_geom_GRectangle();
		var found = false;
		var minX = 10000000;
		var maxX = -10000000;
		var minY = 10000000;
		var maxY = -10000000;
		var aabb = new com_genome2d_geom_GRectangle(0,0,0,0);
		if(this.g2d_defaultRenderable != null) this.g2d_defaultRenderable.getBounds(aabb); else if(this.g2d_renderable != null) this.g2d_renderable.getBounds(aabb);
		if(aabb.width != 0 && aabb.height != 0) {
			var m = this.getTransformationMatrix(p_targetSpace,com_genome2d_node_GNode.g2d_cachedMatrix);
			var tx1 = com_genome2d_node_GNode.g2d_cachedMatrix.a * aabb.x + com_genome2d_node_GNode.g2d_cachedMatrix.c * aabb.y + com_genome2d_node_GNode.g2d_cachedMatrix.tx;
			var ty1 = com_genome2d_node_GNode.g2d_cachedMatrix.d * aabb.y + com_genome2d_node_GNode.g2d_cachedMatrix.b * aabb.x + com_genome2d_node_GNode.g2d_cachedMatrix.ty;
			var tx2 = com_genome2d_node_GNode.g2d_cachedMatrix.a * aabb.x + com_genome2d_node_GNode.g2d_cachedMatrix.c * aabb.get_bottom() + com_genome2d_node_GNode.g2d_cachedMatrix.tx;
			var ty2 = com_genome2d_node_GNode.g2d_cachedMatrix.d * aabb.get_bottom() + com_genome2d_node_GNode.g2d_cachedMatrix.b * aabb.x + com_genome2d_node_GNode.g2d_cachedMatrix.ty;
			var tx3 = com_genome2d_node_GNode.g2d_cachedMatrix.a * aabb.get_right() + com_genome2d_node_GNode.g2d_cachedMatrix.c * aabb.y + com_genome2d_node_GNode.g2d_cachedMatrix.tx;
			var ty3 = com_genome2d_node_GNode.g2d_cachedMatrix.d * aabb.y + com_genome2d_node_GNode.g2d_cachedMatrix.b * aabb.get_right() + com_genome2d_node_GNode.g2d_cachedMatrix.ty;
			var tx4 = com_genome2d_node_GNode.g2d_cachedMatrix.a * aabb.get_right() + com_genome2d_node_GNode.g2d_cachedMatrix.c * aabb.get_bottom() + com_genome2d_node_GNode.g2d_cachedMatrix.tx;
			var ty4 = com_genome2d_node_GNode.g2d_cachedMatrix.d * aabb.get_bottom() + com_genome2d_node_GNode.g2d_cachedMatrix.b * aabb.get_right() + com_genome2d_node_GNode.g2d_cachedMatrix.ty;
			if(minX > tx1) minX = tx1;
			if(minX > tx2) minX = tx2;
			if(minX > tx3) minX = tx3;
			if(minX > tx4) minX = tx4;
			if(minY > ty1) minY = ty1;
			if(minY > ty2) minY = ty2;
			if(minY > ty3) minY = ty3;
			if(minY > ty4) minY = ty4;
			if(maxX < tx1) maxX = tx1;
			if(maxX < tx2) maxX = tx2;
			if(maxX < tx3) maxX = tx3;
			if(maxX < tx4) maxX = tx4;
			if(maxY < ty1) maxY = ty1;
			if(maxY < ty2) maxY = ty2;
			if(maxY < ty3) maxY = ty3;
			if(maxY < ty4) maxY = ty4;
			found = true;
		}
		var child = this.g2d_firstChild;
		while(child != null) {
			var next = child.g2d_next;
			child.getBounds(p_targetSpace,aabb);
			if(aabb.width == 0 || aabb.height == 0) {
				child = next;
				continue;
			}
			if(minX > aabb.x) minX = aabb.x;
			if(maxX < aabb.get_right()) maxX = aabb.get_right();
			if(minY > aabb.y) minY = aabb.y;
			if(maxY < aabb.get_bottom()) maxY = aabb.get_bottom();
			found = true;
			child = next;
		}
		if(found) p_bounds.setTo(minX,minY,maxX - minX,maxY - minY);
		return p_bounds;
	}
	,getCommonParent: function(p_node) {
		var current = this;
		com_genome2d_node_GNode.g2d_cachedArray = [];
		while(current != null) {
			com_genome2d_node_GNode.g2d_cachedArray.push(current);
			current = current.g2d_parent;
		}
		current = p_node;
		while(current != null && Lambda.indexOf(com_genome2d_node_GNode.g2d_cachedArray,current) == -1) current = current.g2d_parent;
		return current;
	}
	,sortChildren: function(p_nodeSorter,p_ascending) {
		if(p_ascending == null) p_ascending = true;
		if(this.g2d_firstChild == null) return;
		var insize = 1;
		var psize;
		var qsize;
		var nmerges;
		var p;
		var q;
		var e;
		while(true) {
			p = this.g2d_firstChild;
			this.g2d_firstChild = null;
			this.g2d_lastChild = null;
			nmerges = 0;
			while(p != null) {
				nmerges++;
				q = p;
				psize = 0;
				var _g = 0;
				while(_g < insize) {
					var i = _g++;
					psize++;
					q = q.g2d_next;
					if(q == null) break;
				}
				qsize = insize;
				while(psize > 0 || qsize > 0 && q != null) {
					if(psize == 0) {
						e = q;
						q = q.g2d_next;
						qsize--;
					} else if(qsize == 0 || q == null) {
						e = p;
						p = p.g2d_next;
						psize--;
					} else if(p_ascending) {
						if(p_nodeSorter.getSortValue(p) >= p_nodeSorter.getSortValue(q)) {
							e = p;
							p = p.g2d_next;
							psize--;
						} else {
							e = q;
							q = q.g2d_next;
							qsize--;
						}
					} else if(p_nodeSorter.getSortValue(p) <= p_nodeSorter.getSortValue(q)) {
						e = p;
						p = p.g2d_next;
						psize--;
					} else {
						e = q;
						q = q.g2d_next;
						qsize--;
					}
					if(this.g2d_lastChild != null) this.g2d_lastChild.g2d_next = e; else this.g2d_firstChild = e;
					e.g2d_previous = this.g2d_lastChild;
					this.g2d_lastChild = e;
				}
				p = q;
			}
			this.g2d_lastChild.g2d_next = null;
			if(nmerges <= 1) return;
			insize *= 2;
		}
	}
	,sortChildrenOnY: function(p_ascending) {
		if(p_ascending == null) p_ascending = true;
		if(this.g2d_firstChild == null) return;
		var insize = 1;
		var psize;
		var qsize;
		var nmerges;
		var p;
		var q;
		var e;
		while(true) {
			p = this.g2d_firstChild;
			this.g2d_firstChild = null;
			this.g2d_lastChild = null;
			nmerges = 0;
			while(p != null) {
				nmerges++;
				q = p;
				psize = 0;
				var _g = 0;
				while(_g < insize) {
					var i = _g++;
					psize++;
					q = q.g2d_next;
					if(q == null) break;
				}
				qsize = insize;
				while(psize > 0 || qsize > 0 && q != null) {
					if(psize == 0) {
						e = q;
						q = q.g2d_next;
						qsize--;
					} else if(qsize == 0 || q == null) {
						e = p;
						p = p.g2d_next;
						psize--;
					} else if(p_ascending) {
						if(p.g2d_localY >= q.g2d_localY) {
							e = p;
							p = p.g2d_next;
							psize--;
						} else {
							e = q;
							q = q.g2d_next;
							qsize--;
						}
					} else if(p.g2d_localY <= q.g2d_localY) {
						e = p;
						p = p.g2d_next;
						psize--;
					} else {
						e = q;
						q = q.g2d_next;
						qsize--;
					}
					if(this.g2d_lastChild != null) this.g2d_lastChild.g2d_next = e; else this.g2d_firstChild = e;
					e.g2d_previous = this.g2d_lastChild;
					this.g2d_lastChild = e;
				}
				p = q;
			}
			this.g2d_lastChild.g2d_next = null;
			if(nmerges <= 1) return;
			insize *= 2;
		}
	}
	,toString: function() {
		return "[GNode " + this.name + "]";
	}
	,get_x: function() {
		return this.g2d_localX;
	}
	,set_x: function(p_value) {
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		return this.g2d_localX = this.g2d_worldX = p_value;
	}
	,get_y: function() {
		return this.g2d_localY;
	}
	,set_y: function(p_value) {
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		return this.g2d_localY = this.g2d_worldY = p_value;
	}
	,hasUniformRotation: function() {
		return this.g2d_localScaleX != this.g2d_localScaleY && this.g2d_localRotation != 0;
	}
	,get_g2d_useMatrix: function() {
		return this.g2d_localUseMatrix;
	}
	,set_g2d_useMatrix: function(p_value) {
		if(this.g2d_parent != null) {
			var _g = this.g2d_parent;
			_g.set_g2d_useMatrix(_g.g2d_localUseMatrix + (p_value - this.g2d_localUseMatrix));
		}
		this.g2d_localUseMatrix = p_value;
		return this.g2d_localUseMatrix;
	}
	,get_scaleX: function() {
		return this.g2d_localScaleX;
	}
	,set_scaleX: function(p_value) {
		if(this.g2d_localScaleX == this.g2d_localScaleY && p_value != this.g2d_localScaleY && this.g2d_localRotation != 0 && this.g2d_childCount > 0) {
			var _g = this;
			var _g1 = _g.g2d_localUseMatrix;
			_g.set_g2d_useMatrix(_g1 + 1);
			_g1;
		}
		if(this.g2d_localScaleX == this.g2d_localScaleY && p_value == this.g2d_localScaleY && this.g2d_localRotation != 0 && this.g2d_childCount > 0) {
			var _g2 = this;
			var _g11 = _g2.g2d_localUseMatrix;
			_g2.set_g2d_useMatrix(_g11 - 1);
			_g11;
		}
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		return this.g2d_localScaleX = this.g2d_worldScaleX = p_value;
	}
	,get_scaleY: function() {
		return this.g2d_localScaleY;
	}
	,set_scaleY: function(p_value) {
		if(this.g2d_localScaleX == this.g2d_localScaleY && p_value != this.g2d_localScaleX && this.g2d_localRotation != 0 && this.g2d_childCount > 0) {
			var _g = this;
			var _g1 = _g.g2d_localUseMatrix;
			_g.set_g2d_useMatrix(_g1 + 1);
			_g1;
		}
		if(this.g2d_localScaleX == this.g2d_localScaleY && p_value == this.g2d_localScaleX && this.g2d_localRotation != 0 && this.g2d_childCount > 0) {
			var _g2 = this;
			var _g11 = _g2.g2d_localUseMatrix;
			_g2.set_g2d_useMatrix(_g11 - 1);
			_g11;
		}
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		return this.g2d_localScaleY = this.g2d_worldScaleY = p_value;
	}
	,get_rotation: function() {
		return this.g2d_localRotation;
	}
	,set_rotation: function(p_value) {
		if(this.g2d_localRotation == 0 && p_value != 0 && this.g2d_localScaleX != this.g2d_localScaleY && this.g2d_childCount > 0) {
			var _g = this;
			var _g1 = _g.g2d_localUseMatrix;
			_g.set_g2d_useMatrix(_g1 + 1);
			_g1;
		}
		if(this.g2d_localRotation != 0 && p_value == 0 && this.g2d_localScaleX != this.g2d_localScaleY && this.g2d_childCount > 0) {
			var _g2 = this;
			var _g11 = _g2.g2d_localUseMatrix;
			_g2.set_g2d_useMatrix(_g11 - 1);
			_g11;
		}
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		return this.g2d_localRotation = this.g2d_worldRotation = p_value;
	}
	,get_red: function() {
		return this.g2d_localRed;
	}
	,set_red: function(p_value) {
		this.g2d_colorDirty = true;
		return this.g2d_localRed = this.g2d_worldRed = p_value;
	}
	,get_green: function() {
		return this.g2d_localGreen;
	}
	,set_green: function(p_value) {
		this.g2d_colorDirty = true;
		return this.g2d_localGreen = this.g2d_worldGreen = p_value;
	}
	,get_blue: function() {
		return this.g2d_localBlue;
	}
	,set_blue: function(p_value) {
		this.g2d_colorDirty = true;
		return this.g2d_localBlue = this.g2d_worldBlue = p_value;
	}
	,get_alpha: function() {
		return this.g2d_localAlpha;
	}
	,set_alpha: function(p_value) {
		this.g2d_colorDirty = true;
		return this.g2d_localAlpha = this.g2d_worldAlpha = p_value;
	}
	,set_color: function(p_value) {
		this.g2d_colorDirty = true;
		this.g2d_localRed = this.g2d_worldRed = (p_value >> 16 & 255) / 255;
		this.g2d_colorDirty = true;
		this.g2d_localGreen = this.g2d_worldGreen = (p_value >> 8 & 255) / 255;
		this.g2d_colorDirty = true;
		this.g2d_localBlue = this.g2d_worldBlue = (p_value & 255) / 255;
		return p_value;
	}
	,get_matrix: function() {
		if(this.g2d_matrixDirty) {
			if(this.g2d_matrix == null) this.g2d_matrix = new com_genome2d_geom_GMatrix();
			if(this.g2d_localRotation == 0.0) this.g2d_matrix.setTo(this.g2d_localScaleX,0.0,0.0,this.g2d_localScaleY,this.g2d_localX,this.g2d_localY); else {
				var cos = Math.cos(this.g2d_localRotation);
				var sin = Math.sin(this.g2d_localRotation);
				var a = this.g2d_localScaleX * cos;
				var b = this.g2d_localScaleX * sin;
				var c = this.g2d_localScaleY * -sin;
				var d = this.g2d_localScaleY * cos;
				var tx = this.g2d_localX;
				var ty = this.g2d_localY;
				this.g2d_matrix.setTo(a,b,c,d,tx,ty);
			}
			this.g2d_matrixDirty = false;
		}
		return this.g2d_matrix;
	}
	,getTransformationMatrix: function(p_targetSpace,p_resultMatrix) {
		if(p_resultMatrix == null) p_resultMatrix = new com_genome2d_geom_GMatrix(); else p_resultMatrix.identity();
		if(p_targetSpace == this.g2d_parent) p_resultMatrix.copyFrom(this.get_matrix()); else if(p_targetSpace != this) {
			var common = this.getCommonParent(p_targetSpace);
			if(common != null) {
				var current = this;
				while(common != current) {
					p_resultMatrix.concat(current.get_matrix());
					current = current.g2d_parent;
				}
				if(common != p_targetSpace) {
					com_genome2d_node_GNode.g2d_cachedTransformMatrix.identity();
					while(p_targetSpace != common) {
						com_genome2d_node_GNode.g2d_cachedTransformMatrix.concat(p_targetSpace.get_matrix());
						p_targetSpace = p_targetSpace.g2d_parent;
					}
					com_genome2d_node_GNode.g2d_cachedTransformMatrix.invert();
					p_resultMatrix.concat(com_genome2d_node_GNode.g2d_cachedTransformMatrix);
				}
			}
		}
		return p_resultMatrix;
	}
	,localToGlobal: function(p_local,p_result) {
		this.getTransformationMatrix(com_genome2d_node_GNode.g2d_core.g2d_root,com_genome2d_node_GNode.g2d_cachedTransformMatrix);
		if(p_result == null) p_result = new com_genome2d_geom_GPoint();
		p_result.x = com_genome2d_node_GNode.g2d_cachedTransformMatrix.a * p_local.x + com_genome2d_node_GNode.g2d_cachedTransformMatrix.c * p_local.y + com_genome2d_node_GNode.g2d_cachedTransformMatrix.tx;
		p_result.y = com_genome2d_node_GNode.g2d_cachedTransformMatrix.d * p_local.y + com_genome2d_node_GNode.g2d_cachedTransformMatrix.b * p_local.x + com_genome2d_node_GNode.g2d_cachedTransformMatrix.ty;
		return p_result;
	}
	,globalToLocal: function(p_global,p_result) {
		this.getTransformationMatrix(com_genome2d_node_GNode.g2d_core.g2d_root,com_genome2d_node_GNode.g2d_cachedTransformMatrix);
		com_genome2d_node_GNode.g2d_cachedTransformMatrix.invert();
		if(p_result == null) p_result = new com_genome2d_geom_GPoint();
		p_result.x = com_genome2d_node_GNode.g2d_cachedTransformMatrix.a * p_global.x + com_genome2d_node_GNode.g2d_cachedTransformMatrix.c * p_global.y + com_genome2d_node_GNode.g2d_cachedTransformMatrix.tx;
		p_result.y = com_genome2d_node_GNode.g2d_cachedTransformMatrix.d * p_global.y + com_genome2d_node_GNode.g2d_cachedTransformMatrix.b * p_global.x + com_genome2d_node_GNode.g2d_cachedTransformMatrix.ty;
		return p_result;
	}
	,setPosition: function(p_x,p_y) {
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		this.g2d_localX = this.g2d_worldX = p_x;
		this.g2d_localY = this.g2d_worldY = p_y;
	}
	,setScale: function(p_scaleX,p_scaleY) {
		this.g2d_transformDirty = this.g2d_matrixDirty = true;
		this.g2d_localScaleX = this.g2d_worldScaleX = p_scaleX;
		this.g2d_localScaleY = this.g2d_worldScaleY = p_scaleY;
	}
	,invalidate: function(p_invalidateParentTransform,p_invalidateParentColor) {
		if(p_invalidateParentTransform && !this.useWorldSpace) {
			if(this.g2d_parent.g2d_worldRotation != 0) {
				var cos = Math.cos(this.g2d_parent.g2d_worldRotation);
				var sin = Math.sin(this.g2d_parent.g2d_worldRotation);
				this.g2d_worldX = (this.g2d_localX * cos - this.g2d_localY * sin) * this.g2d_parent.g2d_worldScaleX + this.g2d_parent.g2d_worldX;
				this.g2d_worldY = (this.g2d_localY * cos + this.g2d_localX * sin) * this.g2d_parent.g2d_worldScaleY + this.g2d_parent.g2d_worldY;
			} else {
				this.g2d_worldX = this.g2d_localX * this.g2d_parent.g2d_worldScaleX + this.g2d_parent.g2d_worldX;
				this.g2d_worldY = this.g2d_localY * this.g2d_parent.g2d_worldScaleY + this.g2d_parent.g2d_worldY;
			}
			this.g2d_worldScaleX = this.g2d_localScaleX * this.g2d_parent.g2d_worldScaleX;
			this.g2d_worldScaleY = this.g2d_localScaleY * this.g2d_parent.g2d_worldScaleY;
			this.g2d_worldRotation = this.g2d_localRotation + this.g2d_parent.g2d_worldRotation;
			this.g2d_transformDirty = false;
		}
		if(p_invalidateParentColor && !this.useWorldColor) {
			this.g2d_worldRed = this.g2d_localRed * this.g2d_parent.g2d_worldRed;
			this.g2d_worldGreen = this.g2d_localGreen * this.g2d_parent.g2d_worldGreen;
			this.g2d_worldBlue = this.g2d_localBlue * this.g2d_parent.g2d_worldBlue;
			this.g2d_worldAlpha = this.g2d_localAlpha * this.g2d_parent.g2d_worldAlpha;
			this.g2d_colorDirty = false;
		}
	}
	,render: function(p_parentTransformUpdate,p_parentColorUpdate,p_camera,p_renderAsMask,p_useMatrix) {
		if(this.g2d_active) {
			var previousMaskRect = null;
			var hasMask = false;
			if(this.maskRect != null && this.maskRect != this.g2d_parent.maskRect) {
				hasMask = true;
				if(((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().getMaskRect() == null) previousMaskRect = null; else previousMaskRect = ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().getMaskRect().clone();
				if(this.g2d_parent.maskRect != null) {
					var intersection = this.g2d_parent.maskRect.intersection(this.maskRect);
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).getContext().setMaskRect(intersection);
				} else ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().setMaskRect(this.maskRect);
			}
			var invalidateTransform = p_parentTransformUpdate || this.g2d_transformDirty;
			var invalidateColor = p_parentColorUpdate || this.g2d_colorDirty;
			if(invalidateTransform || invalidateColor) this.invalidate(p_parentTransformUpdate,p_parentColorUpdate);
			if(this.g2d_active && this.visible && ((this.cameraGroup & p_camera.mask) != 0 || this.cameraGroup == 0) && (this.g2d_usedAsMask == 0 || p_renderAsMask)) {
				if(!p_renderAsMask && this.g2d_mask != null) {
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).getContext().renderToStencil(com_genome2d_node_GNode.g2d_activeMasks.length);
					this.g2d_mask.render(true,false,p_camera,true,false);
					com_genome2d_node_GNode.g2d_activeMasks.push(this.g2d_mask);
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).getContext().renderToColor(com_genome2d_node_GNode.g2d_activeMasks.length);
				}
				var useMatrix = p_useMatrix || this.g2d_localUseMatrix > 0;
				if(useMatrix) {
					if(((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixArray.length <= ((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex) ((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) com_genome2d_node_GNode.g2d_core = (function($this) {
							var $r;
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							$r = com_genome2d_Genome2D.g2d_instance;
							return $r;
						}($this));
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixArray[((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) com_genome2d_node_GNode.g2d_core = (function($this) {
							var $r;
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							$r = com_genome2d_Genome2D.g2d_instance;
							return $r;
						}($this));
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex] = new com_genome2d_geom_GMatrix();
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixArray[((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex].copyFrom(((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrix);
					com_genome2d_geom_GMatrixUtils.prependMatrix(((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrix,this.get_matrix());
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex++;
				}
				if(this.g2d_defaultRenderable != null) this.g2d_defaultRenderable.render(p_camera,useMatrix); else if(this.g2d_renderable != null) this.g2d_renderable.render(p_camera,useMatrix);
				var child = this.g2d_firstChild;
				while(child != null) {
					var next = child.g2d_next;
					if(child.postProcess != null) child.postProcess.renderNode(invalidateTransform,invalidateColor,p_camera,child); else child.render(invalidateTransform,invalidateColor,p_camera,p_renderAsMask,useMatrix);
					child = next;
				}
				if(hasMask) ((function($this) {
					var $r;
					if(com_genome2d_node_GNode.g2d_core == null) {
						if(com_genome2d_Genome2D.g2d_instance == null) {
							com_genome2d_Genome2D.g2d_instantiable = true;
							new com_genome2d_Genome2D();
							com_genome2d_Genome2D.g2d_instantiable = false;
						}
						com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
					}
					$r = com_genome2d_node_GNode.g2d_core;
					return $r;
				}(this))).getContext().setMaskRect(previousMaskRect);
				if(!p_renderAsMask && this.g2d_mask != null) {
					com_genome2d_node_GNode.g2d_activeMasks.pop();
					if(com_genome2d_node_GNode.g2d_activeMasks.length == 0) ((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).getContext().clearStencil();
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).getContext().renderToColor(com_genome2d_node_GNode.g2d_activeMasks.length);
				}
				if(useMatrix) {
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex--;
					((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrix.copyFrom(((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixArray[((function($this) {
						var $r;
						if(com_genome2d_node_GNode.g2d_core == null) {
							if(com_genome2d_Genome2D.g2d_instance == null) {
								com_genome2d_Genome2D.g2d_instantiable = true;
								new com_genome2d_Genome2D();
								com_genome2d_Genome2D.g2d_instantiable = false;
							}
							com_genome2d_node_GNode.g2d_core = com_genome2d_Genome2D.g2d_instance;
						}
						$r = com_genome2d_node_GNode.g2d_core;
						return $r;
					}(this))).g2d_renderMatrixIndex]);
				}
			}
		}
	}
	,getPrototypeDefault: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"node");
		return p_prototype;
	}
	,bindPrototypeDefault: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,toReference: function() {
		return "";
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_node_GNode
	,__properties__: {get_matrix:"get_matrix",set_color:"set_color",set_alpha:"set_alpha",get_alpha:"get_alpha",set_blue:"set_blue",get_blue:"get_blue",set_green:"set_green",get_green:"get_green",set_red:"set_red",get_red:"get_red",set_rotation:"set_rotation",get_rotation:"get_rotation",set_scaleY:"set_scaleY",get_scaleY:"get_scaleY",set_scaleX:"set_scaleX",get_scaleX:"get_scaleX",set_g2d_useMatrix:"set_g2d_useMatrix",get_g2d_useMatrix:"get_g2d_useMatrix",set_y:"set_y",get_y:"get_y",set_x:"set_x",get_x:"get_x",get_onRemovedFromStage:"get_onRemovedFromStage",get_onAddedToStage:"get_onAddedToStage",get_childCount:"get_childCount",get_previous:"get_previous",get_next:"get_next",get_lastChild:"get_lastChild",get_firstChild:"get_firstChild",get_onMouseOut:"get_onMouseOut",get_onMouseOver:"get_onMouseOver",get_onMouseUp:"get_onMouseUp",get_onMouseClick:"get_onMouseClick",get_onMouseMove:"get_onMouseMove",get_onMouseDown:"get_onMouseDown",get_parent:"get_parent",get_id:"get_id",set_mask:"set_mask",get_mask:"get_mask",get_core:"get_core"}
};
var com_genome2d_node_GNodePool = function(p_prototype,p_maxCount,p_precacheCount) {
	if(p_precacheCount == null) p_precacheCount = 0;
	if(p_maxCount == null) p_maxCount = 0;
	this.g2d_cachedCount = 0;
	this.g2d_prototype = p_prototype;
	this.g2d_maxCount = p_maxCount;
	var _g = 0;
	while(_g < p_precacheCount) {
		var i = _g++;
		this.g2d_createNew(true);
	}
};
com_genome2d_node_GNodePool.__name__ = true;
com_genome2d_node_GNodePool.prototype = {
	getCachedCount: function() {
		return this.g2d_cachedCount;
	}
	,getNext: function() {
		var node;
		if(this.g2d_first == null || this.g2d_first.g2d_active) node = this.g2d_createNew(); else {
			node = this.g2d_first;
			this.g2d_putToBack(node);
			node.setActive(true);
		}
		return node;
	}
	,recycle: function(p_node,p_reset) {
		if(p_reset == null) p_reset = false;
		p_node.setActive(false);
		p_node.bindPrototype(this.g2d_prototype);
		this.g2d_putToFront(p_node);
	}
	,g2d_putToFront: function(p_node) {
		if(p_node == this.g2d_first) return;
		if(p_node.g2d_poolNext != null) p_node.g2d_poolNext.g2d_poolPrevious = p_node.g2d_poolPrevious;
		if(p_node.g2d_poolPrevious != null) p_node.g2d_poolPrevious.g2d_poolNext = p_node.g2d_poolNext;
		if(p_node == this.g2d_last) this.g2d_last = this.g2d_last.g2d_poolPrevious;
		if(this.g2d_first != null) this.g2d_first.g2d_poolPrevious = p_node;
		p_node.g2d_poolPrevious = null;
		p_node.g2d_poolNext = this.g2d_first;
		this.g2d_first = p_node;
	}
	,g2d_putToBack: function(p_node) {
		if(p_node == this.g2d_last) return;
		if(p_node.g2d_poolNext != null) p_node.g2d_poolNext.g2d_poolPrevious = p_node.g2d_poolPrevious;
		if(p_node.g2d_poolPrevious != null) p_node.g2d_poolPrevious.g2d_poolNext = p_node.g2d_poolNext;
		if(p_node == this.g2d_first) this.g2d_first = this.g2d_first.g2d_poolNext;
		if(this.g2d_last != null) this.g2d_last.g2d_poolNext = p_node;
		p_node.g2d_poolPrevious = this.g2d_last;
		p_node.g2d_poolNext = null;
		this.g2d_last = p_node;
	}
	,g2d_createNew: function(p_precache) {
		if(p_precache == null) p_precache = false;
		var node = null;
		if(this.g2d_maxCount == 0 || this.g2d_cachedCount < this.g2d_maxCount) {
			this.g2d_cachedCount++;
			node = com_genome2d_node_GNode.createFromPrototype(this.g2d_prototype);
			if(p_precache) node.setActive(false);
			node.g2d_pool = this;
			if(this.g2d_first == null) {
				this.g2d_first = node;
				this.g2d_last = node;
			} else {
				node.g2d_poolPrevious = this.g2d_last;
				this.g2d_last.g2d_poolNext = node;
				this.g2d_last = node;
			}
		}
		return node;
	}
	,dispose: function() {
		while(this.g2d_first != null) {
			var next = this.g2d_first.g2d_poolNext;
			this.g2d_first.dispose();
			this.g2d_first = next;
		}
	}
	,__class__: com_genome2d_node_GNodePool
};
var com_genome2d_node_IGNodeSorter = function() { };
com_genome2d_node_IGNodeSorter.__name__ = true;
com_genome2d_node_IGNodeSorter.prototype = {
	__class__: com_genome2d_node_IGNodeSorter
};
var com_genome2d_particles_GEmitter = function(p_particlePool) {
	this.g2d_moduleCount = 0;
	this.g2d_accumulatedEmission = 0;
	this.g2d_accumulatedSecond = 0;
	this.g2d_accumulatedTime = 0;
	this.delayVariance = 0;
	this.delay = 0;
	this.loop = false;
	this.g2d_currentDuration = -1;
	this.durationVariance = 0;
	this.duration = 0;
	this.emit = true;
	this.y = 0;
	this.x = 0;
	this.useWorldSpace = true;
	if(p_particlePool == null) this.g2d_particlePool = com_genome2d_particles_GNewParticlePool.g2d_defaultPool; else this.g2d_particlePool = p_particlePool;
	this.g2d_modules = [];
};
com_genome2d_particles_GEmitter.__name__ = true;
com_genome2d_particles_GEmitter.prototype = {
	getParticleSystem: function() {
		return this.g2d_particleSystem;
	}
	,addModule: function(p_module) {
		this.g2d_moduleCount = this.g2d_modules.push(p_module);
	}
	,removeModule: function(p_module) {
		if(HxOverrides.remove(this.g2d_modules,p_module)) this.g2d_moduleCount--;
	}
	,update: function(p_deltaTime) {
		if(this.g2d_currentDuration == -1) this.g2d_currentDuration = this.duration + Math.random() * this.durationVariance;
		this.g2d_accumulatedTime += p_deltaTime * .001;
		if(this.g2d_accumulatedTime > this.g2d_currentDuration && this.loop) this.g2d_accumulatedTime -= this.g2d_currentDuration;
		this.g2d_doEmission(p_deltaTime);
		var updateModules = [];
		var _g = 0;
		var _g1 = this.g2d_modules;
		while(_g < _g1.length) {
			var module = _g1[_g];
			++_g;
			if(module.updateModule) updateModules.push(module);
		}
		var particle = this.g2d_firstParticle;
		if(particle != null && (particle.implementUpdate || updateModules.length > 0)) while(particle != null) {
			var next = particle.g2d_next;
			if(particle.implementUpdate) particle.g2d_update(this,p_deltaTime);
			var _g2 = 0;
			while(_g2 < updateModules.length) {
				var module1 = updateModules[_g2];
				++_g2;
				if(module1.updateModule) module1.update(this,particle,p_deltaTime);
			}
			particle = next;
		}
		var particle1 = this.g2d_firstParticle;
		while(particle1 != null) {
			var next1 = particle1.g2d_next;
			if(particle1.die) {
				if(particle1 == this.g2d_lastParticle) this.g2d_lastParticle = this.g2d_lastParticle.g2d_previous;
				if(particle1 == this.g2d_firstParticle) this.g2d_firstParticle = this.g2d_firstParticle.g2d_next;
				particle1.g2d_dispose();
			}
			particle1 = next1;
		}
	}
	,g2d_doEmission: function(p_deltaTime) {
		if(this.emit) {
			if(this.g2d_accumulatedTime > this.g2d_currentDuration) this.emit = false; else {
				if(this.rate != null) {
					var currentRate = this.rate.calculate(this.g2d_accumulatedTime / this.g2d_currentDuration);
					this.g2d_accumulatedEmission += currentRate * p_deltaTime * .001;
				}
				if(this.burstDistribution != null) {
					var _g1 = 0;
					var _g = this.burstDistribution.length >> 1;
					while(_g1 < _g) {
						var i = _g1++;
						var time = this.burstDistribution[2 * i];
						if(time > this.g2d_accumulatedTime - p_deltaTime * .001 && time < this.g2d_accumulatedTime) this.g2d_accumulatedEmission += this.burstDistribution[2 * i + 1];
					}
				}
			}
		}
		while(this.g2d_accumulatedEmission >= 1) {
			this.spawnParticle();
			this.g2d_accumulatedEmission--;
		}
	}
	,render: function(p_context,p_x,p_y,p_scaleX,p_scaleY,p_red,p_green,p_blue,p_alpha) {
		var particle = this.g2d_firstParticle;
		var tx;
		if(this.useWorldSpace) tx = 0; else tx = p_x + this.x * p_scaleX;
		var ty;
		if(this.useWorldSpace) ty = 0; else ty = p_y + this.y * p_scaleY;
		while(particle != null) {
			var next = particle.g2d_next;
			if(particle.implementRender) particle.g2d_render(p_context,this,tx,ty,p_scaleX,p_scaleY,p_red,p_green,p_blue,p_alpha); else p_context.draw(particle.texture,particle.x,particle.y,particle.scaleX,particle.scaleY,particle.rotation,particle.red,particle.green,particle.blue,particle.alpha,this.blendMode,null);
			particle = next;
		}
	}
	,spawnParticle: function() {
		var particle = this.g2d_particlePool.g2d_get();
		if(this.g2d_lastParticle != null) {
			particle.g2d_previous = this.g2d_lastParticle;
			this.g2d_lastParticle.g2d_next = particle;
			this.g2d_lastParticle = particle;
		} else {
			this.g2d_firstParticle = particle;
			this.g2d_lastParticle = particle;
		}
		particle.g2d_spawn(this);
		var _g = 0;
		var _g1 = this.g2d_modules;
		while(_g < _g1.length) {
			var module = _g1[_g];
			++_g;
			if(module.spawnModule) module.spawn(this,particle);
		}
	}
	,disposeParticle: function(p_particle) {
		if(p_particle == this.g2d_lastParticle) this.g2d_lastParticle = this.g2d_lastParticle.g2d_previous;
		if(p_particle == this.g2d_firstParticle) this.g2d_firstParticle = this.g2d_firstParticle.g2d_next;
		p_particle.g2d_dispose();
	}
	,__class__: com_genome2d_particles_GEmitter
};
var com_genome2d_particles_GNewParticle = function(p_pool) {
	this.index = 0;
	this.die = false;
	this.accumulatedEnergy = 0;
	this.totalEnergy = 0;
	this.velocityY = 0;
	this.velocityX = 0;
	this.alpha = 1;
	this.blue = 1;
	this.green = 1;
	this.red = 1;
	this.rotation = 0;
	this.y = 0;
	this.x = 0;
	this.implementRender = false;
	this.implementUpdate = false;
	this.vy = 0;
	this.vx = 0;
	this.type = 0;
	this.densityNear = 0;
	this.density = 0;
	this.gy = 0;
	this.gx = 0;
	this.viscosity = .1;
	this.fy = 0;
	this.fx = 0;
	this.g2d_pool = p_pool;
	this.index = this.g2d_pool.g2d_count;
};
com_genome2d_particles_GNewParticle.__name__ = true;
com_genome2d_particles_GNewParticle.prototype = {
	get_previous: function() {
		return this.g2d_previous;
	}
	,g2d_spawn: function(p_emitter) {
		this.fx = this.fy = this.vx = this.vy = 0;
		this.texture = p_emitter.texture;
		this.x = p_emitter.x;
		this.y = p_emitter.y;
		this.scaleX = this.scaleY = 1;
		this.rotation = 0;
		this.velocityX = 0;
		this.velocityY = 0;
		this.totalEnergy = 0;
		this.accumulatedEnergy = 0;
		this.red = 1;
		this.green = 1;
		this.blue = 1;
		this.alpha = 1;
		this.accumulatedTime = 0;
		this.currentFrame = 0;
	}
	,g2d_update: function(p_emitter,p_deltaTime) {
	}
	,g2d_render: function(p_context,p_emitter,p_x,p_y,p_scaleX,p_scaleY,p_red,p_green,p_blue,p_alpha) {
	}
	,g2d_dispose: function() {
		this.die = false;
		if(this.g2d_next != null) this.g2d_next.g2d_previous = this.g2d_previous;
		if(this.g2d_previous != null) this.g2d_previous.g2d_next = this.g2d_next;
		this.g2d_next = null;
		this.g2d_previous = null;
		this.g2d_nextAvailableInstance = this.g2d_pool.g2d_availableInstance;
		this.g2d_pool.g2d_availableInstance = this;
	}
	,__class__: com_genome2d_particles_GNewParticle
	,__properties__: {get_previous:"get_previous"}
};
var com_genome2d_particles_GNewParticlePool = function(p_particleClass) {
	this.g2d_count = 0;
	if(p_particleClass == null) this.g2d_particleClass = com_genome2d_particles_GNewParticle; else this.g2d_particleClass = p_particleClass;
};
com_genome2d_particles_GNewParticlePool.__name__ = true;
com_genome2d_particles_GNewParticlePool.prototype = {
	precache: function(p_precacheCount) {
		if(p_precacheCount < this.g2d_count) return;
		var precached = this.g2d_get();
		while(this.g2d_count < p_precacheCount) {
			var n = this.g2d_get();
			n.g2d_previous = precached;
			precached = n;
		}
		while(precached != null) {
			var d = precached;
			precached = d.g2d_previous;
			d.g2d_dispose();
		}
	}
	,g2d_get: function() {
		var instance = this.g2d_availableInstance;
		if(instance != null) {
			this.g2d_availableInstance = instance.g2d_nextAvailableInstance;
			instance.g2d_nextAvailableInstance = null;
		} else {
			instance = Type.createInstance(this.g2d_particleClass,[this]);
			this.g2d_count++;
		}
		return instance;
	}
	,__class__: com_genome2d_particles_GNewParticlePool
};
var com_genome2d_particles_GParticle = function(p_pool) {
	this.index = 0;
	this.die = false;
	this.overrideUvs = false;
	this.accumulatedEnergy = 0;
	this.totalEnergy = 0;
	this.velocityY = 0;
	this.velocityX = 0;
	this.alpha = 1;
	this.blue = 1;
	this.green = 1;
	this.red = 1;
	this.rotation = 0;
	this.y = 0;
	this.x = 0;
	this.overrideRender = false;
	this.g2d_pool = p_pool;
	this.index = this.g2d_pool.g2d_count;
};
com_genome2d_particles_GParticle.__name__ = true;
com_genome2d_particles_GParticle.prototype = {
	get_previous: function() {
		return this.g2d_previous;
	}
	,spawn: function(p_particleSystem) {
		this.texture = p_particleSystem.texture;
		this.x = p_particleSystem.g2d_node.g2d_worldX;
		this.y = p_particleSystem.g2d_node.g2d_worldY;
		this.scaleX = this.scaleY = 1;
		this.rotation = 0;
		this.velocityX = 0;
		this.velocityY = 0;
		this.totalEnergy = 0;
		this.accumulatedEnergy = 0;
		this.red = 1;
		this.green = 1;
		this.blue = 1;
		this.alpha = 1;
		this.accumulatedTime = 0;
		this.currentFrame = 0;
	}
	,dispose: function() {
		this.die = false;
		if(this.g2d_next != null) this.g2d_next.g2d_previous = this.g2d_previous;
		if(this.g2d_previous != null) this.g2d_previous.g2d_next = this.g2d_next;
		this.g2d_next = null;
		this.g2d_previous = null;
		this.g2d_nextAvailableInstance = this.g2d_pool.g2d_availableInstance;
		this.g2d_pool.g2d_availableInstance = this;
	}
	,render: function(p_camera,p_particleSystem) {
	}
	,__class__: com_genome2d_particles_GParticle
	,__properties__: {get_previous:"get_previous"}
};
var com_genome2d_particles_GParticlePool = function(p_particleClass) {
	this.g2d_count = 0;
	if(p_particleClass == null) this.g2d_particleClass = com_genome2d_particles_GParticle; else this.g2d_particleClass = p_particleClass;
};
com_genome2d_particles_GParticlePool.__name__ = true;
com_genome2d_particles_GParticlePool.prototype = {
	precache: function(p_precacheCount) {
		if(p_precacheCount < this.g2d_count) return;
		var precached = this.g2d_get();
		while(this.g2d_count < p_precacheCount) {
			var n = this.g2d_get();
			n.g2d_previous = precached;
			precached = n;
		}
		while(precached != null) {
			var d = precached;
			precached = d.g2d_previous;
			d.dispose();
		}
	}
	,g2d_get: function() {
		var instance = this.g2d_availableInstance;
		if(instance != null) {
			this.g2d_availableInstance = instance.g2d_nextAvailableInstance;
			instance.g2d_nextAvailableInstance = null;
		} else {
			instance = Type.createInstance(this.g2d_particleClass,[this]);
			this.g2d_count++;
		}
		return instance;
	}
	,__class__: com_genome2d_particles_GParticlePool
};
var com_genome2d_particles_GParticleSystem = function() {
	this.g2d_emitterCount = 0;
	this.timeDilation = 1;
	this.g2d_emitters = [];
};
com_genome2d_particles_GParticleSystem.__name__ = true;
com_genome2d_particles_GParticleSystem.prototype = {
	addEmitter: function(p_emitter) {
		p_emitter.g2d_particleSystem = this;
		this.g2d_emitterCount = this.g2d_emitters.push(p_emitter);
	}
	,removeEmitter: function(p_emitter) {
		if(HxOverrides.remove(this.g2d_emitters,p_emitter)) {
			p_emitter.g2d_particleSystem = null;
			this.g2d_emitterCount--;
		}
	}
	,getEmitter: function(p_emitterIndex) {
		if(p_emitterIndex < this.g2d_emitterCount) return this.g2d_emitters[p_emitterIndex]; else return null;
	}
	,update: function(p_deltaTime) {
		p_deltaTime *= this.timeDilation;
		var _g = 0;
		var _g1 = this.g2d_emitters;
		while(_g < _g1.length) {
			var emitter = _g1[_g];
			++_g;
			emitter.update(p_deltaTime);
		}
	}
	,render: function(p_context,p_x,p_y,p_scaleX,p_scaleY,p_red,p_green,p_blue,p_alpha) {
		var _g = 0;
		var _g1 = this.g2d_emitters;
		while(_g < _g1.length) {
			var emitter = _g1[_g];
			++_g;
			emitter.render(p_context,p_x,p_y,p_scaleX,p_scaleY,p_red,p_green,p_blue,p_alpha);
		}
	}
	,dispose: function() {
	}
	,__class__: com_genome2d_particles_GParticleSystem
};
var com_genome2d_particles_GSPHParticleSystem = function(p_precacheNeighbors) {
	if(p_precacheNeighbors == null) p_precacheNeighbors = 0;
	this.g2d_gridHeightCount = 0;
	this.g2d_gridWidthCount = 0;
	this.g2d_gridCellSize = 20;
	com_genome2d_particles_GParticleSystem.call(this);
	this.g2d_neighbors = [];
	this.g2d_neighborPrecacheCount = p_precacheNeighbors;
	var _g1 = 0;
	var _g = this.g2d_neighborPrecacheCount;
	while(_g1 < _g) {
		var i = _g1++;
		this.g2d_neighbors.push(new com_genome2d_particles_GSPHNeighbor());
	}
	this.g2d_neighborCount = 0;
};
com_genome2d_particles_GSPHParticleSystem.__name__ = true;
com_genome2d_particles_GSPHParticleSystem.__super__ = com_genome2d_particles_GParticleSystem;
com_genome2d_particles_GSPHParticleSystem.prototype = $extend(com_genome2d_particles_GParticleSystem.prototype,{
	setRegion: function(p_region) {
		this.g2d_width = p_region.width;
		this.g2d_height = p_region.height;
		this.g2d_gridWidthCount = Math.ceil(p_region.width / this.g2d_gridCellSize);
		this.g2d_gridHeightCount = Math.ceil(p_region.height / this.g2d_gridCellSize);
		this.g2d_invertedGridCellSize = 1 / this.g2d_gridCellSize;
		this.g2d_grids = [];
		var _g1 = 0;
		var _g = this.g2d_gridWidthCount;
		while(_g1 < _g) {
			var i = _g1++;
			this.g2d_grids.push([]);
			var _g3 = 0;
			var _g2 = this.g2d_gridHeightCount;
			while(_g3 < _g2) {
				var j = _g3++;
				this.g2d_grids[i].push(new com_genome2d_particles_GSPHGrid());
			}
		}
	}
	,update: function(p_deltaTime) {
		this.g2d_updateGrids();
		this.g2d_findNeighbors();
		var _g1 = 0;
		var _g = this.g2d_neighborCount;
		while(_g1 < _g) {
			var i = _g1++;
			this.g2d_neighbors[i].calculateForce();
		}
		com_genome2d_particles_GParticleSystem.prototype.update.call(this,p_deltaTime);
	}
	,g2d_updateGrids: function() {
		var _g1 = 0;
		var _g = this.g2d_gridWidthCount;
		while(_g1 < _g) {
			var i = _g1++;
			var _g3 = 0;
			var _g2 = this.g2d_gridHeightCount;
			while(_g3 < _g2) {
				var j = _g3++;
				this.g2d_grids[i][j].particleCount = 0;
			}
		}
		var _g4 = 0;
		var _g11 = this.g2d_emitters;
		while(_g4 < _g11.length) {
			var emitter = _g11[_g4];
			++_g4;
			var particle = emitter.g2d_firstParticle;
			while(particle != null) {
				var next = particle.g2d_next;
				particle.fx = particle.fy = particle.density = particle.densityNear = 0;
				particle.gx = particle.x * this.g2d_invertedGridCellSize | 0;
				particle.gy = particle.y * this.g2d_invertedGridCellSize | 0;
				if(particle.gx < 0) particle.gx = 0; else if(particle.gx > this.g2d_gridWidthCount - 1) particle.gx = this.g2d_gridWidthCount - 1;
				if(particle.gy < 0) particle.gy = 0; else if(particle.gy > this.g2d_gridHeightCount - 1) particle.gy = this.g2d_gridHeightCount - 1;
				particle = next;
			}
		}
	}
	,g2d_findNeighbors: function() {
		this.g2d_neighborCount = 0;
		var _g = 0;
		var _g1 = this.g2d_emitters;
		while(_g < _g1.length) {
			var emitter = _g1[_g];
			++_g;
			var particle = emitter.g2d_firstParticle;
			while(particle != null) {
				var next = particle.g2d_next;
				if(!particle.die) {
					var minX = particle.gx != 0;
					var maxX = particle.gx != this.g2d_gridWidthCount - 1;
					var minY = particle.gy != 0;
					var maxY = particle.gy != this.g2d_gridHeightCount - 1;
					this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx][particle.gy]);
					if(minX) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx - 1][particle.gy]);
					if(maxX) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx + 1][particle.gy]);
					if(minY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx][particle.gy - 1]);
					if(maxY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx][particle.gy + 1]);
					if(minX && minY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx - 1][particle.gy - 1]);
					if(minX && maxY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx - 1][particle.gy + 1]);
					if(maxX && minY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx + 1][particle.gy - 1]);
					if(maxX && maxY) this.g2d_findNeighborsInGrid(particle,this.g2d_grids[particle.gx + 1][particle.gy + 1]);
					this.g2d_grids[particle.gx][particle.gy].addParticle(particle);
				}
				particle = next;
			}
		}
	}
	,g2d_findNeighborsInGrid: function(p_particle1,p_grid) {
		var _g = 0;
		var _g1 = p_grid.particles;
		while(_g < _g1.length) {
			var particle = _g1[_g];
			++_g;
			var distance = (p_particle1.x - particle.x) * (p_particle1.x - particle.x) + (p_particle1.y - particle.y) * (p_particle1.y - particle.y);
			if(distance < 256.) {
				if(this.g2d_neighborPrecacheCount == this.g2d_neighborCount) {
					this.g2d_neighbors[this.g2d_neighborCount] = new com_genome2d_particles_GSPHNeighbor();
					this.g2d_neighborPrecacheCount++;
				}
				this.g2d_neighbors[this.g2d_neighborCount++].setParticles(p_particle1,particle);
			}
		}
	}
	,__class__: com_genome2d_particles_GSPHParticleSystem
});
var com_genome2d_particles_GSPHNeighbor = function() {
	this.density = 2;
	this.NEAR_PRESSURE = 1;
	this.PRESSURE = 1;
	this.RANGE = 16;
};
com_genome2d_particles_GSPHNeighbor.__name__ = true;
com_genome2d_particles_GSPHNeighbor.prototype = {
	setParticles: function(p_particle1,p_particle2) {
		this.particle1 = p_particle1;
		this.particle2 = p_particle2;
		this.nx = this.particle1.x - this.particle2.x;
		this.ny = this.particle1.y - this.particle2.y;
		this.distance = Math.sqrt(this.nx * this.nx + this.ny * this.ny);
		var invDistance = 1 / this.distance;
		this.nx *= invDistance;
		this.ny *= invDistance;
		this.weight = 1 - this.distance / this.RANGE;
		var density = this.weight * this.weight;
		this.particle1.density += density;
		this.particle2.density += density;
		density *= this.weight * this.NEAR_PRESSURE;
		this.particle1.densityNear += density;
		this.particle2.densityNear += density;
	}
	,calculateForce: function() {
		var p;
		if(this.particle1.type != this.particle2.type) p = (this.particle1.density + this.particle2.density - this.density * 1.5) * this.PRESSURE; else p = (this.particle1.density + this.particle2.density - this.density * 2) * this.PRESSURE;
		var np = (this.particle1.densityNear + this.particle2.densityNear) * this.NEAR_PRESSURE;
		var pressureWeight = this.weight * (p + this.weight * np);
		var fx = this.nx * pressureWeight;
		var fy = this.ny * pressureWeight;
		var fax = (this.particle2.vx - this.particle1.vx) * this.weight;
		var fay = (this.particle2.vy - this.particle1.vy) * this.weight;
		this.particle1.fx += fx + fax * this.particle2.viscosity;
		this.particle1.fy += fy + fay * this.particle2.viscosity;
		this.particle2.fx -= fx + fax * this.particle1.viscosity;
		this.particle2.fy -= fy + fay * this.particle1.viscosity;
	}
	,__class__: com_genome2d_particles_GSPHNeighbor
};
var com_genome2d_particles_GSPHGrid = function() {
	this.particles = [];
};
com_genome2d_particles_GSPHGrid.__name__ = true;
com_genome2d_particles_GSPHGrid.prototype = {
	addParticle: function(p_particle) {
		this.particles[this.particleCount++] = p_particle;
	}
	,__class__: com_genome2d_particles_GSPHGrid
};
var com_genome2d_particles_IGAffector = function() { };
com_genome2d_particles_IGAffector.__name__ = true;
com_genome2d_particles_IGAffector.prototype = {
	__class__: com_genome2d_particles_IGAffector
};
var com_genome2d_particles_IGInitializer = function() { };
com_genome2d_particles_IGInitializer.__name__ = true;
com_genome2d_particles_IGInitializer.prototype = {
	__class__: com_genome2d_particles_IGInitializer
};
var com_genome2d_postprocess_GPostProcess = function(p_passes,p_filters) {
	if(p_passes == null) p_passes = 1;
	this.g2d_bottomMargin = 0;
	this.g2d_topMargin = 0;
	this.g2d_rightMargin = 0;
	this.g2d_leftMargin = 0;
	this.g2d_passes = 1;
	this.g2d_id = Std.string(com_genome2d_postprocess_GPostProcess.g2d_count++);
	if(p_passes < 1) com_genome2d_debug_GDebug.error("There are no passes.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPostProcess.hx", lineNumber : 46, className : "com.genome2d.postprocess.GPostProcess", methodName : "new"});
	this.g2d_passes = p_passes;
	this.g2d_matrix = new com_genome2d_geom_GMatrix3D();
	this.g2d_passFilters = p_filters;
	this.g2d_passTextures = [];
	var _g1 = 0;
	var _g = this.g2d_passes;
	while(_g1 < _g) {
		var i = _g1++;
		this.g2d_passTextures.push(null);
	}
	this.createPassTextures();
};
com_genome2d_postprocess_GPostProcess.__name__ = true;
com_genome2d_postprocess_GPostProcess.prototype = {
	getPassCount: function() {
		return this.g2d_passes;
	}
	,setBounds: function(p_bounds) {
		this.g2d_definedBounds = p_bounds;
	}
	,setMargins: function(p_leftMargin,p_rightMargin,p_topMargin,p_bottomMargin) {
		if(p_bottomMargin == null) p_bottomMargin = 0;
		if(p_topMargin == null) p_topMargin = 0;
		if(p_rightMargin == null) p_rightMargin = 0;
		if(p_leftMargin == null) p_leftMargin = 0;
		this.g2d_leftMargin = p_leftMargin;
		this.g2d_rightMargin = p_rightMargin;
		this.g2d_topMargin = p_topMargin;
		this.g2d_bottomMargin = p_bottomMargin;
	}
	,render: function(p_source,p_x,p_y,p_bounds,p_target) {
		var bounds;
		if(p_bounds == null) bounds = this.g2d_definedBounds; else bounds = p_bounds;
		if(bounds.width > 4096) return;
		this.updatePassTextures(bounds);
		var context = ((function($this) {
			var $r;
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			$r = com_genome2d_Genome2D.g2d_instance;
			return $r;
		}(this))).getContext();
		if(p_target == null) com_genome2d_utils_GRenderTargetStack.pushRenderTarget(context.getRenderTarget(),context.getRenderTargetMatrix());
		if(p_source == null) com_genome2d_debug_GDebug.error("Invalid source for post process.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPostProcess.hx", lineNumber : 81, className : "com.genome2d.postprocess.GPostProcess", methodName : "render"});
		this.g2d_matrix.identity();
		this.g2d_matrix.prependTranslation(-bounds.x + this.g2d_leftMargin,-bounds.y + this.g2d_topMargin,0);
		context.setRenderTarget(this.g2d_passTextures[0],this.g2d_matrix,true);
		context.setBlendMode(1,p_source.premultiplied);
		context.setRenderer(context.g2d_drawRenderer);
		context.g2d_drawRenderer.draw(p_x,p_y,1,1,0,1,1,1,1,p_source);
		var zero = this.g2d_passTextures[0];
		var _g1 = 1;
		var _g = this.g2d_passes;
		while(_g1 < _g) {
			var i = _g1++;
			context.setRenderTarget(this.g2d_passTextures[i],null,true);
			context.draw(this.g2d_passTextures[i - 1],0,0,1,1,0,1,1,1,1,1,this.g2d_passFilters[i - 1]);
		}
		if(p_target == null) {
			com_genome2d_utils_GRenderTargetStack.popRenderTarget(context);
			context.draw(this.g2d_passTextures[this.g2d_passes - 1],bounds.x - this.g2d_leftMargin,bounds.y - this.g2d_topMargin,1,1,0,1,1,1,1,1,this.g2d_passFilters[this.g2d_passes - 1]);
		} else {
			context.setRenderTarget(p_target);
			context.draw(this.g2d_passTextures[this.g2d_passes - 1],0,0,1,1,0,1,1,1,1,1,this.g2d_passFilters[this.g2d_passes - 1]);
		}
		this.g2d_passTextures[0] = zero;
	}
	,renderNode: function(p_parentTransformUpdate,p_parentColorUpdate,p_camera,p_node,p_bounds,p_source,p_target) {
		var bounds = p_bounds;
		if(bounds == null) if(this.g2d_definedBounds != null) bounds = this.g2d_definedBounds; else bounds = p_node.getBounds(null,this.g2d_activeBounds);
		if(bounds.width > 4096) return;
		this.updatePassTextures(bounds);
		var context = ((function($this) {
			var $r;
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			$r = com_genome2d_Genome2D.g2d_instance;
			return $r;
		}(this))).getContext();
		com_genome2d_utils_GRenderTargetStack.pushRenderTarget(context.getRenderTarget(),context.getRenderTargetMatrix());
		if(p_source == null) {
			this.g2d_matrix.identity();
			this.g2d_matrix.prependTranslation(-bounds.x + this.g2d_leftMargin,-bounds.y + this.g2d_topMargin,0);
			context.setRenderTarget(this.g2d_passTextures[0],this.g2d_matrix,true);
			p_node.render(true,true,p_camera,false,false);
		}
		var zero = this.g2d_passTextures[0];
		if(p_source != null) this.g2d_passTextures[0] = p_source;
		var _g1 = 1;
		var _g = this.g2d_passes;
		while(_g1 < _g) {
			var i = _g1++;
			context.setRenderTarget(this.g2d_passTextures[i],null,true);
			context.draw(this.g2d_passTextures[i - 1],0,0,1,1,0,1,1,1,1,1,this.g2d_passFilters[i - 1]);
		}
		if(p_target == null) {
			com_genome2d_utils_GRenderTargetStack.popRenderTarget(context);
			if(context.getRenderTarget() == null) context.setActiveCamera(p_camera);
			context.draw(this.g2d_passTextures[this.g2d_passes - 1],bounds.x - this.g2d_leftMargin,bounds.y - this.g2d_topMargin,1,1,0,1,1,1,1,1,this.g2d_passFilters[this.g2d_passes - 1]);
		} else {
			context.setRenderTarget(p_target);
			context.draw(this.g2d_passTextures[this.g2d_passes - 1],0,0,1,1,0,1,1,1,1,1,this.g2d_passFilters[this.g2d_passes - 1]);
		}
		this.g2d_passTextures[0] = zero;
	}
	,getPassTexture: function(p_pass) {
		return this.g2d_passTextures[p_pass];
	}
	,getPassFilter: function(p_pass) {
		return this.g2d_passFilters[p_pass];
	}
	,updatePassTextures: function(p_bounds) {
		var w = p_bounds.width + this.g2d_leftMargin + this.g2d_rightMargin | 0;
		var h = p_bounds.height + this.g2d_topMargin + this.g2d_bottomMargin | 0;
		if((this.g2d_passTextures[0].get_width() != w || this.g2d_passTextures[0].get_height() != h) && w > 0 && h > 0) {
			var i = this.g2d_passTextures.length - 1;
			while(i >= 0) {
				var texture = this.g2d_passTextures[i];
				texture.set_region(new com_genome2d_geom_GRectangle(0,0,w,h));
				texture.g2d_pivotX = -(texture.g2d_nativeWidth * texture.g2d_scaleFactor) / 2 / texture.g2d_scaleFactor;
				texture.g2d_pivotY = -(texture.g2d_nativeHeight * texture.g2d_scaleFactor) / 2 / texture.g2d_scaleFactor;
				texture.invalidateNativeTexture(true);
				i--;
			}
		}
	}
	,createPassTextures: function() {
		var _g1 = 0;
		var _g = this.g2d_passes;
		while(_g1 < _g) {
			var i = _g1++;
			var texture = com_genome2d_textures_GTextureManager.createRenderTexture("g2d_pp_" + this.g2d_id + "_" + i,2,2);
			texture.g2d_filteringType = 0;
			texture.g2d_pivotX = -(texture.g2d_nativeWidth * texture.g2d_scaleFactor) / 2 / texture.g2d_scaleFactor;
			texture.g2d_pivotY = -(texture.g2d_nativeHeight * texture.g2d_scaleFactor) / 2 / texture.g2d_scaleFactor;
			this.g2d_passTextures[i] = texture;
		}
	}
	,dispose: function() {
		var i = this.g2d_passTextures.length - 1;
		while(i >= 0) {
			this.g2d_passTextures[i].dispose();
			i--;
		}
	}
	,__class__: com_genome2d_postprocess_GPostProcess
};
var com_genome2d_proto_GPropertyState = function(p_name,p_value,p_extras,p_transition) {
	this.g2d_name = p_name;
	this.g2d_value = p_value;
	this.g2d_extras = p_extras;
	this.g2d_transition = p_transition;
};
com_genome2d_proto_GPropertyState.__name__ = true;
com_genome2d_proto_GPropertyState.prototype = {
	bind: function(p_instance) {
		if(this.g2d_transition != "") {
			var transition = com_genome2d_transitions_GTransitionManager.getTransition(this.g2d_transition);
			if(transition != null && (this.g2d_extras & 1) == 0) transition.apply(p_instance,this.g2d_name,this.g2d_value); else if((this.g2d_extras & 1) != 0) Reflect.callMethod(p_instance,Reflect.field(p_instance,this.g2d_name),[this.g2d_value]); else Reflect.setProperty(p_instance,this.g2d_name,this.g2d_value);
		} else if((this.g2d_extras & 1) != 0) Reflect.callMethod(p_instance,Reflect.field(p_instance,this.g2d_name),[this.g2d_value]); else Reflect.setProperty(p_instance,this.g2d_name,this.g2d_value);
	}
	,__class__: com_genome2d_proto_GPropertyState
};
var com_genome2d_proto_GPrototype = function() {
	this.properties = new haxe_ds_StringMap();
	this.children = new haxe_ds_StringMap();
};
com_genome2d_proto_GPrototype.__name__ = true;
com_genome2d_proto_GPrototype.fromXml = function(p_xml) {
	if(p_xml.nodeType == Xml.Document) p_xml = p_xml.firstElement();
	var prototype = new com_genome2d_proto_GPrototype();
	if(p_xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + p_xml.nodeType);
	prototype.prototypeName = p_xml.nodeName;
	prototype.prototypeClass = com_genome2d_proto_GPrototypeFactory.getPrototypeClass(prototype.prototypeName);
	var propertyNames = Reflect.field(prototype.prototypeClass,"PROTOTYPE_PROPERTY_NAMES");
	var propertyDefaults = Reflect.field(prototype.prototypeClass,"PROTOTYPE_PROPERTY_DEFAULTS");
	var propertyTypes = Reflect.field(prototype.prototypeClass,"PROTOTYPE_PROPERTY_TYPES");
	var propertyExtras = Reflect.field(prototype.prototypeClass,"PROTOTYPE_PROPERTY_EXTRAS");
	var defaultChildGroup = Reflect.field(prototype.prototypeClass,"PROTOTYPE_DEFAULT_CHILD_GROUP");
	var $it0 = p_xml.attributes();
	while( $it0.hasNext() ) {
		var attribute = $it0.next();
		prototype.setPropertyFromString(attribute,p_xml.get(attribute));
	}
	var $it1 = p_xml.elements();
	while( $it1.hasNext() ) {
		var element = $it1.next();
		if(((function($this) {
			var $r;
			if(element.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + element.nodeType);
			$r = element.nodeName;
			return $r;
		}(this))).indexOf("p:") == 0) prototype.setPropertyFromXml((function($this) {
			var $r;
			var _this;
			{
				if(element.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + element.nodeType);
				_this = element.nodeName;
			}
			$r = HxOverrides.substr(_this,2,null);
			return $r;
		}(this)),element.firstElement()); else if((function($this) {
			var $r;
			if(element.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + element.nodeType);
			$r = element.nodeName;
			return $r;
		}(this)) == defaultChildGroup) prototype.addChild(com_genome2d_proto_GPrototype.fromXml(element),defaultChildGroup); else {
			var $it2 = element.elements();
			while( $it2.hasNext() ) {
				var child = $it2.next();
				prototype.addChild(com_genome2d_proto_GPrototype.fromXml(child),(function($this) {
					var $r;
					if(element.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + element.nodeType);
					$r = element.nodeName;
					return $r;
				}(this)));
			}
		}
	}
	return prototype;
};
com_genome2d_proto_GPrototype.prototype = {
	process: function(p_instance,p_prototypeName) {
		var currentPrototypeClass = com_genome2d_proto_GPrototypeFactory.getPrototypeClass(p_prototypeName);
		if(this.prototypeClass == null) {
			this.prototypeName = p_prototypeName;
			this.prototypeClass = currentPrototypeClass;
		}
		var propertyNames = Reflect.field(currentPrototypeClass,"PROTOTYPE_PROPERTY_NAMES");
		var propertyDefaults = Reflect.field(currentPrototypeClass,"PROTOTYPE_PROPERTY_DEFAULTS");
		var propertyTypes = Reflect.field(currentPrototypeClass,"PROTOTYPE_PROPERTY_TYPES");
		var propertyExtras = Reflect.field(currentPrototypeClass,"PROTOTYPE_PROPERTY_EXTRAS");
		var _g1 = 0;
		var _g = propertyNames.length;
		while(_g1 < _g) {
			var i = _g1++;
			var name = propertyNames[i];
			var extras = propertyExtras[i];
			if((extras & 1) == 0) {
				var value = Reflect.getProperty(p_instance,name);
				if(value != propertyDefaults[i]) {
					var property = this.createPrototypeProperty(name,propertyTypes[i],extras);
					property.setDynamicValue(Reflect.getProperty(p_instance,name));
				}
			}
		}
	}
	,bind: function(p_instance) {
		var $it0 = this.properties.iterator();
		while( $it0.hasNext() ) {
			var property = $it0.next();
			if((property.extras & 4) == 0) property.bind(p_instance);
		}
	}
	,addChild: function(p_prototype,p_groupName) {
		if(p_groupName == null) p_groupName = "";
		if(p_groupName == "") p_groupName = "default";
		if(!this.children.exists(p_groupName)) {
			var value = [];
			this.children.set(p_groupName,value);
		}
		this.children.get(p_groupName).push(p_prototype);
	}
	,getGroup: function(p_groupName) {
		return this.children.get(p_groupName);
	}
	,getProperty: function(p_propertyName) {
		return this.properties.get(p_propertyName);
	}
	,toXml: function() {
		var xml = Xml.createElement(this.prototypeName);
		var $it0 = this.properties.iterator();
		while( $it0.hasNext() ) {
			var property = $it0.next();
			if(property.type == "Bool" || property.type == "Int" || property.type == "Float" || property.type == "String" || (property.extras & 2) != 0) xml.set(property.name,property.value); else if(js_Boot.__instanceof(property.value,com_genome2d_proto_GPrototype)) {
				var propertyXml = Xml.createElement("p:" + property.name);
				propertyXml.addChild(property.value.toXml());
				xml.addChild(propertyXml);
			} else com_genome2d_debug_GDebug.error("Error during prototype parsing unknown property type",property.type,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototype.hx", lineNumber : 79, className : "com.genome2d.proto.GPrototype", methodName : "toXml"});
		}
		var $it1 = this.children.keys();
		while( $it1.hasNext() ) {
			var groupName = $it1.next();
			var isDefaultChildGroup = groupName == Reflect.field(this.prototypeClass,"PROTOTYPE_DEFAULT_CHILD_GROUP");
			var groupXml;
			if(isDefaultChildGroup) groupXml = null; else groupXml = Xml.createElement(groupName);
			var group = this.children.get(groupName);
			var _g = 0;
			while(_g < group.length) {
				var prototype = group[_g];
				++_g;
				if(!isDefaultChildGroup) groupXml.addChild(prototype.toXml()); else xml.addChild(prototype.toXml());
			}
			if(!isDefaultChildGroup) xml.addChild(groupXml);
		}
		return xml;
	}
	,setPropertyFromString: function(p_name,p_value) {
		var split = p_name.split(".");
		var lookupClass = this.prototypeClass;
		var propertyNames = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_NAMES");
		while(HxOverrides.indexOf(propertyNames,split[0],0) == -1 && lookupClass != null) {
			lookupClass = Type.getSuperClass(lookupClass);
			if(lookupClass != null) propertyNames = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_NAMES");
		}
		if(lookupClass != null) {
			var propertyTypes = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_TYPES");
			var propertyExtras = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_EXTRAS");
			var propertyIndex = HxOverrides.indexOf(propertyNames,split[0],0);
			this.createPrototypeProperty(p_name,propertyTypes[propertyIndex],propertyExtras[propertyIndex],p_value);
		}
	}
	,createPrototypeProperty: function(p_name,p_type,p_extras,p_value) {
		var property = new com_genome2d_proto_GPrototypeProperty(p_name,p_type,p_extras);
		this.properties.set(p_name,property);
		property.setDirectValue(p_value);
		return property;
	}
	,setPropertyFromXml: function(p_name,p_value) {
		var split = p_name.split(".");
		var lookupClass = this.prototypeClass;
		var propertyNames = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_NAMES");
		while(HxOverrides.indexOf(propertyNames,split[0],0) == -1 && lookupClass != null) {
			lookupClass = Type.getSuperClass(lookupClass);
			if(lookupClass != null) propertyNames = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_NAMES");
		}
		if(lookupClass != null) {
			var propertyTypes = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_TYPES");
			var propertyExtras = Reflect.field(lookupClass,"PROTOTYPE_PROPERTY_EXTRAS");
			var propertyIndex = HxOverrides.indexOf(propertyNames,split[0],0);
			this.createPrototypeProperty(p_name,propertyTypes[propertyIndex],propertyExtras[propertyIndex],com_genome2d_proto_GPrototype.fromXml(p_value));
		}
	}
	,__class__: com_genome2d_proto_GPrototype
};
var com_genome2d_proto_GPrototypeProperty = function(p_name,p_type,p_extras) {
	this.name = p_name;
	this.type = p_type;
	this.extras = p_extras;
};
com_genome2d_proto_GPrototypeProperty.__name__ = true;
com_genome2d_proto_GPrototypeProperty.prototype = {
	setDynamicValue: function(p_value) {
		if(this.type.indexOf("Array") == 0) {
			var subtype = HxOverrides.substr(this.type,6,null);
		} else if((this.extras & 2) != 0) this.value = (js_Boot.__cast(p_value , com_genome2d_proto_IGPrototypable)).toReference(); else if(this.type == "Bool" || this.type == "Int" || this.type == "Float" || this.type == "String") this.value = Std.string(p_value); else this.value = (js_Boot.__cast(p_value , com_genome2d_proto_IGPrototypable)).getPrototype();
	}
	,setDirectValue: function(p_value) {
		this.value = p_value;
	}
	,bind: function(p_instance) {
		var realValue;
		if((this.extras & 2) != 0) {
			var c = com_genome2d_proto_GPrototypeFactory.getPrototypeClass(this.type);
			realValue = Reflect.callMethod(c,Reflect.field(c,"fromReference"),[this.value]);
		} else realValue = this.g2d_getRealValue();
		var split = this.name.split(".");
		if(split.length == 1 || (function($this) {
			var $r;
			var _this = split[1].split("-");
			$r = HxOverrides.indexOf(_this,"default",0);
			return $r;
		}(this)) != -1) try {
			if((this.extras & 1) != 0) Reflect.callMethod(p_instance,Reflect.field(p_instance,split[0]),[realValue]); else Reflect.setProperty(p_instance,split[0],realValue);
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			com_genome2d_debug_GDebug.error("Error during prototype binding: ",e,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototype.hx", lineNumber : 234, className : "com.genome2d.proto.GPrototypeProperty", methodName : "bind"});
		}
		p_instance.g2d_prototypeStates.setProperty(split[0],realValue,this.extras,split[1],split[2]);
	}
	,g2d_getRealValue: function() {
		var realValue = null;
		var _g = this.type;
		switch(_g) {
		case "Bool":
			realValue = this.value != "false" && this.value != "0";
			break;
		case "Int":
			realValue = Std.parseInt(this.value);
			break;
		case "Float":
			realValue = Std.parseFloat(this.value);
			break;
		case "String":case "Dynamic":
			realValue = this.value;
			break;
		default:
			if(js_Boot.__instanceof(this.value,com_genome2d_proto_GPrototype)) realValue = com_genome2d_proto_GPrototypeFactory.createPrototype(this.value); else com_genome2d_debug_GDebug.error("Error during prototype binding invalid value for type: " + this.type,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototype.hx", lineNumber : 257, className : "com.genome2d.proto.GPrototypeProperty", methodName : "g2d_getRealValue"});
		}
		return realValue;
	}
	,isBasicType: function() {
		return this.type == "Bool" || this.type == "Int" || this.type == "Float" || this.type == "String";
	}
	,isReference: function() {
		return (this.extras & 2) != 0;
	}
	,isPrototype: function() {
		return js_Boot.__instanceof(this.value,com_genome2d_proto_GPrototype);
	}
	,__class__: com_genome2d_proto_GPrototypeProperty
};
var com_genome2d_proto_GPrototypeExtras = function() { };
com_genome2d_proto_GPrototypeExtras.__name__ = true;
var com_genome2d_proto_GPrototypeFactory = function() { };
com_genome2d_proto_GPrototypeFactory.__name__ = true;
com_genome2d_proto_GPrototypeFactory.initializePrototypes = function() {
	if(com_genome2d_proto_GPrototypeFactory.g2d_lookups != null) return;
	com_genome2d_proto_GPrototypeFactory.g2d_lookups = new haxe_ds_StringMap();
};
com_genome2d_proto_GPrototypeFactory.getPrototypeClass = function(p_prototypeName) {
	return com_genome2d_proto_GPrototypeFactory.g2d_lookups.get(p_prototypeName);
};
com_genome2d_proto_GPrototypeFactory.createPrototype = function(p_prototype) {
	if(p_prototype.prototypeClass == null) com_genome2d_debug_GDebug.error("Non existing prototype class " + p_prototype.prototypeName,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototypeFactory.hx", lineNumber : 37, className : "com.genome2d.proto.GPrototypeFactory", methodName : "createPrototype"});
	var proto = Type.createInstance(p_prototype.prototypeClass,[]);
	if(proto == null) com_genome2d_debug_GDebug.error("Invalid prototype class " + p_prototype.prototypeName,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototypeFactory.hx", lineNumber : 41, className : "com.genome2d.proto.GPrototypeFactory", methodName : "createPrototype"});
	proto.bindPrototype(p_prototype);
	return proto;
};
com_genome2d_proto_GPrototypeFactory.createPrototypeFromXmlString = function(p_xmlString) {
	return com_genome2d_proto_GPrototypeFactory.createPrototype(com_genome2d_proto_GPrototype.fromXml(Xml.parse(p_xmlString).firstElement()));
};
com_genome2d_proto_GPrototypeFactory.createEmptyPrototype = function(p_prototypeName) {
	var prototypeClass = com_genome2d_proto_GPrototypeFactory.g2d_lookups.get(p_prototypeName);
	if(prototypeClass == null) com_genome2d_debug_GDebug.error("Non existing prototype class " + p_prototypeName,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototypeFactory.hx", lineNumber : 55, className : "com.genome2d.proto.GPrototypeFactory", methodName : "createEmptyPrototype"});
	var proto = Type.createInstance(prototypeClass,[]);
	if(proto == null) com_genome2d_debug_GDebug.error("Invalid prototype class " + p_prototypeName,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototypeFactory.hx", lineNumber : 59, className : "com.genome2d.proto.GPrototypeFactory", methodName : "createEmptyPrototype"});
	return proto;
};
com_genome2d_proto_GPrototypeFactory.g2d_getPrototype = function(p_prototype,p_instance,p_prototypeName) {
	if(p_prototype == null) p_prototype = new com_genome2d_proto_GPrototype();
	p_prototype.process(p_instance,p_prototypeName);
	return p_prototype;
};
com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype = function(p_instance,p_prototype) {
	if(p_prototype == null) com_genome2d_debug_GDebug.error("Null prototype",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GPrototypeFactory.hx", lineNumber : 72, className : "com.genome2d.proto.GPrototypeFactory", methodName : "g2d_bindPrototype"});
	if(p_instance.g2d_prototypeStates == null) p_instance.g2d_prototypeStates = new com_genome2d_proto_GPrototypeStates();
	p_prototype.bind(p_instance);
};
var com_genome2d_proto_GPrototypeSpecs = function() { };
com_genome2d_proto_GPrototypeSpecs.__name__ = true;
var com_genome2d_proto_GPrototypeStates = function() {
	this.g2d_states = new haxe_ds_StringMap();
};
com_genome2d_proto_GPrototypeStates.__name__ = true;
com_genome2d_proto_GPrototypeStates.prototype = {
	setProperty: function(p_property,p_value,p_extras,p_stateName,p_transition) {
		if(p_stateName == null) p_stateName = "default";
		var split = p_stateName.split("-");
		if(split.length > 1) {
			var _g1 = 0;
			var _g = split.length;
			while(_g1 < _g) {
				var i = _g1++;
				this.setProperty(p_property,p_value,p_extras,split[i],p_transition);
			}
		} else {
			var state = this.g2d_states.get(p_stateName);
			if(state == null) {
				state = new haxe_ds_StringMap();
				this.g2d_states.set(p_stateName,state);
			}
			var value = new com_genome2d_proto_GPropertyState(p_property,p_value,p_extras,p_transition);
			if(__map_reserved[p_property] != null) state.setReserved(p_property,value); else state.h[p_property] = value;
		}
	}
	,getState: function(p_stateName) {
		if(p_stateName == null) p_stateName = "default";
		return this.g2d_states.get(p_stateName);
	}
	,__class__: com_genome2d_proto_GPrototypeStates
};
var com_genome2d_text_GFontManager = function() { };
com_genome2d_text_GFontManager.__name__ = true;
com_genome2d_text_GFontManager.getAllFonts = function() {
	return com_genome2d_text_GFontManager.g2d_fonts;
};
com_genome2d_text_GFontManager.init = function() {
	com_genome2d_text_GFontManager.g2d_fonts = new haxe_ds_StringMap();
};
com_genome2d_text_GFontManager.getFont = function(p_id) {
	return com_genome2d_text_GFontManager.g2d_fonts.get(p_id);
};
com_genome2d_text_GFontManager.createTextureFont = function(p_id,p_texture,p_fontXml) {
	var textureFont = new com_genome2d_text_GTextureFont(p_id,p_texture);
	var root = p_fontXml.firstElement();
	var common = root.elementsNamed("common").next();
	textureFont.lineHeight = Std.parseInt(common.get("lineHeight"));
	var it = root.elementsNamed("chars");
	it = it.next().elements();
	while(it.hasNext()) {
		var node = it.next();
		var w = Std.parseInt(node.get("width"));
		var h = Std.parseInt(node.get("height"));
		var region = new com_genome2d_geom_GRectangle(Std.parseInt(node.get("x")),Std.parseInt(node.get("y")),w,h);
		var $char = textureFont.addChar(node.get("id"),region,Std.parseFloat(node.get("xoffset")),Std.parseFloat(node.get("yoffset")),Std.parseFloat(node.get("xadvance")));
	}
	var kernings = root.elementsNamed("kernings").next();
	if(kernings != null) {
		it = kernings.elements();
		textureFont.kerning = new haxe_ds_IntMap();
		while(it.hasNext()) {
			var node1 = it.next();
			var first = Std.parseInt(node1.get("first"));
			var map = textureFont.kerning.h[first];
			if(map == null) {
				map = new haxe_ds_IntMap();
				textureFont.kerning.h[first] = map;
			}
			var second = Std.parseInt(node1.get("second"));
			var value = Std.parseInt("amount");
			map.h[second] = value;
		}
	}
	com_genome2d_text_GFontManager.g2d_fonts.set(p_id,textureFont);
	return textureFont;
};
var com_genome2d_text_GTextureChar = function(p_texture) {
	this.g2d_xadvance = 0;
	this.g2d_yoffset = 0;
	this.g2d_xoffset = 0;
	this.g2d_texture = p_texture;
};
com_genome2d_text_GTextureChar.__name__ = true;
com_genome2d_text_GTextureChar.prototype = {
	get_xoffset: function() {
		return this.g2d_xoffset * this.g2d_texture.g2d_scaleFactor;
	}
	,set_xoffset: function(p_value) {
		this.g2d_xoffset = p_value / this.g2d_texture.g2d_scaleFactor;
		return this.g2d_xoffset;
	}
	,get_yoffset: function() {
		return this.g2d_yoffset * this.g2d_texture.g2d_scaleFactor;
	}
	,set_yoffset: function(p_value) {
		this.g2d_yoffset = p_value / this.g2d_texture.g2d_scaleFactor;
		return this.g2d_yoffset;
	}
	,get_xadvance: function() {
		return this.g2d_xadvance * this.g2d_texture.g2d_scaleFactor;
	}
	,set_xadvance: function(p_value) {
		this.g2d_xadvance = p_value / this.g2d_texture.g2d_scaleFactor;
		return this.g2d_xadvance;
	}
	,get_texture: function() {
		return this.g2d_texture;
	}
	,__class__: com_genome2d_text_GTextureChar
	,__properties__: {get_texture:"get_texture",set_xadvance:"set_xadvance",get_xadvance:"get_xadvance",set_yoffset:"set_yoffset",get_yoffset:"get_yoffset",set_xoffset:"set_xoffset",get_xoffset:"get_xoffset"}
};
var com_genome2d_text_GTextureFont = function(p_id,p_texture) {
	this.g2d_currentState = "default";
	this.lineHeight = 0;
	this.id = p_id;
	this.texture = p_texture;
	this.g2d_chars = new haxe_ds_StringMap();
};
com_genome2d_text_GTextureFont.__name__ = true;
com_genome2d_text_GTextureFont.__interfaces__ = [com_genome2d_proto_IGPrototypable];
com_genome2d_text_GTextureFont.fromReference = function(p_reference) {
	return com_genome2d_text_GFontManager.getFont(p_reference);
};
com_genome2d_text_GTextureFont.prototype = {
	getChar: function(p_subId) {
		return this.g2d_chars.get(p_subId);
	}
	,addChar: function(p_charId,p_region,p_xoffset,p_yoffset,p_xadvance) {
		var charTexture = com_genome2d_textures_GTextureManager.createSubTexture(this.texture.g2d_id + "_" + p_charId,this.texture,p_region);
		charTexture.g2d_pivotX = -p_region.width / 2 / charTexture.g2d_scaleFactor;
		charTexture.g2d_pivotY = -p_region.height / 2 / charTexture.g2d_scaleFactor;
		var $char = new com_genome2d_text_GTextureChar(charTexture);
		$char.g2d_xoffset = p_xoffset / $char.g2d_texture.g2d_scaleFactor;
		$char.g2d_xoffset;
		$char.g2d_yoffset = p_yoffset / $char.g2d_texture.g2d_scaleFactor;
		$char.g2d_yoffset;
		$char.g2d_xadvance = p_xadvance / $char.g2d_texture.g2d_scaleFactor;
		$char.g2d_xadvance;
		this.g2d_chars.set(p_charId,$char);
		return $char;
	}
	,getKerning: function(p_first,p_second) {
		if(this.kerning != null && this.kerning.h.hasOwnProperty(p_first)) {
			var map = this.kerning.h[p_first];
			if(!map.h.hasOwnProperty(p_second)) return 0; else return map.h[p_second] * this.texture.g2d_scaleFactor;
		}
		return 0;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GTextureFont");
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,toReference: function() {
		return "";
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_text_GTextureFont
};
var com_genome2d_textures_GTextureBase = function(p_context,p_id,p_source,p_format) {
	this.g2d_currentState = "default";
	this.g2d_dirty = true;
	this.g2d_context = p_context;
	this.g2d_id = p_id;
	this.g2d_nativeWidth = this.g2d_nativeHeight = 0;
	this.g2d_gpuWidth = this.g2d_gpuHeight = 0;
	this.g2d_region = new com_genome2d_geom_GRectangle(0,0,1,1);
	this.g2d_u = this.g2d_v = 0;
	this.g2d_uScale = this.g2d_vScale = 1;
	this.g2d_pivotX = this.g2d_pivotY = 0;
	this.g2d_initializedRenderTarget = false;
	this.premultiplied = true;
	this.g2d_dirty = true;
	this.g2d_scaleFactor = 1;
	com_genome2d_textures_GTextureBase.g2d_instanceCount++;
	this.g2d_contextId = com_genome2d_textures_GTextureBase.g2d_instanceCount;
	this.g2d_format = p_format;
	this.g2d_repeatable = false;
	this.g2d_filteringType = com_genome2d_textures_GTextureManager.defaultFilteringType;
	this.setSource(p_source);
	com_genome2d_textures_GTextureManager.g2d_addTexture(this);
};
com_genome2d_textures_GTextureBase.__name__ = true;
com_genome2d_textures_GTextureBase.__interfaces__ = [com_genome2d_proto_IGPrototypable];
com_genome2d_textures_GTextureBase.fromReference = function(p_reference) {
	return com_genome2d_textures_GTextureManager.getTexture(HxOverrides.substr(p_reference,1,null));
};
com_genome2d_textures_GTextureBase.prototype = {
	get_onInvalidated: function() {
		if(this.g2d_onInvalidated == null) this.g2d_onInvalidated = new com_genome2d_callbacks_GCallback1(com_genome2d_textures_GTexture);
		return this.g2d_onInvalidated;
	}
	,get_onDisposed: function() {
		if(this.g2d_onDisposed == null) this.g2d_onDisposed = new com_genome2d_callbacks_GCallback1(com_genome2d_textures_GTexture);
		return this.g2d_onDisposed;
	}
	,isDirty: function() {
		return this.g2d_dirty;
	}
	,get_id: function() {
		return this.g2d_id;
	}
	,set_id: function(p_value) {
		com_genome2d_textures_GTextureManager.g2d_removeTexture(this);
		this.g2d_id = p_value;
		com_genome2d_textures_GTextureManager.g2d_addTexture(this);
		return this.g2d_id;
	}
	,get_pivotX: function() {
		return this.g2d_pivotX * this.g2d_scaleFactor;
	}
	,set_pivotX: function(p_value) {
		return this.g2d_pivotX = p_value / this.g2d_scaleFactor;
	}
	,get_pivotY: function() {
		return this.g2d_pivotY * this.g2d_scaleFactor;
	}
	,set_pivotY: function(p_value) {
		return this.g2d_pivotY = p_value / this.g2d_scaleFactor;
	}
	,get_nativeWidth: function() {
		return this.g2d_nativeWidth;
	}
	,get_nativeHeight: function() {
		return this.g2d_nativeHeight;
	}
	,get_width: function() {
		return this.g2d_nativeWidth * this.g2d_scaleFactor;
	}
	,get_height: function() {
		return this.g2d_nativeHeight * this.g2d_scaleFactor;
	}
	,get_scaleFactor: function() {
		return this.g2d_scaleFactor;
	}
	,set_scaleFactor: function(p_value) {
		this.g2d_scaleFactor = p_value;
		return this.g2d_scaleFactor;
	}
	,get_filteringType: function() {
		return this.g2d_filteringType;
	}
	,set_filteringType: function(p_value) {
		return this.g2d_filteringType = p_value;
	}
	,get_sourceType: function() {
		return this.g2d_sourceType;
	}
	,get_format: function() {
		return this.g2d_format;
	}
	,set_format: function(p_value) {
		this.g2d_format = p_value;
		this.g2d_dirty = true;
		return p_value;
	}
	,get_u: function() {
		return this.g2d_u;
	}
	,get_v: function() {
		return this.g2d_v;
	}
	,get_uScale: function() {
		return this.g2d_uScale;
	}
	,get_vScale: function() {
		return this.g2d_vScale;
	}
	,get_repeatable: function() {
		return this.g2d_repeatable;
	}
	,set_repeatable: function(p_value) {
		this.g2d_repeatable = p_value;
		this.g2d_dirty = true;
		return p_value;
	}
	,get_region: function() {
		return this.g2d_region;
	}
	,set_region: function(p_value) {
		this.g2d_region = p_value;
		this.g2d_nativeWidth = this.g2d_region.width | 0;
		this.g2d_nativeHeight = this.g2d_region.height | 0;
		this.invalidateUV();
		return this.g2d_region;
	}
	,getSource: function() {
		return this.g2d_source;
	}
	,setSource: function(p_value) {
		this.g2d_source = p_value;
		return this.g2d_source;
	}
	,invalidateUV: function() {
		this.g2d_u = this.g2d_region.x / this.g2d_gpuWidth;
		this.g2d_v = this.g2d_region.y / this.g2d_gpuHeight;
		this.g2d_uScale = this.g2d_region.width / this.g2d_gpuWidth;
		this.g2d_vScale = this.g2d_region.height / this.g2d_gpuHeight;
	}
	,usesRectangle: function() {
		return !this.g2d_repeatable && ((function($this) {
			var $r;
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			$r = com_genome2d_Genome2D.g2d_instance;
			return $r;
		}(this))).getContext().hasFeature(2);
	}
	,needClearAsRenderTarget: function(p_clear) {
		if(!this.g2d_initializedRenderTarget || p_clear) {
			this.g2d_initializedRenderTarget = true;
			return true;
		}
		return false;
	}
	,dispose: function(p_disposeSource) {
		if(p_disposeSource == null) p_disposeSource = false;
		this.g2d_source = null;
		com_genome2d_textures_GTextureManager.g2d_removeTexture(this);
		if(this.g2d_onDisposed != null) {
			this.g2d_onDisposed.dispatch(this);
			this.g2d_onDisposed.removeAll();
		}
		if(this.g2d_onInvalidated != null) this.g2d_onInvalidated.removeAll();
	}
	,getAlphaAtUV: function(p_u,p_v) {
		return 1;
	}
	,parentInvalidated_handler: function(p_texture) {
		this.g2d_gpuWidth = p_texture.g2d_gpuWidth;
		this.g2d_gpuHeight = p_texture.g2d_gpuHeight;
		this.invalidateUV();
		if(this.g2d_onInvalidated != null) this.g2d_onInvalidated.dispatch(this);
	}
	,parentDisposed_handler: function(p_texture) {
		this.dispose();
	}
	,toString: function() {
		return "@" + this.g2d_id;
	}
	,toReference: function() {
		return "@" + this.g2d_id;
	}
	,get_gpuWidth: function() {
		return this.g2d_gpuWidth;
	}
	,get_gpuHeight: function() {
		return this.g2d_gpuHeight;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GTextureBase");
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_textures_GTextureBase
	,__properties__: {get_gpuHeight:"get_gpuHeight",get_gpuWidth:"get_gpuWidth",set_region:"set_region",get_region:"get_region",set_repeatable:"set_repeatable",get_repeatable:"get_repeatable",get_vScale:"get_vScale",get_uScale:"get_uScale",get_v:"get_v",get_u:"get_u",set_format:"set_format",get_format:"get_format",get_sourceType:"get_sourceType",set_filteringType:"set_filteringType",get_filteringType:"get_filteringType",set_scaleFactor:"set_scaleFactor",get_scaleFactor:"get_scaleFactor",get_height:"get_height",get_width:"get_width",get_nativeHeight:"get_nativeHeight",get_nativeWidth:"get_nativeWidth",set_pivotY:"set_pivotY",get_pivotY:"get_pivotY",set_pivotX:"set_pivotX",get_pivotX:"get_pivotX",get_id:"get_id",get_onDisposed:"get_onDisposed",get_onInvalidated:"get_onInvalidated"}
};
var com_genome2d_textures_GTexture = function(p_context,p_id,p_source,p_format) {
	com_genome2d_textures_GTextureBase.call(this,p_context,p_id,p_source,p_format);
};
com_genome2d_textures_GTexture.__name__ = true;
com_genome2d_textures_GTexture.__super__ = com_genome2d_textures_GTextureBase;
com_genome2d_textures_GTexture.prototype = $extend(com_genome2d_textures_GTextureBase.prototype,{
	setSource: function(p_value) {
		if(this.g2d_source != p_value) {
			this.g2d_dirty = true;
			this.g2d_source = p_value;
			if(js_Boot.__instanceof(this.g2d_source,HTMLImageElement)) {
				var imageElement = this.g2d_source;
				this.g2d_sourceType = 8;
				this.g2d_nativeWidth = imageElement.width;
				this.g2d_nativeHeight = imageElement.height;
				this.premultiplied = true;
			} else if(js_Boot.__instanceof(this.g2d_source,com_genome2d_geom_GRectangle)) {
				this.g2d_sourceType = 3;
				this.g2d_nativeWidth = p_value.width;
				this.g2d_nativeHeight = p_value.height;
			} else if(js_Boot.__instanceof(this.g2d_source,com_genome2d_textures_GTexture)) {
				var parent = this.g2d_source;
				((function($this) {
					var $r;
					if(parent.g2d_onInvalidated == null) parent.g2d_onInvalidated = new com_genome2d_callbacks_GCallback1(com_genome2d_textures_GTexture);
					$r = parent.g2d_onInvalidated;
					return $r;
				}(this))).add($bind(this,this.parentInvalidated_handler));
				((function($this) {
					var $r;
					if(parent.g2d_onDisposed == null) parent.g2d_onDisposed = new com_genome2d_callbacks_GCallback1(com_genome2d_textures_GTexture);
					$r = parent.g2d_onDisposed;
					return $r;
				}(this))).add($bind(this,this.parentDisposed_handler));
				this.g2d_gpuWidth = parent.g2d_gpuWidth;
				this.g2d_gpuHeight = parent.g2d_gpuHeight;
				this.g2d_nativeWidth = parent.g2d_nativeWidth;
				this.g2d_nativeHeight = parent.g2d_nativeHeight;
				this.g2d_nativeTexture = parent.g2d_nativeTexture;
				this.g2d_sourceType = 7;
			} else com_genome2d_debug_GDebug.error("Invalid texture source.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GTexture.hx", lineNumber : 50, className : "com.genome2d.textures.GTexture", methodName : "setSource"});
			this.g2d_dirty = true;
		}
		return this.g2d_source;
	}
	,invalidateNativeTexture: function(p_reinitialize) {
		if(js_Boot.__instanceof(this.g2d_context,com_genome2d_context_IGContext)) {
			var webglContext = this.g2d_context;
			if(this.g2d_sourceType != 7) {
				if(!this.g2d_repeatable && ((function($this) {
					var $r;
					if(com_genome2d_Genome2D.g2d_instance == null) {
						com_genome2d_Genome2D.g2d_instantiable = true;
						new com_genome2d_Genome2D();
						com_genome2d_Genome2D.g2d_instantiable = false;
					}
					$r = com_genome2d_Genome2D.g2d_instance;
					return $r;
				}(this))).getContext().hasFeature(2)) this.g2d_gpuWidth = this.g2d_nativeWidth; else this.g2d_gpuWidth = com_genome2d_textures_GTextureUtils.getNextValidTextureSize(this.g2d_nativeWidth);
				if(!this.g2d_repeatable && ((function($this) {
					var $r;
					if(com_genome2d_Genome2D.g2d_instance == null) {
						com_genome2d_Genome2D.g2d_instantiable = true;
						new com_genome2d_Genome2D();
						com_genome2d_Genome2D.g2d_instantiable = false;
					}
					$r = com_genome2d_Genome2D.g2d_instance;
					return $r;
				}(this))).getContext().hasFeature(2)) this.g2d_gpuHeight = this.g2d_nativeHeight; else this.g2d_gpuHeight = com_genome2d_textures_GTextureUtils.getNextValidTextureSize(this.g2d_nativeHeight);
				var _g = this.g2d_sourceType;
				switch(_g) {
				case 8:
					if(this.g2d_nativeTexture == null || p_reinitialize) this.g2d_nativeTexture = webglContext.g2d_nativeContext.createTexture();
					webglContext.g2d_nativeContext.bindTexture(3553,this.g2d_nativeTexture);
					webglContext.g2d_nativeContext.texImage2D(3553,0,6408,6408,5121,this.g2d_source);
					webglContext.g2d_nativeContext.texParameteri(3553,10241,9729);
					webglContext.g2d_nativeContext.texParameteri(3553,10240,9729);
					webglContext.g2d_nativeContext.texParameteri(3553,10242,33071);
					webglContext.g2d_nativeContext.texParameteri(3553,10243,33071);
					webglContext.g2d_nativeContext.bindTexture(3553,null);
					break;
				default:
				}
			}
		} else {
		}
	}
	,get_nativeTexture: function() {
		return this.g2d_nativeTexture;
	}
	,hasSameGPUTexture: function(p_texture) {
		return p_texture.g2d_nativeTexture == this.g2d_nativeTexture;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GTexture");
		return com_genome2d_textures_GTextureBase.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_textures_GTextureBase.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_textures_GTexture
	,__properties__: $extend(com_genome2d_textures_GTextureBase.prototype.__properties__,{get_nativeTexture:"get_nativeTexture"})
});
var com_genome2d_textures_GTextureFilteringType = function() { };
com_genome2d_textures_GTextureFilteringType.__name__ = true;
var com_genome2d_textures_GTextureManager = function() { };
com_genome2d_textures_GTextureManager.__name__ = true;
com_genome2d_textures_GTextureManager.init = function(p_context) {
	com_genome2d_textures_GTextureManager.g2d_context = p_context;
	com_genome2d_textures_GTextureManager.g2d_textures = new haxe_ds_StringMap();
};
com_genome2d_textures_GTextureManager.getAllTextures = function() {
	return com_genome2d_textures_GTextureManager.g2d_textures;
};
com_genome2d_textures_GTextureManager.g2d_addTexture = function(p_texture) {
	if(p_texture.g2d_id == null || p_texture.g2d_id.length == 0) com_genome2d_debug_GDebug.error("Invalid texture id",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GTextureManager.hx", lineNumber : 36, className : "com.genome2d.textures.GTextureManager", methodName : "g2d_addTexture"});
	if(com_genome2d_textures_GTextureManager.g2d_textures.exists(p_texture.g2d_id)) com_genome2d_debug_GDebug.error("Duplicate textures id: " + p_texture.g2d_id,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GTextureManager.hx", lineNumber : 37, className : "com.genome2d.textures.GTextureManager", methodName : "g2d_addTexture"});
	com_genome2d_textures_GTextureManager.g2d_textures.set(p_texture.g2d_id,p_texture);
};
com_genome2d_textures_GTextureManager.g2d_removeTexture = function(p_texture) {
	com_genome2d_textures_GTextureManager.g2d_textures.remove(p_texture.g2d_id);
};
com_genome2d_textures_GTextureManager.getTexture = function(p_id) {
	return com_genome2d_textures_GTextureManager.g2d_textures.get(p_id);
};
com_genome2d_textures_GTextureManager.getTextures = function(p_ids) {
	var textures = [];
	var _g = 0;
	while(_g < p_ids.length) {
		var id = p_ids[_g];
		++_g;
		textures.push(com_genome2d_textures_GTextureManager.g2d_textures.get(id));
	}
	return textures;
};
com_genome2d_textures_GTextureManager.findTextures = function(p_regExp) {
	var found = [];
	var $it0 = com_genome2d_textures_GTextureManager.g2d_textures.iterator();
	while( $it0.hasNext() ) {
		var tex = $it0.next();
		if(p_regExp != null) {
			if(p_regExp.match(tex.g2d_id)) found.push(tex);
		} else found.push(tex);
	}
	return found;
};
com_genome2d_textures_GTextureManager.disposeAll = function(p_disposeSource) {
	if(p_disposeSource == null) p_disposeSource = false;
	var $it0 = com_genome2d_textures_GTextureManager.g2d_textures.iterator();
	while( $it0.hasNext() ) {
		var texture = $it0.next();
		if(texture.g2d_id.indexOf("g2d_") != 0) texture.dispose(p_disposeSource);
	}
};
com_genome2d_textures_GTextureManager.invalidateAll = function(p_force) {
	var $it0 = com_genome2d_textures_GTextureManager.g2d_textures.iterator();
	while( $it0.hasNext() ) {
		var texture = $it0.next();
		texture.invalidateNativeTexture(p_force);
	}
};
com_genome2d_textures_GTextureManager.createTexture = function(p_id,p_source,p_scaleFactor,p_repeatable,p_format) {
	if(p_format == null) p_format = "bgra";
	if(p_repeatable == null) p_repeatable = false;
	if(p_scaleFactor == null) p_scaleFactor = 1;
	var texture = null;
	if(js_Boot.__instanceof(p_source,com_genome2d_assets_GImageAsset)) {
		var imageAsset = p_source;
		var _g = imageAsset.g2d_type;
		switch(_g) {
		case 2:
			texture = new com_genome2d_textures_GTexture(com_genome2d_textures_GTextureManager.g2d_context,p_id,imageAsset.g2d_imageElement,p_format);
			break;
		}
	} else if(js_Boot.__instanceof(p_source,HTMLImageElement)) texture = new com_genome2d_textures_GTexture(com_genome2d_textures_GTextureManager.g2d_context,p_id,p_source,p_format); else if(js_Boot.__instanceof(p_source,com_genome2d_geom_GRectangle)) texture = new com_genome2d_textures_GTexture(com_genome2d_textures_GTextureManager.g2d_context,p_id,p_source,p_format);
	if(texture != null) {
		texture.g2d_repeatable = p_repeatable;
		texture.g2d_dirty = true;
		p_repeatable;
		texture.g2d_scaleFactor = p_scaleFactor;
		texture.g2d_scaleFactor;
		texture.invalidateNativeTexture(false);
	} else com_genome2d_debug_GDebug.error("Invalid texture source.",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GTextureManager.hx", lineNumber : 124, className : "com.genome2d.textures.GTextureManager", methodName : "createTexture"});
	return texture;
};
com_genome2d_textures_GTextureManager.createSubTexture = function(p_id,p_texture,p_region,p_frame,p_prefixParentId) {
	if(p_prefixParentId == null) p_prefixParentId = true;
	var texture = new com_genome2d_textures_GTexture(com_genome2d_textures_GTextureManager.g2d_context,p_prefixParentId?p_texture.g2d_id + "_" + p_id:p_id,p_texture,p_texture.g2d_format);
	texture.g2d_region = p_region;
	texture.g2d_nativeWidth = texture.g2d_region.width | 0;
	texture.g2d_nativeHeight = texture.g2d_region.height | 0;
	texture.invalidateUV();
	texture.g2d_region;
	if(p_frame != null) {
		texture.g2d_frame = p_frame;
		texture.g2d_pivotX = ((p_frame.width - p_region.width) * .5 + p_frame.x) / texture.g2d_scaleFactor;
		texture.g2d_pivotY = ((p_frame.height - p_region.height) * .5 + p_frame.y) / texture.g2d_scaleFactor;
	}
	return texture;
};
com_genome2d_textures_GTextureManager.createRenderTexture = function(p_id,p_width,p_height,p_scaleFactor) {
	if(p_scaleFactor == null) p_scaleFactor = 1;
	var texture = new com_genome2d_textures_GTexture(com_genome2d_textures_GTextureManager.g2d_context,p_id,new com_genome2d_geom_GRectangle(0,0,p_width,p_height),"bgra");
	texture.invalidateNativeTexture(false);
	return texture;
};
com_genome2d_textures_GTextureManager.createSubTextures = function(p_texture,p_xml,p_prefixParentId) {
	if(p_prefixParentId == null) p_prefixParentId = true;
	var textures = [];
	var root = p_xml.firstElement();
	var it = root.elements();
	while(it.hasNext()) {
		var node = it.next();
		var region = new com_genome2d_geom_GRectangle(Std.parseInt(node.get("x")),Std.parseInt(node.get("y")),Std.parseInt(node.get("width")),Std.parseInt(node.get("height")));
		var frame = null;
		if(node.get("frameX") != null && node.get("frameWidth") != null && node.get("frameY") != null && node.get("frameHeight") != null) frame = new com_genome2d_geom_GRectangle(Std.parseInt(node.get("frameX")),Std.parseInt(node.get("frameY")),Std.parseInt(node.get("frameWidth")),Std.parseInt(node.get("frameHeight")));
		textures.push(com_genome2d_textures_GTextureManager.createSubTexture(node.get("name"),p_texture,region,frame,p_prefixParentId));
	}
	return textures;
};
var com_genome2d_textures_GTextureSourceType = function() { };
com_genome2d_textures_GTextureSourceType.__name__ = true;
var com_genome2d_textures_GTextureUtils = function() { };
com_genome2d_textures_GTextureUtils.__name__ = true;
com_genome2d_textures_GTextureUtils.isValidTextureSize = function(p_size) {
	return com_genome2d_textures_GTextureUtils.getNextValidTextureSize(p_size) == p_size;
};
com_genome2d_textures_GTextureUtils.getNextValidTextureSize = function(p_size) {
	var size = 1;
	while(p_size > size) size *= 2;
	return size;
};
com_genome2d_textures_GTextureUtils.getPreviousValidTextureSize = function(p_size) {
	return com_genome2d_textures_GTextureUtils.getNextValidTextureSize(p_size) >> 1;
};
com_genome2d_textures_GTextureUtils.getNearestValidTextureSize = function(p_size) {
	var previous = com_genome2d_textures_GTextureUtils.getPreviousValidTextureSize(p_size);
	var next = com_genome2d_textures_GTextureUtils.getNextValidTextureSize(p_size);
	if(p_size - previous < next - p_size) return previous; else return next;
};
var com_genome2d_transitions_GTransitionManager = function() { };
com_genome2d_transitions_GTransitionManager.__name__ = true;
com_genome2d_transitions_GTransitionManager.init = function() {
	com_genome2d_transitions_GTransitionManager.g2d_references = new haxe_ds_StringMap();
};
com_genome2d_transitions_GTransitionManager.getTransition = function(p_id) {
	return com_genome2d_transitions_GTransitionManager.g2d_references.get(p_id);
};
com_genome2d_transitions_GTransitionManager.g2d_addTransition = function(p_id,p_value) {
	com_genome2d_transitions_GTransitionManager.g2d_references.set(p_id,p_value);
};
com_genome2d_transitions_GTransitionManager.g2d_removeTransition = function(p_id) {
	com_genome2d_transitions_GTransitionManager.g2d_references.remove(p_id);
};
com_genome2d_transitions_GTransitionManager.getAllTransitions = function() {
	return com_genome2d_transitions_GTransitionManager.g2d_references;
};
var com_genome2d_transitions_IGTransition = function() { };
com_genome2d_transitions_IGTransition.__name__ = true;
com_genome2d_transitions_IGTransition.prototype = {
	__class__: com_genome2d_transitions_IGTransition
};
var com_genome2d_ui_element_GUIElement = function(p_skin) {
	this.g2d_currentState = "default";
	this.g2d_numChildren = 0;
	this.g2d_preferredHeight = 0;
	this.g2d_finalHeight = 0;
	this.g2d_minHeight = 0;
	this.g2d_preferredWidth = 0;
	this.g2d_finalWidth = 0;
	this.g2d_minWidth = 0;
	this.expand = true;
	this.g2d_pivotY = 0;
	this.g2d_pivotX = 0;
	this.g2d_bottom = 0;
	this.g2d_right = 0;
	this.g2d_top = 0;
	this.g2d_left = 0;
	this.g2d_anchorBottom = 0;
	this.g2d_anchorRight = 0;
	this.g2d_anchorTop = 0;
	this.g2d_anchorLeft = 0;
	this.g2d_anchorY = 0;
	this.g2d_anchorX = 0;
	this.g2d_dirty = true;
	this.g2d_model = "";
	this.g2d_mouseMove = "";
	this.g2d_mouseOut = "";
	this.g2d_mouseOver = "";
	this.g2d_mouseClick = "";
	this.g2d_mouseUp = "";
	this.g2d_mouseDown = "";
	this.g2d_dragging = false;
	this.g2d_scrollable = false;
	this.name = "";
	this.flushBatch = false;
	this.visible = true;
	this.mouseChildren = true;
	this.mouseEnabled = true;
	this.alpha = 1;
	this.blue = 1;
	this.green = 1;
	this.red = 1;
	this.g2d_onModelChanged = new com_genome2d_callbacks_GCallback1();
	if(p_skin != null) {
		if(p_skin == null || this.g2d_skin == null || (p_skin.g2d_origin == null?p_skin.g2d_id:p_skin.g2d_origin.g2d_id) != this.g2d_skin.get_id()) {
			if(this.g2d_skin != null) this.g2d_skin.remove();
			if(p_skin != null) this.g2d_skin = p_skin.attach(this); else this.g2d_skin = p_skin;
			this.g2d_activeSkin = this.g2d_skin;
			this.setDirty();
		}
		this.g2d_skin;
	}
};
com_genome2d_ui_element_GUIElement.__name__ = true;
com_genome2d_ui_element_GUIElement.__interfaces__ = [com_genome2d_input_IGInteractive,com_genome2d_proto_IGPrototypable];
com_genome2d_ui_element_GUIElement.prototype = {
	get_color: function() {
		var color = 0;
		color += (this.red * 255 | 0) << 16;
		color += (this.green * 255 | 0) << 8;
		color += this.blue * 255 | 0;
		return color;
	}
	,set_color: function(p_value) {
		this.red = (p_value >> 16 & 255 | 0) / 255;
		this.green = (p_value >> 8 & 255 | 0) / 255;
		this.blue = (p_value & 255 | 0) / 255;
		return p_value;
	}
	,get_scrollable: function() {
		return this.g2d_scrollable;
	}
	,set_scrollable: function(p_value) {
		if(!this.g2d_scrollable && p_value) ((function($this) {
			var $r;
			if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
			$r = $this.g2d_onMouseDown;
			return $r;
		}(this))).add($bind(this,this.mouseDown_handler)); else if(this.g2d_scrollable && !p_value) ((function($this) {
			var $r;
			if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
			$r = $this.g2d_onMouseDown;
			return $r;
		}(this))).remove($bind(this,this.mouseDown_handler));
		this.g2d_scrollable = p_value;
		return this.g2d_scrollable;
	}
	,getController: function() {
		if(this.g2d_controller != null) return this.g2d_controller; else if(this.g2d_parent != null) return this.g2d_parent.getController(); else return null;
	}
	,setController: function(p_value) {
		this.g2d_controller = p_value;
		this.invalidateController();
	}
	,invalidateController: function() {
		var newController = this.getController();
		if(newController != this.g2d_currentController) {
			if(this.g2d_mouseDown != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseDown);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseDown;
					return $r;
				}(this))).remove(mdf);
			}
			if(this.g2d_mouseUp != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseUp);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseUp == null) $this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseUp;
					return $r;
				}(this))).remove(mdf1);
			}
			if(this.g2d_mouseOver != "" && this.g2d_currentController != null) {
				var mdf2 = Reflect.field(this.g2d_currentController,this.g2d_mouseOver);
				if(mdf2 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOver == null) $this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOver;
					return $r;
				}(this))).remove(mdf2);
			}
			if(this.g2d_mouseOut != "" && this.g2d_currentController != null) {
				var mdf3 = Reflect.field(this.g2d_currentController,this.g2d_mouseOut);
				if(mdf3 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOut == null) $this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOut;
					return $r;
				}(this))).remove(mdf3);
			}
			if(this.g2d_mouseClick != "" && this.g2d_currentController != null) {
				var mdf4 = Reflect.field(this.g2d_currentController,this.g2d_mouseClick);
				if(mdf4 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseClick == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseClick;
					return $r;
				}(this))).remove(mdf4);
			}
			if(this.g2d_mouseMove != "" && this.g2d_currentController != null) {
				var mdf5 = Reflect.field(this.g2d_currentController,this.g2d_mouseMove);
				if(mdf5 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseMove == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseMove;
					return $r;
				}(this))).remove(mdf5);
			}
			this.g2d_currentController = newController;
			if(this.g2d_mouseDown != "" && this.g2d_currentController != null) {
				var mdf6 = Reflect.field(this.g2d_currentController,this.g2d_mouseDown);
				if(mdf6 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseDown;
					return $r;
				}(this))).add(mdf6);
			}
			if(this.g2d_mouseUp != "" && this.g2d_currentController != null) {
				var mdf7 = Reflect.field(this.g2d_currentController,this.g2d_mouseUp);
				if(mdf7 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseUp == null) $this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseUp;
					return $r;
				}(this))).add(mdf7);
			}
			if(this.g2d_mouseOver != "" && this.g2d_currentController != null) {
				var mdf8 = Reflect.field(this.g2d_currentController,this.g2d_mouseOver);
				if(mdf8 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOver == null) $this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOver;
					return $r;
				}(this))).add(mdf8);
			}
			if(this.g2d_mouseOut != "" && this.g2d_currentController != null) {
				var mdf9 = Reflect.field(this.g2d_currentController,this.g2d_mouseOut);
				if(mdf9 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOut == null) $this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOut;
					return $r;
				}(this))).add(mdf9);
			}
			if(this.g2d_mouseClick != "" && this.g2d_currentController != null) {
				var mdf10 = Reflect.field(this.g2d_currentController,this.g2d_mouseClick);
				if(mdf10 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseClick == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseClick;
					return $r;
				}(this))).add(mdf10);
			}
			if(this.g2d_mouseMove != "" && this.g2d_currentController != null) {
				var mdf11 = Reflect.field(this.g2d_currentController,this.g2d_mouseMove);
				if(mdf11 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseMove == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseMove;
					return $r;
				}(this))).add(mdf11);
			}
			var _g1 = 0;
			var _g = this.g2d_numChildren;
			while(_g1 < _g) {
				var i = _g1++;
				this.g2d_children[i].invalidateController();
			}
		}
	}
	,setAlign: function(p_align) {
		this.g2d_anchorLeft = this.g2d_anchorRight = (p_align - 1) % 3 * 0.5;
		this.g2d_anchorTop = this.g2d_anchorBottom = ((p_align - 1) / 3 | 0) * 0.5;
		this.g2d_pivotX = (p_align - 1) % 3 * 0.5;
		this.g2d_pivotY = ((p_align - 1) / 3 | 0) * 0.5;
		this.setDirty();
	}
	,setAnchorAlign: function(p_align) {
		this.g2d_anchorLeft = this.g2d_anchorRight = (p_align - 1) % 3 * 0.5;
		this.g2d_anchorTop = this.g2d_anchorBottom = ((p_align - 1) / 3 | 0) * 0.5;
		this.setDirty();
	}
	,setPivotAlign: function(p_align) {
		this.g2d_pivotX = (p_align - 1) % 3 * 0.5;
		this.g2d_pivotY = ((p_align - 1) / 3 | 0) * 0.5;
		this.setDirty();
	}
	,get_mouseDown: function() {
		return this.g2d_mouseDown;
	}
	,set_mouseDown: function(p_value) {
		if(this.g2d_mouseDown != p_value) {
			if(this.g2d_mouseDown != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseDown);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseDown;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseDown = p_value;
			if(this.g2d_mouseDown != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseDown);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseDown == null) $this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseDown;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseDown;
	}
	,get_mouseUp: function() {
		return this.g2d_mouseUp;
	}
	,set_mouseUp: function(p_value) {
		if(this.g2d_mouseUp != p_value) {
			if(this.g2d_mouseUp != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseUp);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseUp == null) $this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseUp;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseUp = p_value;
			if(this.g2d_mouseUp != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseUp);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseUp == null) $this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseUp;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseUp;
	}
	,get_mouseClick: function() {
		return this.g2d_mouseClick;
	}
	,set_mouseClick: function(p_value) {
		if(this.g2d_mouseClick != p_value) {
			if(this.g2d_mouseClick != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseClick);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseClick == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseClick;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseClick = p_value;
			if(this.g2d_mouseClick != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseClick);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseClick == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseClick;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseClick;
	}
	,get_mouseOver: function() {
		return this.g2d_mouseOver;
	}
	,set_mouseOver: function(p_value) {
		if(this.g2d_mouseOver != p_value) {
			if(this.g2d_mouseOver != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseOver);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOver == null) $this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOver;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseOver = p_value;
			if(this.g2d_mouseOver != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseOver);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOver == null) $this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOver;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseOver;
	}
	,get_mouseOut: function() {
		return this.g2d_mouseOut;
	}
	,set_mouseOut: function(p_value) {
		if(this.g2d_mouseOut != p_value) {
			if(this.g2d_mouseOut != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseOut);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOut == null) $this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOut;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseOut = p_value;
			if(this.g2d_mouseOut != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseOut);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseOut == null) $this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseOut;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseOut;
	}
	,get_mouseMove: function() {
		return this.g2d_mouseMove;
	}
	,set_mouseMove: function(p_value) {
		if(this.g2d_mouseMove != p_value) {
			if(this.g2d_mouseMove != "" && this.g2d_currentController != null) {
				var mdf = Reflect.field(this.g2d_currentController,this.g2d_mouseMove);
				if(mdf != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseMove == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseMove;
					return $r;
				}(this))).remove(mdf);
			}
			this.g2d_mouseMove = p_value;
			if(this.g2d_mouseMove != "" && this.g2d_currentController != null) {
				var mdf1 = Reflect.field(this.g2d_currentController,this.g2d_mouseMove);
				if(mdf1 != null) ((function($this) {
					var $r;
					if($this.g2d_onMouseMove == null) $this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
					$r = $this.g2d_onMouseMove;
					return $r;
				}(this))).add(mdf1);
			}
		}
		return this.g2d_mouseMove;
	}
	,getModel: function() {
		return this.g2d_model;
	}
	,setModel: function(p_value) {
		if(com_genome2d_ui_element_GUIElement.setModelHook != null) p_value = com_genome2d_ui_element_GUIElement.setModelHook(p_value);
		if(js_Boot.__instanceof(p_value,Xml)) {
			var xml;
			xml = js_Boot.__cast(p_value , Xml);
			var it = xml.elements();
			if(!it.hasNext()) {
				if((function($this) {
					var $r;
					if(xml.nodeType != Xml.Document && xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + xml.nodeType);
					$r = xml.children[0];
					return $r;
				}(this)) != null && ((function($this) {
					var $r;
					if(xml.nodeType != Xml.Document && xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + xml.nodeType);
					$r = xml.children[0];
					return $r;
				}(this))).nodeType == Xml.PCData) this.g2d_model = ((function($this) {
					var $r;
					if(xml.nodeType != Xml.Document && xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + xml.nodeType);
					$r = xml.children[0];
					return $r;
				}(this))).get_nodeValue(); else this.g2d_model = "";
			} else while(it.hasNext()) {
				var childXml = it.next();
				var child = this.getChildByName((function($this) {
					var $r;
					if(childXml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + childXml.nodeType);
					$r = childXml.nodeName;
					return $r;
				}(this)),true);
				if(child != null) child.setModel(childXml);
			}
		} else if(typeof(p_value) == "string") this.g2d_model = p_value; else {
			var _g = 0;
			var _g1 = Reflect.fields(p_value);
			while(_g < _g1.length) {
				var it1 = _g1[_g];
				++_g;
				var child1 = this.getChildByName(it1);
				if(child1 != null) child1.setModel(Reflect.field(p_value,it1));
			}
		}
		this.g2d_onModelChanged.dispatch(this);
	}
	,get_onModelChanged: function() {
		return this.g2d_onModelChanged;
	}
	,get_layout: function() {
		return this.g2d_layout;
	}
	,set_layout: function(p_value) {
		this.g2d_layout = p_value;
		this.setDirty();
		return this.g2d_layout;
	}
	,get_skin: function() {
		return this.g2d_skin;
	}
	,set_skin: function(p_value) {
		if(p_value == null || this.g2d_skin == null || (p_value.g2d_origin == null?p_value.g2d_id:p_value.g2d_origin.g2d_id) != this.g2d_skin.get_id()) {
			if(this.g2d_skin != null) this.g2d_skin.remove();
			if(p_value != null) this.g2d_skin = p_value.attach(this); else this.g2d_skin = p_value;
			this.g2d_activeSkin = this.g2d_skin;
			this.setDirty();
		}
		return this.g2d_skin;
	}
	,setDirty: function() {
		this.g2d_dirty = true;
		if(this.g2d_parent != null) this.g2d_parent.setDirty();
	}
	,get_anchorX: function() {
		return this.g2d_anchorX;
	}
	,set_anchorX: function(p_value) {
		this.g2d_anchorX = p_value;
		this.setDirty();
		return this.g2d_anchorX;
	}
	,get_anchorY: function() {
		return this.g2d_anchorY;
	}
	,set_anchorY: function(p_value) {
		this.g2d_anchorY = p_value;
		this.setDirty();
		return this.g2d_anchorY;
	}
	,get_anchorLeft: function() {
		return this.g2d_anchorLeft;
	}
	,set_anchorLeft: function(p_value) {
		this.g2d_anchorLeft = p_value;
		this.setDirty();
		return this.g2d_anchorLeft;
	}
	,get_anchorTop: function() {
		return this.g2d_anchorTop;
	}
	,set_anchorTop: function(p_value) {
		this.g2d_anchorTop = p_value;
		this.setDirty();
		return this.g2d_anchorTop;
	}
	,get_anchorRight: function() {
		return this.g2d_anchorRight;
	}
	,set_anchorRight: function(p_value) {
		this.g2d_anchorRight = p_value;
		this.setDirty();
		return this.g2d_anchorRight;
	}
	,get_anchorBottom: function() {
		return this.g2d_anchorBottom;
	}
	,set_anchorBottom: function(p_value) {
		this.g2d_anchorBottom = p_value;
		this.setDirty();
		return this.g2d_anchorBottom;
	}
	,get_left: function() {
		return this.g2d_left;
	}
	,set_left: function(p_value) {
		this.g2d_left = p_value;
		this.setDirty();
		return this.g2d_left;
	}
	,get_top: function() {
		return this.g2d_top;
	}
	,set_top: function(p_value) {
		this.g2d_top = p_value;
		this.setDirty();
		return this.g2d_top;
	}
	,get_right: function() {
		return this.g2d_right;
	}
	,set_right: function(p_value) {
		this.g2d_right = p_value;
		this.setDirty();
		return this.g2d_right;
	}
	,get_bottom: function() {
		return this.g2d_bottom;
	}
	,set_bottom: function(p_value) {
		this.g2d_bottom = p_value;
		this.setDirty();
		return this.g2d_bottom;
	}
	,get_pivotX: function() {
		return this.g2d_pivotX;
	}
	,set_pivotX: function(p_value) {
		this.g2d_pivotX = p_value;
		this.setDirty();
		return this.g2d_pivotX;
	}
	,get_pivotY: function() {
		return this.g2d_pivotY;
	}
	,set_pivotY: function(p_value) {
		this.g2d_pivotY = p_value;
		this.setDirty();
		return this.g2d_pivotY;
	}
	,get_preferredWidth: function() {
		return this.g2d_preferredWidth;
	}
	,set_preferredWidth: function(p_value) {
		this.g2d_preferredWidth = p_value;
		this.setDirty();
		return this.g2d_preferredWidth;
	}
	,get_preferredHeight: function() {
		return this.g2d_preferredHeight;
	}
	,set_preferredHeight: function(p_value) {
		this.g2d_preferredHeight = p_value;
		this.setDirty();
		return this.g2d_preferredHeight;
	}
	,get_parent: function() {
		return this.g2d_parent;
	}
	,get_numChildren: function() {
		return this.g2d_numChildren;
	}
	,get_children: function() {
		return this.g2d_children;
	}
	,isParent: function(p_element) {
		if(p_element == this.g2d_parent) return true;
		if(this.g2d_parent == null) return false;
		return this.g2d_parent.isParent(p_element);
	}
	,setRect: function(p_left,p_top,p_right,p_bottom) {
		var w = p_right - p_left;
		var h = p_bottom - p_top;
		if(this.g2d_parent != null) {
			var worldAnchorLeft = this.g2d_parent.g2d_worldLeft + this.g2d_parent.g2d_finalWidth * this.g2d_anchorLeft;
			var worldAnchorRight = this.g2d_parent.g2d_worldLeft + this.g2d_parent.g2d_finalWidth * this.g2d_anchorRight;
			var worldAnchorTop = this.g2d_parent.g2d_worldTop + this.g2d_parent.g2d_finalHeight * this.g2d_anchorTop;
			var worldAnchorBottom = this.g2d_parent.g2d_worldTop + this.g2d_parent.g2d_finalHeight * this.g2d_anchorBottom;
			if(this.g2d_anchorLeft != this.g2d_anchorRight) {
				this.g2d_left = p_left - worldAnchorLeft;
				this.g2d_right = worldAnchorRight - p_right;
			} else this.g2d_anchorX = p_left - worldAnchorLeft + w * this.g2d_pivotX;
			if(this.g2d_anchorTop != this.g2d_anchorBottom) {
				this.g2d_top = p_top - worldAnchorTop;
				this.g2d_bottom = worldAnchorBottom - p_bottom;
			} else this.g2d_anchorY = p_top - worldAnchorTop + h * this.g2d_pivotY;
		} else {
			this.g2d_worldLeft = p_left;
			this.g2d_worldTop = p_top;
			this.g2d_worldRight = p_right;
			this.g2d_worldBottom = p_bottom;
			this.g2d_finalWidth = w;
			this.g2d_finalHeight = h;
		}
		this.g2d_preferredWidth = w;
		this.g2d_preferredHeight = h;
		this.setDirty();
	}
	,addChild: function(p_child) {
		if(p_child.g2d_parent == this) return;
		if(this.g2d_children == null) this.g2d_children = [];
		if(p_child.g2d_parent != null) p_child.g2d_parent.removeChild(p_child);
		this.g2d_children.push(p_child);
		this.g2d_numChildren++;
		p_child.g2d_parent = this;
		p_child.invalidateController();
		this.setDirty();
	}
	,addChildAt: function(p_child,p_index) {
		if(this.g2d_children == null) this.g2d_children = [];
		if(p_child.g2d_parent != null) p_child.g2d_parent.removeChild(p_child);
		this.g2d_children.splice(p_index,0,p_child);
		this.g2d_numChildren++;
		p_child.g2d_parent = this;
		p_child.invalidateController();
		this.setDirty();
	}
	,removeChild: function(p_child) {
		if(p_child.g2d_parent != this) return;
		HxOverrides.remove(this.g2d_children,p_child);
		this.g2d_numChildren--;
		p_child.g2d_parent = null;
		p_child.invalidateController();
		this.setDirty();
	}
	,getChildAt: function(p_index) {
		if(p_index >= 0 && p_index < this.g2d_numChildren) return this.g2d_children[p_index]; else return null;
	}
	,getChildByName: function(p_name,p_recursive) {
		if(p_recursive == null) p_recursive = false;
		var split = null;
		if(p_name.indexOf("->") != -1) split = p_name.split("->");
		var _g1 = 0;
		var _g = this.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.g2d_children[i].name == (split == null?p_name:split[0])) {
				if(split == null) return this.g2d_children[i]; else {
					split.shift();
					return this.g2d_children[i].getChildByName(split.join("->"),p_recursive);
				}
			}
			if(p_recursive) {
				var childByName = this.g2d_children[i].getChildByName(p_name,true);
				if(childByName != null) {
					if(split == null) return childByName; else {
						split.shift();
						return childByName.getChildByName(split.join("->"),true);
					}
				}
			}
		}
		return null;
	}
	,getChildIndex: function(p_child) {
		return HxOverrides.indexOf(this.g2d_children,p_child,0);
	}
	,calculateWidth: function() {
		if(this.g2d_dirty) {
			if(this.g2d_layout != null) this.g2d_layout.calculateWidth(this); else {
				if(this.g2d_activeSkin != null) this.g2d_minWidth = this.g2d_activeSkin.getMinWidth(); else this.g2d_minWidth = 0;
				var _g1 = 0;
				var _g = this.g2d_numChildren;
				while(_g1 < _g) {
					var i = _g1++;
					this.g2d_children[i].calculateWidth();
				}
			}
		}
	}
	,invalidateWidth: function() {
		if(this.g2d_dirty) {
			if(this.g2d_parent != null) {
				if(this.g2d_parent.g2d_layout == null) {
					var worldAnchorLeft = this.g2d_parent.g2d_worldLeft + this.g2d_parent.g2d_finalWidth * this.g2d_anchorLeft;
					var worldAnchorRight = this.g2d_parent.g2d_worldLeft + this.g2d_parent.g2d_finalWidth * this.g2d_anchorRight;
					var w;
					if(this.g2d_preferredWidth > this.g2d_minWidth || !this.expand) w = this.g2d_preferredWidth; else w = this.g2d_minWidth;
					if(this.g2d_anchorLeft != this.g2d_anchorRight) {
						this.g2d_worldLeft = worldAnchorLeft + this.g2d_left;
						this.g2d_worldRight = worldAnchorRight - this.g2d_right;
					} else {
						this.g2d_worldLeft = worldAnchorLeft + this.g2d_anchorX - w * this.g2d_pivotX;
						this.g2d_worldRight = worldAnchorLeft + this.g2d_anchorX + w * (1 - this.g2d_pivotX);
					}
					this.g2d_finalWidth = this.g2d_worldRight - this.g2d_worldLeft;
				}
				if(this.g2d_layout != null) this.g2d_layout.invalidateWidth(this); else {
					var _g1 = 0;
					var _g = this.g2d_numChildren;
					while(_g1 < _g) {
						var i = _g1++;
						this.g2d_children[i].invalidateWidth();
					}
				}
			} else {
				var _g11 = 0;
				var _g2 = this.g2d_numChildren;
				while(_g11 < _g2) {
					var i1 = _g11++;
					this.g2d_children[i1].invalidateWidth();
				}
			}
		}
	}
	,calculateHeight: function() {
		if(this.g2d_dirty) {
			if(this.g2d_layout != null) this.g2d_layout.calculateHeight(this); else {
				if(this.g2d_activeSkin != null) this.g2d_minHeight = this.g2d_activeSkin.getMinHeight(); else this.g2d_minHeight = 0;
				var _g1 = 0;
				var _g = this.g2d_numChildren;
				while(_g1 < _g) {
					var i = _g1++;
					this.g2d_children[i].calculateHeight();
				}
			}
		}
	}
	,invalidateHeight: function() {
		if(this.g2d_dirty) {
			if(this.g2d_parent != null) {
				if(this.g2d_parent.g2d_layout == null || !this.g2d_parent.g2d_layout.isVerticalLayout()) {
					var worldAnchorTop = this.g2d_parent.g2d_worldTop + this.g2d_parent.g2d_finalHeight * this.g2d_anchorTop;
					var worldAnchorBottom = this.g2d_parent.g2d_worldTop + this.g2d_parent.g2d_finalHeight * this.g2d_anchorBottom;
					var h;
					if(this.g2d_preferredHeight > this.g2d_minHeight || !this.expand) h = this.g2d_preferredHeight; else h = this.g2d_minHeight;
					if(this.g2d_anchorTop != this.g2d_anchorBottom) {
						this.g2d_worldTop = worldAnchorTop + this.g2d_top;
						this.g2d_worldBottom = worldAnchorBottom - this.g2d_bottom;
					} else {
						this.g2d_worldTop = worldAnchorTop + this.g2d_anchorY - h * this.g2d_pivotY;
						this.g2d_worldBottom = worldAnchorTop + this.g2d_anchorY + h * (1 - this.g2d_pivotY);
					}
					this.g2d_finalHeight = this.g2d_worldBottom - this.g2d_worldTop;
				}
				if(this.g2d_layout != null) this.g2d_layout.invalidateHeight(this); else {
					var _g1 = 0;
					var _g = this.g2d_numChildren;
					while(_g1 < _g) {
						var i = _g1++;
						this.g2d_children[i].invalidateHeight();
					}
				}
			} else {
				var _g11 = 0;
				var _g2 = this.g2d_numChildren;
				while(_g11 < _g2) {
					var i1 = _g11++;
					this.g2d_children[i1].invalidateHeight();
				}
			}
		}
	}
	,render: function(p_red,p_green,p_blue,p_alpha) {
		if(p_alpha == null) p_alpha = 1;
		if(p_blue == null) p_blue = 1;
		if(p_green == null) p_green = 1;
		if(p_red == null) p_red = 1;
		if(this.visible) {
			var worldRed = p_red * this.red;
			var worldGreen = p_green * this.green;
			var worldBlue = p_blue * this.blue;
			var worldAlpha = p_alpha * this.alpha;
			var context = ((function($this) {
				var $r;
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				$r = com_genome2d_Genome2D.g2d_instance;
				return $r;
			}(this))).getContext();
			var previousMask = context.getMaskRect();
			var camera = context.getActiveCamera();
			if(this.flushBatch || !this.expand) com_genome2d_ui_skin_GUISkin.flushBatch();
			if(!this.expand) context.setMaskRect(new com_genome2d_geom_GRectangle(this.g2d_worldLeft * camera.scaleX,this.g2d_worldTop * camera.scaleY,(this.g2d_worldRight - this.g2d_worldLeft) * camera.scaleX,(this.g2d_worldBottom - this.g2d_worldTop) * camera.scaleY));
			if(this.g2d_activeSkin != null) this.g2d_activeSkin.render(this.g2d_worldLeft,this.g2d_worldTop,this.g2d_worldRight,this.g2d_worldBottom,worldRed,worldGreen,worldBlue,worldAlpha);
			var _g1 = 0;
			var _g = this.g2d_numChildren;
			while(_g1 < _g) {
				var i = _g1++;
				this.g2d_children[i].render(worldRed,worldGreen,worldBlue,worldAlpha);
			}
			if(!this.expand) context.setMaskRect(previousMask);
		}
	}
	,getPrototype: function(p_prototype) {
		p_prototype = this.getPrototypeDefault(p_prototype);
		var _g1 = 0;
		var _g = this.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			p_prototype.addChild(this.g2d_children[i].getPrototype(),com_genome2d_ui_element_GUIElement.PROTOTYPE_DEFAULT_CHILD_GROUP);
		}
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		var group = p_prototype.getGroup(com_genome2d_ui_element_GUIElement.PROTOTYPE_DEFAULT_CHILD_GROUP);
		if(group != null) {
			var _g = 0;
			while(_g < group.length) {
				var prototype = group[_g];
				++_g;
				var prototype1 = com_genome2d_proto_GPrototypeFactory.createPrototype(prototype);
				if(js_Boot.__instanceof(prototype1,com_genome2d_ui_element_GUIElement)) this.addChild(prototype1);
			}
		}
		this.bindPrototypeDefault(p_prototype);
	}
	,disposeChildren: function() {
		while(this.g2d_numChildren > 0) this.g2d_children[this.g2d_numChildren - 1].dispose();
	}
	,dispose: function() {
		this.setDirty();
		if(this.g2d_parent != null) this.g2d_parent.removeChild(this);
	}
	,get_onMouseDown: function() {
		if(this.g2d_onMouseDown == null) this.g2d_onMouseDown = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseDown;
	}
	,get_onMouseUp: function() {
		if(this.g2d_onMouseUp == null) this.g2d_onMouseUp = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseUp;
	}
	,get_onMouseMove: function() {
		if(this.g2d_onMouseMove == null) this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseMove;
	}
	,get_onMouseOver: function() {
		if(this.g2d_onMouseOver == null) this.g2d_onMouseOver = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseOver;
	}
	,get_onMouseOut: function() {
		if(this.g2d_onMouseOut == null) this.g2d_onMouseOut = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseOut;
	}
	,get_onMouseClick: function() {
		if(this.g2d_onMouseClick == null) this.g2d_onMouseMove = new com_genome2d_callbacks_GCallback1(com_genome2d_input_GMouseInput);
		return this.g2d_onMouseClick;
	}
	,captureMouseInput: function(p_input) {
		if(this.visible) {
			if(this.mouseChildren) {
				var i = this.g2d_numChildren;
				while(i > 0) {
					i--;
					this.g2d_children[i].captureMouseInput(p_input);
				}
			}
			if(this.mouseEnabled) {
				if(p_input.g2d_captured && p_input.type == "mouseUp") this.g2d_mouseDownElement = null;
				p_input.localX = p_input.worldX - this.g2d_worldLeft;
				p_input.localY = p_input.worldY - this.g2d_worldTop;
				if(!p_input.g2d_captured && p_input.worldX > this.g2d_worldLeft && p_input.worldX < this.g2d_worldRight && p_input.worldY > this.g2d_worldTop && p_input.worldY < this.g2d_worldBottom) {
					if(this.g2d_activeSkin != null) this.g2d_activeSkin.captureMouseInput(p_input);
					p_input.g2d_captured = true;
					com_genome2d_input_GFocusManager.activeFocus = this;
					this.g2d_dispatchMouseCallback(p_input.type,this,p_input);
					if(this.g2d_mouseOverElement != this) this.g2d_dispatchMouseCallback("mouseOver",this,p_input);
				} else if(this.g2d_mouseOverElement == this) this.g2d_dispatchMouseCallback("mouseOut",this,p_input);
			}
		}
	}
	,mouseDown_handler: function(p_input) {
		this.g2d_movedMouseX = this.g2d_movedMouseY = 0;
		this.g2d_previousMouseX = p_input.contextX;
		this.g2d_previousMouseY = p_input.contextY;
		((function($this) {
			var $r;
			if(com_genome2d_Genome2D.g2d_instance == null) {
				com_genome2d_Genome2D.g2d_instantiable = true;
				new com_genome2d_Genome2D();
				com_genome2d_Genome2D.g2d_instantiable = false;
			}
			$r = com_genome2d_Genome2D.g2d_instance;
			return $r;
		}(this))).getContext().onMouseInput.add($bind(this,this.contextMouseInput_handler));
		this.g2d_parent.get_onMouseMove().add($bind(this,this.parentMouseMove_handler));
	}
	,parentMouseMove_handler: function(p_input) {
		this.g2d_movedMouseX += p_input.contextX - this.g2d_previousMouseX;
		if(this.g2d_dragging || Math.abs(this.g2d_movedMouseX) > com_genome2d_ui_element_GUIElement.dragSensitivity || Math.abs(this.g2d_movedMouseY) > com_genome2d_ui_element_GUIElement.dragSensitivity) {
			var _g = this;
			_g.g2d_anchorX = _g.g2d_anchorX + (p_input.contextX - this.g2d_previousMouseX) / p_input.camera.scaleX;
			_g.setDirty();
			_g.g2d_anchorX;
			if(this.g2d_anchorX > 0) {
				this.g2d_anchorX = 0;
				this.setDirty();
				this.g2d_anchorX;
			}
			if(this.g2d_anchorX < this.g2d_parent.g2d_finalWidth - this.g2d_minWidth) {
				this.g2d_anchorX = this.g2d_parent.g2d_finalWidth - this.g2d_minWidth;
				this.setDirty();
				this.g2d_anchorX;
			}
			this.g2d_dragging = true;
		}
		this.g2d_previousMouseX = p_input.contextX;
		this.g2d_previousMouseY = p_input.contextY;
	}
	,contextMouseInput_handler: function(p_input) {
		if(p_input.type == "mouseUp") {
			this.g2d_dragging = false;
			this.g2d_parent.get_onMouseMove().remove($bind(this,this.parentMouseMove_handler));
			((function($this) {
				var $r;
				if(com_genome2d_Genome2D.g2d_instance == null) {
					com_genome2d_Genome2D.g2d_instantiable = true;
					new com_genome2d_Genome2D();
					com_genome2d_Genome2D.g2d_instantiable = false;
				}
				$r = com_genome2d_Genome2D.g2d_instance;
				return $r;
			}(this))).getContext().onMouseInput.remove($bind(this,this.contextMouseInput_handler));
		}
	}
	,g2d_dispatchMouseCallback: function(p_type,p_element,p_input) {
		if(this.mouseEnabled) {
			var mouseInput = p_input.clone(this,p_element,p_type);
			switch(p_type) {
			case "mouseDown":
				this.g2d_mouseDownElement = p_element;
				if(this.g2d_onMouseDown != null) this.g2d_onMouseDown.dispatch(mouseInput);
				break;
			case "mouseMove":
				if(this.g2d_onMouseMove != null) this.g2d_onMouseMove.dispatch(mouseInput);
				break;
			case "mouseUp":
				if(this.g2d_mouseDownElement == p_element && this.g2d_onMouseClick != null) {
					var mouseClickInput = p_input.clone(this,p_element,"mouseUp");
					this.g2d_onMouseClick.dispatch(mouseClickInput);
				}
				this.g2d_mouseDownElement = null;
				if(this.g2d_onMouseUp != null) this.g2d_onMouseUp.dispatch(mouseInput);
				break;
			case "mouseOver":
				this.g2d_mouseOverElement = p_element;
				if(this.g2d_onMouseOver != null) this.g2d_onMouseOver.dispatch(mouseInput);
				break;
			case "mouseOut":
				this.g2d_mouseOverElement = null;
				if(this.g2d_onMouseOut != null) this.g2d_onMouseOut.dispatch(mouseInput);
				break;
			}
		}
		if(this.g2d_parent != null) this.g2d_parent.g2d_dispatchMouseCallback(p_type,p_element,p_input);
	}
	,setState: function(p_stateName) {
		this.setPrototypeState(p_stateName);
		if(this.g2d_children != null) {
			var _g = 0;
			var _g1 = this.g2d_children;
			while(_g < _g1.length) {
				var child = _g1[_g];
				++_g;
				child.setState(p_stateName);
			}
		}
	}
	,getState: function() {
		return this.g2d_currentState;
	}
	,getPrototypeDefault: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"element");
		return p_prototype;
	}
	,bindPrototypeDefault: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,toReference: function() {
		return "";
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_ui_element_GUIElement
	,__properties__: {get_onMouseClick:"get_onMouseClick",get_onMouseOut:"get_onMouseOut",get_onMouseOver:"get_onMouseOver",get_onMouseMove:"get_onMouseMove",get_onMouseUp:"get_onMouseUp",get_onMouseDown:"get_onMouseDown",get_children:"get_children",get_numChildren:"get_numChildren",get_parent:"get_parent",set_preferredHeight:"set_preferredHeight",get_preferredHeight:"get_preferredHeight",set_preferredWidth:"set_preferredWidth",get_preferredWidth:"get_preferredWidth",set_pivotY:"set_pivotY",get_pivotY:"get_pivotY",set_pivotX:"set_pivotX",get_pivotX:"get_pivotX",set_bottom:"set_bottom",get_bottom:"get_bottom",set_right:"set_right",get_right:"get_right",set_top:"set_top",get_top:"get_top",set_left:"set_left",get_left:"get_left",set_anchorBottom:"set_anchorBottom",get_anchorBottom:"get_anchorBottom",set_anchorRight:"set_anchorRight",get_anchorRight:"get_anchorRight",set_anchorTop:"set_anchorTop",get_anchorTop:"get_anchorTop",set_anchorLeft:"set_anchorLeft",get_anchorLeft:"get_anchorLeft",set_anchorY:"set_anchorY",get_anchorY:"get_anchorY",set_anchorX:"set_anchorX",get_anchorX:"get_anchorX",set_skin:"set_skin",get_skin:"get_skin",set_layout:"set_layout",get_layout:"get_layout",get_onModelChanged:"get_onModelChanged",set_mouseMove:"set_mouseMove",get_mouseMove:"get_mouseMove",set_mouseOut:"set_mouseOut",get_mouseOut:"get_mouseOut",set_mouseOver:"set_mouseOver",get_mouseOver:"get_mouseOver",set_mouseClick:"set_mouseClick",get_mouseClick:"get_mouseClick",set_mouseUp:"set_mouseUp",get_mouseUp:"get_mouseUp",set_mouseDown:"set_mouseDown",get_mouseDown:"get_mouseDown",set_scrollable:"set_scrollable",get_scrollable:"get_scrollable",set_color:"set_color",get_color:"get_color"}
};
var com_genome2d_ui_layout_GUILayout = function() {
	this.g2d_currentState = "default";
	this.type = 2;
};
com_genome2d_ui_layout_GUILayout.__name__ = true;
com_genome2d_ui_layout_GUILayout.__interfaces__ = [com_genome2d_proto_IGPrototypable];
com_genome2d_ui_layout_GUILayout.prototype = {
	calculateWidth: function(p_element) {
	}
	,invalidateWidth: function(p_element) {
	}
	,calculateHeight: function(p_element) {
	}
	,invalidateHeight: function(p_element) {
	}
	,isHorizontalLayout: function() {
		return this.type == 2;
	}
	,isVerticalLayout: function() {
		return this.type == 1;
	}
	,toReference: function() {
		return null;
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"layout");
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_ui_layout_GUILayout
};
var com_genome2d_ui_layout_GUIHorizontalLayout = function() {
	this.gap = 0;
	com_genome2d_ui_layout_GUILayout.call(this);
};
com_genome2d_ui_layout_GUIHorizontalLayout.__name__ = true;
com_genome2d_ui_layout_GUIHorizontalLayout.__super__ = com_genome2d_ui_layout_GUILayout;
com_genome2d_ui_layout_GUIHorizontalLayout.prototype = $extend(com_genome2d_ui_layout_GUILayout.prototype,{
	calculateWidth: function(p_element) {
		p_element.g2d_preferredWidth = p_element.g2d_minWidth = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.calculateWidth();
			p_element.g2d_minWidth += child.g2d_minWidth + this.gap;
			p_element.g2d_preferredWidth += (child.g2d_preferredWidth > child.g2d_minWidth?child.g2d_preferredWidth:child.g2d_minWidth) + this.gap;
		}
	}
	,invalidateWidth: function(p_element) {
		var offsetX = 0;
		var rest = p_element.g2d_finalWidth - p_element.g2d_minWidth;
		if(rest < 0) rest = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.g2d_worldLeft = p_element.g2d_worldLeft + offsetX;
			var childDif;
			if(child.g2d_preferredWidth > child.g2d_minWidth) childDif = child.g2d_preferredWidth - child.g2d_minWidth; else childDif = 0;
			if(rest < childDif) childDif = rest; else childDif = childDif;
			rest -= childDif;
			child.g2d_worldRight = child.g2d_worldLeft + child.g2d_minWidth + childDif;
			child.g2d_finalWidth = child.g2d_worldRight - child.g2d_worldLeft;
			offsetX += child.g2d_finalWidth + this.gap;
			child.invalidateWidth();
		}
	}
	,calculateHeight: function(p_element) {
		p_element.g2d_preferredHeight = p_element.g2d_minHeight = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.calculateHeight();
			if(p_element.g2d_minHeight < child.g2d_minHeight) p_element.g2d_minHeight = child.g2d_minHeight; else p_element.g2d_minHeight = p_element.g2d_minHeight;
		}
	}
	,invalidateHeight: function(p_element) {
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.invalidateHeight();
		}
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"horizontal");
		return com_genome2d_ui_layout_GUILayout.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_ui_layout_GUILayout.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_ui_layout_GUIHorizontalLayout
});
var com_genome2d_ui_layout_GUILayoutType = function() { };
com_genome2d_ui_layout_GUILayoutType.__name__ = true;
var com_genome2d_ui_layout_GUIVerticalLayout = function() {
	this.gap = 0;
	com_genome2d_ui_layout_GUILayout.call(this);
	this.type = 1;
};
com_genome2d_ui_layout_GUIVerticalLayout.__name__ = true;
com_genome2d_ui_layout_GUIVerticalLayout.__super__ = com_genome2d_ui_layout_GUILayout;
com_genome2d_ui_layout_GUIVerticalLayout.prototype = $extend(com_genome2d_ui_layout_GUILayout.prototype,{
	calculateWidth: function(p_element) {
		p_element.g2d_preferredWidth = p_element.g2d_minWidth = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.calculateWidth();
			if(p_element.g2d_minWidth < child.g2d_minWidth) p_element.g2d_minWidth = child.g2d_minWidth; else p_element.g2d_minWidth = p_element.g2d_minWidth;
			if(p_element.g2d_preferredWidth < child.g2d_preferredWidth) p_element.g2d_preferredWidth = child.g2d_preferredWidth; else p_element.g2d_preferredWidth = p_element.g2d_preferredWidth;
		}
	}
	,invalidateWidth: function(p_element) {
		var offsetX = 0;
		var rest = p_element.g2d_finalWidth - p_element.g2d_minWidth;
		if(rest < 0) rest = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.g2d_worldLeft = p_element.g2d_worldLeft;
			child.g2d_worldRight = child.g2d_worldLeft + p_element.g2d_finalWidth;
			child.g2d_finalWidth = p_element.g2d_finalWidth;
			child.invalidateWidth();
		}
	}
	,calculateHeight: function(p_element) {
		p_element.g2d_preferredHeight = p_element.g2d_minHeight = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.calculateHeight();
			p_element.g2d_minHeight += child.g2d_minHeight + this.gap;
			p_element.g2d_preferredHeight += child.g2d_preferredHeight + this.gap;
		}
	}
	,invalidateHeight: function(p_element) {
		var offsetY = 0;
		var rest = p_element.g2d_finalHeight - p_element.g2d_minHeight;
		if(rest < 0) rest = 0;
		var _g1 = 0;
		var _g = p_element.g2d_numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var child = p_element.g2d_children[i];
			child.g2d_worldTop = p_element.g2d_worldTop + offsetY;
			var childDif;
			if(child.g2d_preferredHeight > child.g2d_minHeight) childDif = child.g2d_preferredHeight - child.g2d_minHeight; else childDif = 0;
			if(rest < childDif) childDif = rest; else childDif = childDif;
			rest -= childDif;
			child.g2d_worldBottom = child.g2d_worldTop + child.g2d_minHeight + childDif;
			child.g2d_finalHeight = child.g2d_worldBottom - child.g2d_worldTop;
			offsetY += child.g2d_finalHeight + this.gap;
			child.invalidateHeight();
		}
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"vertical");
		return com_genome2d_ui_layout_GUILayout.prototype.getPrototype.call(this,p_prototype);
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_ui_layout_GUILayout.prototype.bindPrototype.call(this,p_prototype);
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,__class__: com_genome2d_ui_layout_GUIVerticalLayout
});
var com_genome2d_ui_skin_GUISkin = function(p_id,p_origin) {
	if(p_id == null) p_id = "";
	this.g2d_currentState = "default";
	com_genome2d_ui_skin_GUISkin.g2d_instanceCount++;
	this.g2d_origin = p_origin;
	if(this.g2d_origin == null) {
		this.set_id(p_id != ""?p_id:"GUISkin" + com_genome2d_ui_skin_GUISkin.g2d_instanceCount);
		this.g2d_clones = [];
	}
};
com_genome2d_ui_skin_GUISkin.__name__ = true;
com_genome2d_ui_skin_GUISkin.__interfaces__ = [com_genome2d_proto_IGPrototypable];
com_genome2d_ui_skin_GUISkin.batchRender = function(p_skin) {
	var batched = false;
	if(com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture != null && p_skin.getTexture() != null && !p_skin.getTexture().hasSameGPUTexture(com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture)) {
		com_genome2d_ui_skin_GUISkin.g2d_batchQueue.push(p_skin);
		batched = true;
	} else if(com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture == null && p_skin.getTexture() != null) com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture = p_skin.getTexture();
	return batched;
};
com_genome2d_ui_skin_GUISkin.flushBatch = function() {
	com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture = null;
	var queueLength = com_genome2d_ui_skin_GUISkin.g2d_batchQueue.length;
	var _g = 0;
	while(_g < queueLength) {
		var i = _g++;
		com_genome2d_ui_skin_GUISkin.g2d_batchQueue.shift().flushRender();
	}
	if(com_genome2d_ui_skin_GUISkin.g2d_batchQueue.length > 0) com_genome2d_ui_skin_GUISkin.flushBatch();
	com_genome2d_ui_skin_GUISkin.g2d_currentBatchTexture = null;
};
com_genome2d_ui_skin_GUISkin.fromReference = function(p_reference) {
	return com_genome2d_ui_skin_GUISkinManager.getSkin(HxOverrides.substr(p_reference,1,null));
};
com_genome2d_ui_skin_GUISkin.prototype = {
	get_id: function() {
		if(this.g2d_origin == null) return this.g2d_id; else return this.g2d_origin.g2d_id;
	}
	,set_id: function(p_value) {
		if(p_value != this.g2d_id && p_value.length > 0) {
			if(com_genome2d_ui_skin_GUISkinManager.getSkin(p_value) != null) com_genome2d_debug_GDebug.error("Duplicate skin id: " + p_value,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{ fileName : "GUISkin.hx", lineNumber : 46, className : "com.genome2d.ui.skin.GUISkin", methodName : "set_id"});
			com_genome2d_ui_skin_GUISkinManager.g2d_skins.set(p_value,this);
			if(com_genome2d_ui_skin_GUISkinManager.getSkin(this.g2d_id) != null) com_genome2d_ui_skin_GUISkinManager.g2d_skins.remove(this.g2d_id);
			this.g2d_id = p_value;
		}
		return this.g2d_id;
	}
	,getMinWidth: function() {
		return 0;
	}
	,getMinHeight: function() {
		return 0;
	}
	,render: function(p_left,p_top,p_right,p_bottom,p_red,p_green,p_blue,p_alpha) {
		this.g2d_renderLeft = p_left;
		this.g2d_renderTop = p_top;
		this.g2d_renderRight = p_right;
		this.g2d_renderBottom = p_bottom;
		this.g2d_renderRed = p_red;
		this.g2d_renderGreen = p_green;
		this.g2d_renderBlue = p_blue;
		this.g2d_renderAlpha = p_alpha;
		return !com_genome2d_ui_skin_GUISkin.batchRender(this);
	}
	,flushRender: function() {
		this.render(this.g2d_renderLeft,this.g2d_renderTop,this.g2d_renderRight,this.g2d_renderBottom,this.g2d_renderRed,this.g2d_renderGreen,this.g2d_renderBlue,this.g2d_renderAlpha);
	}
	,getTexture: function() {
		return null;
	}
	,attach: function(p_element) {
		var origin;
		if(this.g2d_origin == null) origin = this; else origin = this.g2d_origin;
		var clone = origin.clone();
		clone.g2d_element = p_element;
		clone.elementModelChanged_handler(p_element);
		p_element.g2d_onModelChanged.add($bind(clone,clone.elementModelChanged_handler));
		origin.g2d_clones.push(clone);
		return clone;
	}
	,remove: function() {
		if(this.g2d_origin != null) {
			HxOverrides.remove(this.g2d_origin.g2d_clones,this);
			if(this.g2d_element != null) {
				this.g2d_element.g2d_onModelChanged.remove($bind(this,this.elementModelChanged_handler));
				this.g2d_element = null;
			}
		}
	}
	,invalidateClones: function() {
	}
	,captureMouseInput: function(p_input) {
	}
	,elementModelChanged_handler: function(p_element) {
	}
	,clone: function() {
		return null;
	}
	,dispose: function() {
		if(this.g2d_origin == null) {
			while(this.g2d_clones.length > 0) this.g2d_clones[0].remove();
			if(com_genome2d_ui_skin_GUISkinManager.getSkin(this.g2d_origin == null?this.g2d_id:this.g2d_origin.g2d_id) != null) com_genome2d_ui_skin_GUISkinManager.g2d_removeSkin(this.g2d_origin == null?this.g2d_id:this.g2d_origin.g2d_id);
		} else this.g2d_origin.dispose();
	}
	,toReference: function() {
		return "@" + (this.g2d_origin == null?this.g2d_id:this.g2d_origin.g2d_id);
	}
	,getPrototype: function(p_prototype) {
		p_prototype = com_genome2d_proto_GPrototypeFactory.g2d_getPrototype(p_prototype,this,"GUISkin");
		return p_prototype;
	}
	,bindPrototype: function(p_prototype) {
		com_genome2d_proto_GPrototypeFactory.g2d_bindPrototype(this,p_prototype);
	}
	,setPrototypeState: function(p_stateName) {
		if(this.g2d_currentState != p_stateName) {
			var state = this.g2d_prototypeStates.g2d_states.get(p_stateName);
			if(state != null) {
				this.g2d_currentState = p_stateName;
				var $it0 = state.keys();
				while( $it0.hasNext() ) {
					var propertyName = $it0.next();
					(__map_reserved[propertyName] != null?state.getReserved(propertyName):state.h[propertyName]).bind(this);
				}
			} else {
				state = this.g2d_prototypeStates.g2d_states.get("na");
				if(state != null) {
					this.g2d_currentState = p_stateName;
					var $it1 = state.keys();
					while( $it1.hasNext() ) {
						var propertyName1 = $it1.next();
						(__map_reserved[propertyName1] != null?state.getReserved(propertyName1):state.h[propertyName1]).bind(this);
					}
				}
			}
		}
	}
	,__class__: com_genome2d_ui_skin_GUISkin
	,__properties__: {set_id:"set_id",get_id:"get_id"}
};
var com_genome2d_ui_skin_GUISkinManager = function() { };
com_genome2d_ui_skin_GUISkinManager.__name__ = true;
com_genome2d_ui_skin_GUISkinManager.init = function() {
	com_genome2d_ui_skin_GUISkin.g2d_batchQueue = [];
	com_genome2d_ui_skin_GUISkinManager.g2d_skins = new haxe_ds_StringMap();
};
com_genome2d_ui_skin_GUISkinManager.getSkin = function(p_id) {
	return com_genome2d_ui_skin_GUISkinManager.g2d_skins.get(p_id);
};
com_genome2d_ui_skin_GUISkinManager.g2d_addSkin = function(p_id,p_value) {
	com_genome2d_ui_skin_GUISkinManager.g2d_skins.set(p_id,p_value);
};
com_genome2d_ui_skin_GUISkinManager.g2d_removeSkin = function(p_id) {
	com_genome2d_ui_skin_GUISkinManager.g2d_skins.remove(p_id);
};
com_genome2d_ui_skin_GUISkinManager.getAllSkins = function() {
	return com_genome2d_ui_skin_GUISkinManager.g2d_skins;
};
com_genome2d_ui_skin_GUISkinManager.disposeAll = function() {
	var $it0 = com_genome2d_ui_skin_GUISkinManager.g2d_skins.iterator();
	while( $it0.hasNext() ) {
		var skin = $it0.next();
		if((skin.g2d_origin == null?skin.g2d_id:skin.g2d_origin.g2d_id).indexOf("g2d_") != 0) skin.dispose();
	}
};
var com_genome2d_utils_GHAlignType = function() { };
com_genome2d_utils_GHAlignType.__name__ = true;
var com_genome2d_utils_GRenderTargetStack = function() { };
com_genome2d_utils_GRenderTargetStack.__name__ = true;
com_genome2d_utils_GRenderTargetStack.pushRenderTarget = function(p_target,p_transform) {
	if(com_genome2d_utils_GRenderTargetStack.g2d_stack == null) {
		com_genome2d_utils_GRenderTargetStack.g2d_stack = [];
		com_genome2d_utils_GRenderTargetStack.g2d_transforms = [];
	}
	com_genome2d_utils_GRenderTargetStack.g2d_stack.push(p_target);
	com_genome2d_utils_GRenderTargetStack.g2d_transforms.push(p_transform);
};
com_genome2d_utils_GRenderTargetStack.popRenderTarget = function(p_context) {
	if(com_genome2d_utils_GRenderTargetStack.g2d_stack == null) return null;
	p_context.setRenderTarget(com_genome2d_utils_GRenderTargetStack.g2d_stack.pop(),com_genome2d_utils_GRenderTargetStack.g2d_transforms.pop(),false);
};
var com_genome2d_utils_GVAlignType = function() { };
com_genome2d_utils_GVAlignType.__name__ = true;
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
haxe_Http.__name__ = true;
haxe_Http.prototype = {
	request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js_Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				if (e instanceof js__$Boot_HaxeError) e = e.val;
				s = null;
			}
			if(s != null) {
				var protocol = window.location.protocol.toLowerCase();
				var rlocalProtocol = new EReg("^(?:about|app|app-storage|.+-extension|file|res|widget):$","");
				var isLocal = rlocalProtocol.match(protocol);
				if(isLocal) if(r.responseText != null) s = 200; else s = 404;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var _g_head = this.params.h;
			var _g_val = null;
			while(_g_head != null) {
				var p;
				p = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var _g_head1 = this.headers.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var h1;
			h1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe_Http
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = true;
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.stamp = function() {
	return new Date().getTime() / 1000;
};
haxe_Timer.prototype = {
	run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	__class__: haxe_ds_IntMap
};
var haxe_ds_ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
haxe_ds_ObjectMap.__name__ = true;
haxe_ds_ObjectMap.__interfaces__ = [haxe_IMap];
haxe_ds_ObjectMap.prototype = {
	set: function(key,value) {
		var id = key.__id__ || (key.__id__ = ++haxe_ds_ObjectMap.count);
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,remove: function(key) {
		var id = key.__id__;
		if(this.h.__keys__[id] == null) return false;
		delete(this.h[id]);
		delete(this.h.__keys__[id]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i.__id__];
		}};
	}
	,__class__: haxe_ds_ObjectMap
};
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe_ds__$StringMap_StringMapIterator.__name__ = true;
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,keys: function() {
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
haxe_io_FPHelper.__name__ = true;
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af;
	if(f < 0) af = -f; else af = f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av;
		if(v < 0) av = -v; else av = v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var sig;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		sig = Math.round(v1);
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var haxe_xml_Parser = function() { };
haxe_xml_Parser.__name__ = true;
haxe_xml_Parser.parse = function(str,strict) {
	if(strict == null) strict = false;
	var doc = Xml.createDocument();
	haxe_xml_Parser.doParse(str,strict,0,doc);
	return doc;
};
haxe_xml_Parser.doParse = function(str,strict,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	var escapeNext = 1;
	var attrValQuote = -1;
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				buf.addSub(str,start,p - start);
				var child = Xml.createPCData(buf.b);
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				escapeNext = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw new js__$Boot_HaxeError("Expected <![CDATA[");
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw new js__$Boot_HaxeError("Expected <!DOCTYPE");
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw new js__$Boot_HaxeError("Expected <!--"); else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw new js__$Boot_HaxeError("Expected node name");
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw new js__$Boot_HaxeError("Expected node name");
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				nsubs++;
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				break;
			case 62:
				state = 9;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw new js__$Boot_HaxeError("Expected attribute name");
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw new js__$Boot_HaxeError("Duplicate attribute");
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected =");
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				buf = new StringBuf();
				state = 8;
				start = p + 1;
				attrValQuote = c;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected \"");
			}
			break;
		case 8:
			switch(c) {
			case 38:
				buf.addSub(str,start,p - start);
				state = 18;
				escapeNext = 8;
				start = p + 1;
				break;
			case 62:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val = buf.b;
					buf = new StringBuf();
					xml.set(aname,val);
					state = 0;
					next = 4;
				}
				break;
			case 60:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val1 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val1);
					state = 0;
					next = 4;
				}
				break;
			default:
				if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val2 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val2);
					state = 0;
					next = 4;
				}
			}
			break;
		case 9:
			p = haxe_xml_Parser.doParse(str,strict,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw new js__$Boot_HaxeError("Expected node name");
				var v = HxOverrides.substr(str,start,p - start);
				if(v != (function($this) {
					var $r;
					if(parent.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + parent.nodeType);
					$r = parent.nodeName;
					return $r;
				}(this))) throw new js__$Boot_HaxeError("Expected </" + (function($this) {
					var $r;
					if(parent.nodeType != Xml.Element) throw "Bad node type, expected Element but found " + parent.nodeType;
					$r = parent.nodeName;
					return $r;
				}(this)) + ">");
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				var xml1 = Xml.createComment(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				var xml2 = Xml.createDocType(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml2);
				nsubs++;
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				var xml3 = Xml.createProcessingInstruction(str1);
				parent.addChild(xml3);
				nsubs++;
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var c1;
					if(s.charCodeAt(1) == 120) c1 = Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)); else c1 = Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += String.fromCharCode(c1);
				} else if(!haxe_xml_Parser.escapes.exists(s)) {
					if(strict) throw new js__$Boot_HaxeError("Undefined entity: " + s);
					buf.b += Std.string("&" + s + ";");
				} else buf.add(haxe_xml_Parser.escapes.get(s));
				start = p + 1;
				state = escapeNext;
			} else if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45) && c != 35) {
				if(strict) throw new js__$Boot_HaxeError("Invalid character in entity: " + String.fromCharCode(c));
				buf.b += "&";
				buf.addSub(str,start,p - start);
				p--;
				start = p + 1;
				state = escapeNext;
			}
			break;
		}
		c = StringTools.fastCodeAt(str,++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) {
			buf.addSub(str,start,p - start);
			var xml4 = Xml.createPCData(buf.b);
			parent.addChild(xml4);
			nsubs++;
		}
		return p;
	}
	if(!strict && state == 18 && escapeNext == 13) {
		buf.b += "&";
		buf.addSub(str,start,p - start);
		var xml5 = Xml.createPCData(buf.b);
		parent.addChild(xml5);
		nsubs++;
		return p;
	}
	throw new js__$Boot_HaxeError("Unexpected end");
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Browser = function() { };
js_Browser.__name__ = true;
js_Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw new js__$Boot_HaxeError("Unable to create XMLHttpRequest object.");
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
js_html_compat_ArrayBuffer.__name__ = true;
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	if(byteOffset == null) this.offset = 0; else this.offset = byteOffset;
	if(byteLength == null) this.length = buffer.byteLength - this.offset; else this.length = byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
js_html_compat_DataView.__name__ = true;
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		if(v >= 128) return v - 256; else return v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		if(v >= 32768) return v - 65536; else return v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		if(littleEndian) return this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8; else return this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		if(littleEndian) return a | b << 8 | c << 16 | d << 24; else return d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		if(v < 0) return v + 4294967296.; else return v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		if(value < 0) this.buf.a[byteOffset + this.offset] = value + 128 & 255; else this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
js_html_compat_Uint8Array.__name__ = true;
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var motion_actuators_IGenericActuator = function() { };
motion_actuators_IGenericActuator.__name__ = true;
motion_actuators_IGenericActuator.prototype = {
	__class__: motion_actuators_IGenericActuator
};
var motion_actuators_GenericActuator = function(target,duration,properties) {
	this._autoVisible = true;
	this._delay = 0;
	this._reflect = false;
	this._repeat = 0;
	this._reverse = false;
	this._smartRotation = false;
	this._snapping = false;
	this.special = false;
	this.target = target;
	this.properties = properties;
	this.duration = duration;
	this._ease = motion_Actuate.defaultEase;
};
motion_actuators_GenericActuator.__name__ = true;
motion_actuators_GenericActuator.__interfaces__ = [motion_actuators_IGenericActuator];
motion_actuators_GenericActuator.prototype = {
	apply: function() {
		var _g = 0;
		var _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(Object.prototype.hasOwnProperty.call(this.target,i)) Reflect.setField(this.target,i,Reflect.field(this.properties,i)); else Reflect.setProperty(this.target,i,Reflect.field(this.properties,i));
		}
	}
	,autoVisible: function(value) {
		if(value == null) value = true;
		this._autoVisible = value;
		return this;
	}
	,callMethod: function(method,params) {
		if(params == null) params = [];
		return Reflect.callMethod(method,method,params);
	}
	,change: function() {
		if(this._onUpdate != null) this.callMethod(this._onUpdate,this._onUpdateParams);
	}
	,complete: function(sendEvent) {
		if(sendEvent == null) sendEvent = true;
		if(sendEvent) {
			this.change();
			if(this._onComplete != null) this.callMethod(this._onComplete,this._onCompleteParams);
		}
		motion_Actuate.unload(this);
	}
	,delay: function(duration) {
		this._delay = duration;
		return this;
	}
	,ease: function(easing) {
		this._ease = easing;
		return this;
	}
	,move: function() {
	}
	,onComplete: function(handler,parameters) {
		this._onComplete = handler;
		if(parameters == null) this._onCompleteParams = []; else this._onCompleteParams = parameters;
		if(this.duration == 0) this.complete();
		return this;
	}
	,onRepeat: function(handler,parameters) {
		this._onRepeat = handler;
		if(parameters == null) this._onRepeatParams = []; else this._onRepeatParams = parameters;
		return this;
	}
	,onUpdate: function(handler,parameters) {
		this._onUpdate = handler;
		if(parameters == null) this._onUpdateParams = []; else this._onUpdateParams = parameters;
		return this;
	}
	,onPause: function(handler,parameters) {
		this._onPause = handler;
		if(parameters == null) this._onPauseParams = []; else this._onPauseParams = parameters;
		return this;
	}
	,onResume: function(handler,parameters) {
		this._onResume = handler;
		if(parameters == null) this._onResumeParams = []; else this._onResumeParams = parameters;
		return this;
	}
	,pause: function() {
		if(this._onPause != null) this.callMethod(this._onPause,this._onPauseParams);
	}
	,reflect: function(value) {
		if(value == null) value = true;
		this._reflect = value;
		this.special = true;
		return this;
	}
	,repeat: function(times) {
		if(times == null) times = -1;
		this._repeat = times;
		return this;
	}
	,resume: function() {
		if(this._onResume != null) this.callMethod(this._onResume,this._onResumeParams);
	}
	,reverse: function(value) {
		if(value == null) value = true;
		this._reverse = value;
		this.special = true;
		return this;
	}
	,smartRotation: function(value) {
		if(value == null) value = true;
		this._smartRotation = value;
		this.special = true;
		return this;
	}
	,snapping: function(value) {
		if(value == null) value = true;
		this._snapping = value;
		this.special = true;
		return this;
	}
	,stop: function(properties,complete,sendEvent) {
	}
	,__class__: motion_actuators_GenericActuator
};
var motion_actuators_SimpleActuator = function(target,duration,properties) {
	this.active = true;
	this.propertyDetails = [];
	this.sendChange = false;
	this.paused = false;
	this.cacheVisible = false;
	this.initialized = false;
	this.setVisible = false;
	this.toggleVisible = false;
	this.startTime = haxe_Timer.stamp();
	motion_actuators_GenericActuator.call(this,target,duration,properties);
	if(!motion_actuators_SimpleActuator.addedEvent) {
		motion_actuators_SimpleActuator.addedEvent = true;
		motion_actuators_SimpleActuator.timer = new haxe_Timer(33);
		motion_actuators_SimpleActuator.timer.run = motion_actuators_SimpleActuator.stage_onEnterFrame;
	}
};
motion_actuators_SimpleActuator.__name__ = true;
motion_actuators_SimpleActuator.stage_onEnterFrame = function() {
	var currentTime = haxe_Timer.stamp();
	var actuator;
	var j = 0;
	var cleanup = false;
	var _g1 = 0;
	var _g = motion_actuators_SimpleActuator.actuatorsLength;
	while(_g1 < _g) {
		var i = _g1++;
		actuator = motion_actuators_SimpleActuator.actuators[j];
		if(actuator != null && actuator.active) {
			if(currentTime >= actuator.timeOffset) actuator.update(currentTime);
			j++;
		} else {
			motion_actuators_SimpleActuator.actuators.splice(j,1);
			--motion_actuators_SimpleActuator.actuatorsLength;
		}
	}
};
motion_actuators_SimpleActuator.__super__ = motion_actuators_GenericActuator;
motion_actuators_SimpleActuator.prototype = $extend(motion_actuators_GenericActuator.prototype,{
	setField_motion_actuators_MotionPathActuator_T: function(target,propertyName,value) {
		if(Object.prototype.hasOwnProperty.call(target,propertyName)) target[propertyName] = value; else Reflect.setProperty(target,propertyName,value);
	}
	,setField_motion_actuators_SimpleActuator_T: function(target,propertyName,value) {
		if(Object.prototype.hasOwnProperty.call(target,propertyName)) target[propertyName] = value; else Reflect.setProperty(target,propertyName,value);
	}
	,autoVisible: function(value) {
		if(value == null) value = true;
		this._autoVisible = value;
		if(!value) {
			this.toggleVisible = false;
			if(this.setVisible) this.setField_motion_actuators_SimpleActuator_T(this.target,"visible",this.cacheVisible);
		}
		return this;
	}
	,delay: function(duration) {
		this._delay = duration;
		this.timeOffset = this.startTime + duration;
		return this;
	}
	,getField: function(target,propertyName) {
		var value = null;
		if(Object.prototype.hasOwnProperty.call(target,propertyName)) value = Reflect.field(target,propertyName); else value = Reflect.getProperty(target,propertyName);
		return value;
	}
	,initialize: function() {
		var details;
		var start;
		var _g = 0;
		var _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			var isField = true;
			if(Object.prototype.hasOwnProperty.call(this.target,i)) start = Reflect.field(this.target,i); else {
				isField = false;
				start = Reflect.getProperty(this.target,i);
			}
			if(typeof(start) == "number") {
				var value = this.getField(this.properties,i);
				if(start == null) start = 0;
				if(value == null) value = 0;
				details = new motion_actuators_PropertyDetails(this.target,i,start,value - start,isField);
				this.propertyDetails.push(details);
			}
		}
		this.detailsLength = this.propertyDetails.length;
		this.initialized = true;
	}
	,move: function() {
		this.toggleVisible = Object.prototype.hasOwnProperty.call(this.properties,"alpha") && Object.prototype.hasOwnProperty.call(this.properties,"visible");
		if(this.toggleVisible && this.properties.alpha != 0 && !this.getField(this.target,"visible")) {
			this.setVisible = true;
			this.cacheVisible = this.getField(this.target,"visible");
			this.setField_motion_actuators_SimpleActuator_T(this.target,"visible",true);
		}
		this.timeOffset = this.startTime;
		motion_actuators_SimpleActuator.actuators.push(this);
		++motion_actuators_SimpleActuator.actuatorsLength;
	}
	,onUpdate: function(handler,parameters) {
		this._onUpdate = handler;
		if(parameters == null) this._onUpdateParams = []; else this._onUpdateParams = parameters;
		this.sendChange = true;
		return this;
	}
	,pause: function() {
		if(!this.paused) {
			this.paused = true;
			motion_actuators_GenericActuator.prototype.pause.call(this);
			this.pauseTime = haxe_Timer.stamp();
		}
	}
	,resume: function() {
		if(this.paused) {
			this.paused = false;
			this.timeOffset += haxe_Timer.stamp() - this.pauseTime;
			motion_actuators_GenericActuator.prototype.resume.call(this);
		}
	}
	,setProperty: function(details,value) {
		if(details.isField) details.target[details.propertyName] = value; else Reflect.setProperty(details.target,details.propertyName,value);
	}
	,stop: function(properties,complete,sendEvent) {
		if(this.active) {
			if(properties == null) {
				this.active = false;
				if(complete) this.apply();
				this.complete(sendEvent);
				return;
			}
			var _g = 0;
			var _g1 = Reflect.fields(properties);
			while(_g < _g1.length) {
				var i = _g1[_g];
				++_g;
				if(Object.prototype.hasOwnProperty.call(this.properties,i)) {
					this.active = false;
					if(complete) this.apply();
					this.complete(sendEvent);
					return;
				}
			}
		}
	}
	,update: function(currentTime) {
		if(!this.paused) {
			var details;
			var easing;
			var i;
			var tweenPosition = (currentTime - this.timeOffset) / this.duration;
			if(tweenPosition > 1) tweenPosition = 1;
			if(!this.initialized) this.initialize();
			if(!this.special) {
				easing = this._ease.calculate(tweenPosition);
				var _g1 = 0;
				var _g = this.detailsLength;
				while(_g1 < _g) {
					var i1 = _g1++;
					details = this.propertyDetails[i1];
					this.setProperty(details,details.start + details.change * easing);
				}
			} else {
				if(!this._reverse) easing = this._ease.calculate(tweenPosition); else easing = this._ease.calculate(1 - tweenPosition);
				var endValue;
				var _g11 = 0;
				var _g2 = this.detailsLength;
				while(_g11 < _g2) {
					var i2 = _g11++;
					details = this.propertyDetails[i2];
					if(this._smartRotation && (details.propertyName == "rotation" || details.propertyName == "rotationX" || details.propertyName == "rotationY" || details.propertyName == "rotationZ")) {
						var rotation = details.change % 360;
						if(rotation > 180) rotation -= 360; else if(rotation < -180) rotation += 360;
						endValue = details.start + rotation * easing;
					} else endValue = details.start + details.change * easing;
					if(!this._snapping) {
						if(details.isField) details.target[details.propertyName] = endValue; else Reflect.setProperty(details.target,details.propertyName,endValue);
					} else this.setProperty(details,Math.round(endValue));
				}
			}
			if(tweenPosition == 1) {
				if(this._repeat == 0) {
					this.active = false;
					if(this.toggleVisible && this.getField(this.target,"alpha") == 0) this.setField_motion_actuators_SimpleActuator_T(this.target,"visible",false);
					this.complete(true);
					return;
				} else {
					if(this._onRepeat != null) this.callMethod(this._onRepeat,this._onRepeatParams);
					if(this._reflect) this._reverse = !this._reverse;
					this.startTime = currentTime;
					this.timeOffset = this.startTime + this._delay;
					if(this._repeat > 0) this._repeat--;
				}
			}
			if(this.sendChange) this.change();
		}
	}
	,__class__: motion_actuators_SimpleActuator
});
var motion_easing_Expo = function() { };
motion_easing_Expo.__name__ = true;
motion_easing_Expo.__properties__ = {get_easeOut:"get_easeOut",get_easeInOut:"get_easeInOut",get_easeIn:"get_easeIn"}
motion_easing_Expo.get_easeIn = function() {
	return new motion_easing_ExpoEaseIn();
};
motion_easing_Expo.get_easeInOut = function() {
	return new motion_easing_ExpoEaseInOut();
};
motion_easing_Expo.get_easeOut = function() {
	return new motion_easing_ExpoEaseOut();
};
var motion_easing_IEasing = function() { };
motion_easing_IEasing.__name__ = true;
motion_easing_IEasing.prototype = {
	__class__: motion_easing_IEasing
};
var motion_easing_ExpoEaseOut = function() {
};
motion_easing_ExpoEaseOut.__name__ = true;
motion_easing_ExpoEaseOut.__interfaces__ = [motion_easing_IEasing];
motion_easing_ExpoEaseOut.prototype = {
	calculate: function(k) {
		if(k == 1) return 1; else return 1 - Math.pow(2,-10 * k);
	}
	,ease: function(t,b,c,d) {
		if(t == d) return b + c; else return c * (1 - Math.pow(2,-10 * t / d)) + b;
	}
	,__class__: motion_easing_ExpoEaseOut
};
var motion_Actuate = function() { };
motion_Actuate.__name__ = true;
motion_Actuate.apply = function(target,properties,customActuator) {
	motion_Actuate.stop(target,properties);
	if(customActuator == null) customActuator = motion_Actuate.defaultActuator;
	var actuator = Type.createInstance(customActuator,[target,0,properties]);
	actuator.apply();
	return actuator;
};
motion_Actuate.getLibrary = function(target,allowCreation) {
	if(allowCreation == null) allowCreation = true;
	if(!(motion_Actuate.targetLibraries.h.__keys__[target.__id__] != null) && allowCreation) motion_Actuate.targetLibraries.set(target,[]);
	return motion_Actuate.targetLibraries.h[target.__id__];
};
motion_Actuate.isActive = function() {
	var result = false;
	var $it0 = motion_Actuate.targetLibraries.iterator();
	while( $it0.hasNext() ) {
		var library = $it0.next();
		result = true;
		break;
	}
	return result;
};
motion_Actuate.motionPath = function(target,duration,properties,overwrite) {
	if(overwrite == null) overwrite = true;
	return motion_Actuate.tween(target,duration,properties,overwrite,motion_actuators_MotionPathActuator);
};
motion_Actuate.pause = function(target) {
	if(js_Boot.__instanceof(target,motion_actuators_IGenericActuator)) {
		var actuator = target;
		actuator.pause();
	} else {
		var library = motion_Actuate.getLibrary(target,false);
		if(library != null) {
			var _g = 0;
			while(_g < library.length) {
				var actuator1 = library[_g];
				++_g;
				actuator1.pause();
			}
		}
	}
};
motion_Actuate.pauseAll = function() {
	var $it0 = motion_Actuate.targetLibraries.iterator();
	while( $it0.hasNext() ) {
		var library = $it0.next();
		var _g = 0;
		while(_g < library.length) {
			var actuator = library[_g];
			++_g;
			actuator.pause();
		}
	}
};
motion_Actuate.reset = function() {
	var $it0 = motion_Actuate.targetLibraries.iterator();
	while( $it0.hasNext() ) {
		var library = $it0.next();
		var i = library.length - 1;
		while(i >= 0) {
			library[i].stop(null,false,false);
			i--;
		}
	}
	motion_Actuate.targetLibraries = new haxe_ds_ObjectMap();
};
motion_Actuate.resume = function(target) {
	if(js_Boot.__instanceof(target,motion_actuators_IGenericActuator)) {
		var actuator = target;
		actuator.resume();
	} else {
		var library = motion_Actuate.getLibrary(target,false);
		if(library != null) {
			var _g = 0;
			while(_g < library.length) {
				var actuator1 = library[_g];
				++_g;
				actuator1.resume();
			}
		}
	}
};
motion_Actuate.resumeAll = function() {
	var $it0 = motion_Actuate.targetLibraries.iterator();
	while( $it0.hasNext() ) {
		var library = $it0.next();
		var _g = 0;
		while(_g < library.length) {
			var actuator = library[_g];
			++_g;
			actuator.resume();
		}
	}
};
motion_Actuate.stop = function(target,properties,complete,sendEvent) {
	if(sendEvent == null) sendEvent = true;
	if(complete == null) complete = false;
	if(target != null) {
		if(js_Boot.__instanceof(target,motion_actuators_IGenericActuator)) {
			var actuator = target;
			actuator.stop(null,complete,sendEvent);
		} else {
			var library = motion_Actuate.getLibrary(target,false);
			if(library != null) {
				if(typeof(properties) == "string") {
					var temp = { };
					Reflect.setField(temp,properties,null);
					properties = temp;
				} else if((properties instanceof Array) && properties.__enum__ == null) {
					var temp1 = { };
					var _g = 0;
					var _g1;
					_g1 = js_Boot.__cast(properties , Array);
					while(_g < _g1.length) {
						var property = _g1[_g];
						++_g;
						Reflect.setField(temp1,property,null);
					}
					properties = temp1;
				}
				var i = library.length - 1;
				while(i >= 0) {
					library[i].stop(properties,complete,sendEvent);
					i--;
				}
			}
		}
	}
};
motion_Actuate.timer = function(duration,customActuator) {
	return motion_Actuate.tween(new motion__$Actuate_TweenTimer(0),duration,new motion__$Actuate_TweenTimer(1),false,customActuator);
};
motion_Actuate.tween = function(target,duration,properties,overwrite,customActuator) {
	if(overwrite == null) overwrite = true;
	if(target != null) {
		if(duration > 0) {
			if(customActuator == null) customActuator = motion_Actuate.defaultActuator;
			var actuator = Type.createInstance(customActuator,[target,duration,properties]);
			var library = motion_Actuate.getLibrary(actuator.target);
			if(overwrite) {
				var i = library.length - 1;
				while(i >= 0) {
					library[i].stop(actuator.properties,false,false);
					i--;
				}
				library = motion_Actuate.getLibrary(actuator.target);
			}
			library.push(actuator);
			actuator.move();
			return actuator;
		} else return motion_Actuate.apply(target,properties,customActuator);
	}
	return null;
};
motion_Actuate.unload = function(actuator) {
	var target = actuator.target;
	if(motion_Actuate.targetLibraries.h.__keys__[target.__id__] != null) {
		HxOverrides.remove(motion_Actuate.targetLibraries.h[target.__id__],actuator);
		if(motion_Actuate.targetLibraries.h[target.__id__].length == 0) motion_Actuate.targetLibraries.remove(target);
	}
};
motion_Actuate.update = function(target,duration,start,end,overwrite) {
	if(overwrite == null) overwrite = true;
	var properties = { start : start, end : end};
	return motion_Actuate.tween(target,duration,properties,overwrite,motion_actuators_MethodActuator);
};
var motion__$Actuate_TweenTimer = function(progress) {
	this.progress = progress;
};
motion__$Actuate_TweenTimer.__name__ = true;
motion__$Actuate_TweenTimer.prototype = {
	__class__: motion__$Actuate_TweenTimer
};
var motion_MotionPath = function() {
	this._x = new motion_ComponentPath();
	this._y = new motion_ComponentPath();
	this._rotation = null;
};
motion_MotionPath.__name__ = true;
motion_MotionPath.prototype = {
	bezier: function(x,y,controlX,controlY,strength) {
		if(strength == null) strength = 1;
		this._x.addPath(new motion_BezierPath(x,controlX,strength));
		this._y.addPath(new motion_BezierPath(y,controlY,strength));
		return this;
	}
	,line: function(x,y,strength) {
		if(strength == null) strength = 1;
		this._x.addPath(new motion_LinearPath(x,strength));
		this._y.addPath(new motion_LinearPath(y,strength));
		return this;
	}
	,get_rotation: function() {
		if(this._rotation == null) this._rotation = new motion_RotationPath(this._x,this._y);
		return this._rotation;
	}
	,get_x: function() {
		return this._x;
	}
	,get_y: function() {
		return this._y;
	}
	,__class__: motion_MotionPath
	,__properties__: {get_y:"get_y",get_x:"get_x",get_rotation:"get_rotation"}
};
var motion_IComponentPath = function() { };
motion_IComponentPath.__name__ = true;
motion_IComponentPath.prototype = {
	__class__: motion_IComponentPath
	,__properties__: {get_end:"get_end"}
};
var motion_ComponentPath = function() {
	this.paths = [];
	this.start = 0;
	this.totalStrength = 0;
};
motion_ComponentPath.__name__ = true;
motion_ComponentPath.__interfaces__ = [motion_IComponentPath];
motion_ComponentPath.prototype = {
	addPath: function(path) {
		this.paths.push(path);
		this.totalStrength += path.strength;
	}
	,calculate: function(k) {
		if(this.paths.length == 1) return this.paths[0].calculate(this.start,k); else {
			var ratio = k * this.totalStrength;
			var lastEnd = this.start;
			var _g = 0;
			var _g1 = this.paths;
			while(_g < _g1.length) {
				var path = _g1[_g];
				++_g;
				if(ratio > path.strength) {
					ratio -= path.strength;
					lastEnd = path.end;
				} else return path.calculate(lastEnd,ratio / path.strength);
			}
		}
		return 0;
	}
	,get_end: function() {
		if(this.paths.length > 0) {
			var path = this.paths[this.paths.length - 1];
			return path.end;
		} else return this.start;
	}
	,__class__: motion_ComponentPath
	,__properties__: {get_end:"get_end"}
};
var motion_BezierPath = function(end,control,strength) {
	this.end = end;
	this.control = control;
	this.strength = strength;
};
motion_BezierPath.__name__ = true;
motion_BezierPath.prototype = {
	calculate: function(start,k) {
		return (1 - k) * (1 - k) * start + 2 * (1 - k) * k * this.control + k * k * this.end;
	}
	,__class__: motion_BezierPath
};
var motion_LinearPath = function(end,strength) {
	motion_BezierPath.call(this,end,0,strength);
};
motion_LinearPath.__name__ = true;
motion_LinearPath.__super__ = motion_BezierPath;
motion_LinearPath.prototype = $extend(motion_BezierPath.prototype,{
	calculate: function(start,k) {
		return start + k * (this.end - start);
	}
	,__class__: motion_LinearPath
});
var motion_RotationPath = function(x,y) {
	this.step = 0.01;
	this._x = x;
	this._y = y;
	this.offset = 0;
	this.start = this.calculate(0.0);
};
motion_RotationPath.__name__ = true;
motion_RotationPath.__interfaces__ = [motion_IComponentPath];
motion_RotationPath.prototype = {
	calculate: function(k) {
		var dX = this._x.calculate(k) - this._x.calculate(k + this.step);
		var dY = this._y.calculate(k) - this._y.calculate(k + this.step);
		var angle = Math.atan2(dY,dX) * (180 / Math.PI);
		angle = (angle + this.offset) % 360;
		return angle;
	}
	,get_end: function() {
		return this.calculate(1.0);
	}
	,__class__: motion_RotationPath
	,__properties__: {get_end:"get_end"}
};
var motion_actuators_MethodActuator = function(target,duration,properties) {
	this.currentParameters = [];
	this.tweenProperties = { };
	motion_actuators_SimpleActuator.call(this,target,duration,properties);
	if(!Object.prototype.hasOwnProperty.call(properties,"start")) this.properties.start = [];
	if(!Object.prototype.hasOwnProperty.call(properties,"end")) this.properties.end = this.properties.start;
	var _g1 = 0;
	var _g = this.properties.start.length;
	while(_g1 < _g) {
		var i = _g1++;
		this.currentParameters.push(this.properties.start[i]);
	}
};
motion_actuators_MethodActuator.__name__ = true;
motion_actuators_MethodActuator.__super__ = motion_actuators_SimpleActuator;
motion_actuators_MethodActuator.prototype = $extend(motion_actuators_SimpleActuator.prototype,{
	apply: function() {
		this.callMethod(this.target,this.properties.end);
	}
	,complete: function(sendEvent) {
		if(sendEvent == null) sendEvent = true;
		var _g1 = 0;
		var _g = this.properties.start.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.currentParameters[i] = Reflect.field(this.tweenProperties,"param" + i);
		}
		this.callMethod(this.target,this.currentParameters);
		motion_actuators_SimpleActuator.prototype.complete.call(this,sendEvent);
	}
	,initialize: function() {
		var details;
		var propertyName;
		var start;
		var _g1 = 0;
		var _g = this.properties.start.length;
		while(_g1 < _g) {
			var i = _g1++;
			propertyName = "param" + i;
			start = this.properties.start[i];
			this.tweenProperties[propertyName] = start;
			if(typeof(start) == "number" || ((start | 0) === start)) {
				details = new motion_actuators_PropertyDetails(this.tweenProperties,propertyName,start,this.properties.end[i] - start);
				this.propertyDetails.push(details);
			}
		}
		this.detailsLength = this.propertyDetails.length;
		this.initialized = true;
	}
	,update: function(currentTime) {
		motion_actuators_SimpleActuator.prototype.update.call(this,currentTime);
		if(this.active && !this.paused) {
			var _g1 = 0;
			var _g = this.properties.start.length;
			while(_g1 < _g) {
				var i = _g1++;
				this.currentParameters[i] = Reflect.field(this.tweenProperties,"param" + i);
			}
			this.callMethod(this.target,this.currentParameters);
		}
	}
	,__class__: motion_actuators_MethodActuator
});
var motion_actuators_MotionPathActuator = function(target,duration,properties) {
	motion_actuators_SimpleActuator.call(this,target,duration,properties);
};
motion_actuators_MotionPathActuator.__name__ = true;
motion_actuators_MotionPathActuator.__super__ = motion_actuators_SimpleActuator;
motion_actuators_MotionPathActuator.prototype = $extend(motion_actuators_SimpleActuator.prototype,{
	apply: function() {
		var _g = 0;
		var _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var propertyName = _g1[_g];
			++_g;
			if(Object.prototype.hasOwnProperty.call(this.target,propertyName)) Reflect.setField(this.target,propertyName,(js_Boot.__cast(Reflect.field(this.properties,propertyName) , motion_IComponentPath)).get_end()); else Reflect.setProperty(this.target,propertyName,(js_Boot.__cast(Reflect.field(this.properties,propertyName) , motion_IComponentPath)).get_end());
		}
	}
	,initialize: function() {
		var details;
		var path;
		var _g = 0;
		var _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var propertyName = _g1[_g];
			++_g;
			path = js_Boot.__cast(Reflect.field(this.properties,propertyName) , motion_IComponentPath);
			if(path != null) {
				var isField = true;
				if(Object.prototype.hasOwnProperty.call(this.target,propertyName)) path.start = Reflect.field(this.target,propertyName); else {
					isField = false;
					path.start = Reflect.getProperty(this.target,propertyName);
				}
				details = new motion_actuators_PropertyPathDetails(this.target,propertyName,path,isField);
				this.propertyDetails.push(details);
			}
		}
		this.detailsLength = this.propertyDetails.length;
		this.initialized = true;
	}
	,update: function(currentTime) {
		if(!this.paused) {
			var details;
			var easing;
			var tweenPosition = (currentTime - this.timeOffset) / this.duration;
			if(tweenPosition > 1) tweenPosition = 1;
			if(!this.initialized) this.initialize();
			if(!this.special) {
				easing = this._ease.calculate(tweenPosition);
				var _g = 0;
				var _g1 = this.propertyDetails;
				while(_g < _g1.length) {
					var details1 = _g1[_g];
					++_g;
					if(details1.isField) Reflect.setField(details1.target,details1.propertyName,(js_Boot.__cast(details1 , motion_actuators_PropertyPathDetails)).path.calculate(easing)); else Reflect.setProperty(details1.target,details1.propertyName,(js_Boot.__cast(details1 , motion_actuators_PropertyPathDetails)).path.calculate(easing));
				}
			} else {
				if(!this._reverse) easing = this._ease.calculate(tweenPosition); else easing = this._ease.calculate(1 - tweenPosition);
				var endValue;
				var _g2 = 0;
				var _g11 = this.propertyDetails;
				while(_g2 < _g11.length) {
					var details2 = _g11[_g2];
					++_g2;
					if(!this._snapping) {
						if(details2.isField) Reflect.setField(details2.target,details2.propertyName,(js_Boot.__cast(details2 , motion_actuators_PropertyPathDetails)).path.calculate(easing)); else Reflect.setProperty(details2.target,details2.propertyName,(js_Boot.__cast(details2 , motion_actuators_PropertyPathDetails)).path.calculate(easing));
					} else if(details2.isField) Reflect.setField(details2.target,details2.propertyName,Math.round((js_Boot.__cast(details2 , motion_actuators_PropertyPathDetails)).path.calculate(easing))); else Reflect.setProperty(details2.target,details2.propertyName,Math.round((js_Boot.__cast(details2 , motion_actuators_PropertyPathDetails)).path.calculate(easing)));
				}
			}
			if(tweenPosition == 1) {
				if(this._repeat == 0) {
					this.active = false;
					if(this.toggleVisible && this.getField(this.target,"alpha") == 0) this.setField_motion_actuators_MotionPathActuator_T(this.target,"visible",false);
					this.complete(true);
					return;
				} else {
					if(this._onRepeat != null) this.callMethod(this._onRepeat,this._onRepeatParams);
					if(this._reflect) this._reverse = !this._reverse;
					this.startTime = currentTime;
					this.timeOffset = this.startTime + this._delay;
					if(this._repeat > 0) this._repeat--;
				}
			}
			if(this.sendChange) this.change();
		}
	}
	,__class__: motion_actuators_MotionPathActuator
});
var motion_actuators_PropertyDetails = function(target,propertyName,start,change,isField) {
	if(isField == null) isField = true;
	this.target = target;
	this.propertyName = propertyName;
	this.start = start;
	this.change = change;
	this.isField = isField;
};
motion_actuators_PropertyDetails.__name__ = true;
motion_actuators_PropertyDetails.prototype = {
	__class__: motion_actuators_PropertyDetails
};
var motion_actuators_PropertyPathDetails = function(target,propertyName,path,isField) {
	if(isField == null) isField = true;
	motion_actuators_PropertyDetails.call(this,target,propertyName,0,0,isField);
	this.path = path;
};
motion_actuators_PropertyPathDetails.__name__ = true;
motion_actuators_PropertyPathDetails.__super__ = motion_actuators_PropertyDetails;
motion_actuators_PropertyPathDetails.prototype = $extend(motion_actuators_PropertyDetails.prototype,{
	__class__: motion_actuators_PropertyPathDetails
});
var motion_easing_ExpoEaseIn = function() {
};
motion_easing_ExpoEaseIn.__name__ = true;
motion_easing_ExpoEaseIn.__interfaces__ = [motion_easing_IEasing];
motion_easing_ExpoEaseIn.prototype = {
	calculate: function(k) {
		if(k == 0) return 0; else return Math.pow(2,10 * (k - 1));
	}
	,ease: function(t,b,c,d) {
		if(t == 0) return b; else return c * Math.pow(2,10 * (t / d - 1)) + b;
	}
	,__class__: motion_easing_ExpoEaseIn
};
var motion_easing_ExpoEaseInOut = function() {
};
motion_easing_ExpoEaseInOut.__name__ = true;
motion_easing_ExpoEaseInOut.__interfaces__ = [motion_easing_IEasing];
motion_easing_ExpoEaseInOut.prototype = {
	calculate: function(k) {
		if(k == 0) return 0;
		if(k == 1) return 1;
		if((k /= 0.5) < 1.0) return 0.5 * Math.pow(2,10 * (k - 1));
		return 0.5 * (2 - Math.pow(2,-10 * --k));
	}
	,ease: function(t,b,c,d) {
		if(t == 0) return b;
		if(t == d) return b + c;
		if((t /= d / 2.0) < 1.0) return c / 2 * Math.pow(2,10 * (t - 1)) + b;
		return c / 2 * (2 - Math.pow(2,-10 * --t)) + b;
	}
	,__class__: motion_easing_ExpoEaseInOut
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
var ArrayBuffer = $global.ArrayBuffer || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = $global.DataView || js_html_compat_DataView;
var Uint8Array = $global.Uint8Array || js_html_compat_Uint8Array._new;
com_genome2d_components_GComponent.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_components_GComponent.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_components_GComponent.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_components_GComponent.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_components_GComponent.PROTOTYPE_NAME = "GComponent";
com_genome2d_components_GComponent.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
EmitterUI.g2d_count = 0;
EmitterUI.PROTOTYPE_PROPERTY_DEFAULTS = [];
EmitterUI.PROTOTYPE_PROPERTY_NAMES = [];
EmitterUI.PROTOTYPE_PROPERTY_TYPES = [];
EmitterUI.PROTOTYPE_PROPERTY_EXTRAS = [];
EmitterUI.PROTOTYPE_NAME = "EmitterUI";
EmitterUI.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_proto_GPrototypeHelper.GComponent = "com.genome2d.components.GComponent";
com_genome2d_proto_GPrototypeHelper.GParticleSystem = "com.genome2d.components.renderable.particles.GParticleSystem";
com_genome2d_proto_GPrototypeHelper.GCameraController = "com.genome2d.components.GCameraController";
com_genome2d_proto_GPrototypeHelper.GUISkin = "com.genome2d.ui.skin.GUISkin";
com_genome2d_proto_GPrototypeHelper.GUIElement = "com.genome2d.ui.element.GUIElement";
com_genome2d_proto_GPrototypeHelper.element = "com.genome2d.ui.element.GUIElement";
com_genome2d_proto_GPrototypeHelper.GUILayout = "com.genome2d.ui.layout.GUILayout";
com_genome2d_proto_GPrototypeHelper.layout = "com.genome2d.ui.layout.GUILayout";
com_genome2d_proto_GPrototypeHelper.GUIHorizontalLayout = "com.genome2d.ui.layout.GUIHorizontalLayout";
com_genome2d_proto_GPrototypeHelper.horizontal = "com.genome2d.ui.layout.GUIHorizontalLayout";
com_genome2d_proto_GPrototypeHelper.GTexturedQuad = "com.genome2d.components.renderable.GTexturedQuad";
com_genome2d_proto_GPrototypeHelper.GSprite = "com.genome2d.components.renderable.GSprite";
com_genome2d_proto_GPrototypeHelper.GNode = "com.genome2d.node.GNode";
com_genome2d_proto_GPrototypeHelper.node = "com.genome2d.node.GNode";
com_genome2d_proto_GPrototypeHelper.GTextureFont = "com.genome2d.text.GTextureFont";
com_genome2d_proto_GPrototypeHelper.GTextureBase = "com.genome2d.textures.GTextureBase";
com_genome2d_proto_GPrototypeHelper.GTexture = "com.genome2d.textures.GTexture";
com_genome2d_proto_GPrototypeHelper.GUIVerticalLayout = "com.genome2d.ui.layout.GUIVerticalLayout";
com_genome2d_proto_GPrototypeHelper.vertical = "com.genome2d.ui.layout.GUIVerticalLayout";
com_genome2d_proto_GPrototypeHelper.EmitterUI = "EmitterUI";
Xml.Element = 0;
Xml.PCData = 1;
Xml.CData = 2;
Xml.Comment = 3;
Xml.DocType = 4;
Xml.ProcessingInstruction = 5;
Xml.Document = 6;
com_genome2d_Genome2D.VERSION = "1.1";
com_genome2d_Genome2D.BUILD = "d97e92c3d0f796668d6ccb71d2a770bc";
com_genome2d_Genome2D.DATE = "2016-01-27 16:30:25";
com_genome2d_Genome2D.g2d_instantiable = false;
com_genome2d_assets_GAsset.__meta__ = { obj : { prototypeName : ["asset"]}, fields : { id : { prototype : null}, url : { prototype : null}}};
com_genome2d_assets_GAssetManager.PATH_REGEX = new EReg("([^\\?/\\\\]+?)(?:\\.([\\w\\-]+))?(?:\\?.*)?$","");
com_genome2d_assets_GAssetManager.ignoreFailed = false;
com_genome2d_assets_GImageAssetType.BITMAPDATA = 0;
com_genome2d_assets_GImageAssetType.ATF = 1;
com_genome2d_assets_GImageAssetType.IMAGEELEMENT = 2;
com_genome2d_components_GCameraController.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_components_GCameraController.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_components_GCameraController.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_components_GCameraController.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_components_GCameraController.PROTOTYPE_NAME = "GCameraController";
com_genome2d_components_GCameraController.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_components_renderable_GTexturedQuad.__meta__ = { fields : { blendMode : { prototype : null}, texture : { prototype : ["getReference"]}}};
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_PROPERTY_DEFAULTS = [1,null];
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_PROPERTY_NAMES = ["blendMode","texture"];
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_PROPERTY_TYPES = ["Int","GTexture"];
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_PROPERTY_EXTRAS = [0,2];
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_NAME = "GTexturedQuad";
com_genome2d_components_renderable_GTexturedQuad.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_components_renderable_GSprite.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_components_renderable_GSprite.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_components_renderable_GSprite.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_components_renderable_GSprite.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_components_renderable_GSprite.PROTOTYPE_NAME = "GSprite";
com_genome2d_components_renderable_GSprite.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_NAME = "GParticleSystem";
com_genome2d_components_renderable_particles_GParticleSystem.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_context_GBlendMode.blendFactors = [[[1,0],[770,771],[770,32970],[32968,771],[770,1],[0,771]],[[1,0],[1,771],[1,1],[32968,771],[1,769],[0,771]]];
com_genome2d_context_GBlendMode.NONE = 0;
com_genome2d_context_GBlendMode.NORMAL = 1;
com_genome2d_context_GBlendMode.ADD = 2;
com_genome2d_context_GBlendMode.MULTIPLY = 3;
com_genome2d_context_GBlendMode.SCREEN = 4;
com_genome2d_context_GBlendMode.ERASE = 5;
com_genome2d_context_GContextFeature.STENCIL_MASKING = 1;
com_genome2d_context_GContextFeature.RECTANGLE_TEXTURES = 2;
com_genome2d_context_stats_GStats.fps = 0;
com_genome2d_context_stats_GStats.drawCalls = 0;
com_genome2d_context_stats_GStats.nodeCount = 0;
com_genome2d_context_stats_GStats.x = 0;
com_genome2d_context_stats_GStats.y = 0;
com_genome2d_context_stats_GStats.scaleX = 1;
com_genome2d_context_stats_GStats.scaleY = 1;
com_genome2d_context_stats_GStats.visible = false;
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.BATCH_SIZE = 30;
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.TRANSFORM_PER_VERTEX = 3;
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.TRANSFORM_PER_VERTEX_ALPHA = 4;
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.VERTEX_SHADER_CODE_ALPHA = "\r\n\t\t\tuniform mat4 projectionMatrix;\r\n\t\t\tuniform vec4 transforms[" + 120 + "];\r\n\r\n\t\t\tattribute vec2 aPosition;\r\n\t\t\tattribute vec2 aTexCoord;\r\n\t\t\tattribute vec4 aConstantIndex;\r\n\r\n\t\t\tvarying vec2 vTexCoord;\r\n\t\t\tvarying vec4 vColor;\r\n\r\n\t\t\tvoid main(void)\r\n\t\t\t{\r\n\t\t\t\tgl_Position = vec4(aPosition.x*transforms[int(aConstantIndex.z)].x, aPosition.y*transforms[int(aConstantIndex.z)].y, 0, 1);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x - transforms[int(aConstantIndex.z)].z, gl_Position.y - transforms[int(aConstantIndex.z)].w, 0, 1);\r\n\t\t\t\tfloat c = cos(transforms[int(aConstantIndex.x)].z);\r\n\t\t\t\tfloat s = sin(transforms[int(aConstantIndex.x)].z);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x * c - gl_Position.y * s, gl_Position.x * s + gl_Position.y * c, 0, 1);\r\n\t\t\t\tgl_Position = vec4(gl_Position.x+transforms[int(aConstantIndex.x)].x, gl_Position.y+transforms[int(aConstantIndex.x)].y, 0, 1);\r\n\t\t\t\tgl_Position = gl_Position * projectionMatrix;\r\n\r\n\t\t\t\tvTexCoord = vec2(aTexCoord.x*transforms[int(aConstantIndex.y)].z+transforms[int(aConstantIndex.y)].x, aTexCoord.y*transforms[int(aConstantIndex.y)].w+transforms[int(aConstantIndex.y)].y);\r\n\t\t\t\tvColor = transforms[int(aConstantIndex.w)];\r\n\t\t\t}\r\n\t\t ";
com_genome2d_context_webgl_renderers_GQuadTextureShaderRenderer.FRAGMENT_SHADER_CODE_ALPHA = "\r\n\t\t\t//#ifdef GL_ES\r\n\t\t\tprecision lowp float;\r\n\t\t\t//#endif\r\n\r\n\t\t\tvarying vec2 vTexCoord;\r\n\t\t\tvarying vec4 vColor;\r\n\r\n\t\t\tuniform sampler2D sTexture;\r\n\r\n\t\t\tvoid main(void)\r\n\t\t\t{\r\n\t\t\t\tgl_FragColor = texture2D(sTexture, vTexCoord) * vColor;\r\n\t\t\t}\r\n\t\t";
com_genome2d_debug_GDebug.g2d_console = "";
com_genome2d_debug_GDebug.showPriority = 1;
com_genome2d_debug_GDebug.stackTrace = true;
com_genome2d_debug_GDebugPriority.INTERNAL_DUMP = 0;
com_genome2d_debug_GDebugPriority.AUTO_DUMP = 1;
com_genome2d_debug_GDebugPriority.DUMP = 2;
com_genome2d_debug_GDebugPriority.INFO = 3;
com_genome2d_debug_GDebugPriority.WARNING = 4;
com_genome2d_debug_GDebugPriority.ERROR = 5;
com_genome2d_debug_GDebugPriority.PROFILE = 100;
com_genome2d_input_GKeyboardInputType.KEY_DOWN = "keyDown";
com_genome2d_input_GKeyboardInputType.KEY_UP = "keyUp";
com_genome2d_input_GMouseInputType.MOUSE_DOWN = "mouseDown";
com_genome2d_input_GMouseInputType.MOUSE_MOVE = "mouseMove";
com_genome2d_input_GMouseInputType.MOUSE_UP = "mouseUp";
com_genome2d_input_GMouseInputType.MOUSE_OVER = "mouseOver";
com_genome2d_input_GMouseInputType.MOUSE_OUT = "mouseOut";
com_genome2d_input_GMouseInputType.RIGHT_MOUSE_DOWN = "rightMouseDown";
com_genome2d_input_GMouseInputType.RIGHT_MOUSE_UP = "rightMouseUp";
com_genome2d_input_GMouseInputType.MOUSE_WHEEL = "mouseWheel";
com_genome2d_node_GNode.__meta__ = { obj : { prototypeName : ["node"]}, fields : { useWorldSpace : { prototype : null}, useWorldColor : { prototype : null}, x : { prototype : null}, y : { prototype : null}, scaleX : { prototype : null}, scaleY : { prototype : null}, rotation : { prototype : null}, red : { prototype : null}, green : { prototype : null}, blue : { prototype : null}, alpha : { prototype : null}}};
com_genome2d_node_GNode.g2d_nodeCount = 0;
com_genome2d_node_GNode.PROTOTYPE_PROPERTY_DEFAULTS = [false,false,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
com_genome2d_node_GNode.PROTOTYPE_PROPERTY_NAMES = ["useWorldSpace","useWorldColor","x","y","scaleX","scaleY","rotation","red","green","blue","alpha"];
com_genome2d_node_GNode.PROTOTYPE_PROPERTY_TYPES = ["Bool","Bool","Float","Float","Float","Float","Float","Float","Float","Float","Float"];
com_genome2d_node_GNode.PROTOTYPE_PROPERTY_EXTRAS = [0,0,0,0,0,0,0,0,0,0,0];
com_genome2d_node_GNode.PROTOTYPE_NAME = "node";
com_genome2d_node_GNode.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_particles_GNewParticlePool.g2d_defaultPool = new com_genome2d_particles_GNewParticlePool();
com_genome2d_particles_GParticlePool.g2d_defaultPool = new com_genome2d_particles_GParticlePool();
com_genome2d_particles_GSPHParticleSystem.PRESSURE = 1;
com_genome2d_particles_GSPHParticleSystem.NEAR_PRESSURE = 1;
com_genome2d_particles_GSPHParticleSystem.RANGE = 16;
com_genome2d_particles_GSPHParticleSystem.RANGE2 = 256.;
com_genome2d_postprocess_GPostProcess.g2d_count = 0;
com_genome2d_proto_GPrototypeExtras.SETTER = 1;
com_genome2d_proto_GPrototypeExtras.REFERENCE_GETTER = 2;
com_genome2d_proto_GPrototypeExtras.IGNORE_AUTO_BIND = 4;
com_genome2d_proto_GPrototypeFactory.g2d_lookupsInitialized = false;
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_NAME = "PROTOTYPE_NAME";
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_PROPERTY_NAMES = "PROTOTYPE_PROPERTY_NAMES";
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_PROPERTY_TYPES = "PROTOTYPE_PROPERTY_TYPES";
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_PROPERTY_EXTRAS = "PROTOTYPE_PROPERTY_EXTRAS";
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_PROPERTY_DEFAULTS = "PROTOTYPE_PROPERTY_DEFAULTS";
com_genome2d_proto_GPrototypeSpecs.PROTOTYPE_DEFAULT_CHILD_GROUP = "PROTOTYPE_DEFAULT_CHILD_GROUP";
com_genome2d_text_GTextureFont.__meta__ = { fields : { texture : { prototype : null}, id : { prototype : null}, lineHeight : { prototype : null}}};
com_genome2d_text_GTextureFont.PROTOTYPE_PROPERTY_DEFAULTS = [null,"",0];
com_genome2d_text_GTextureFont.PROTOTYPE_PROPERTY_NAMES = ["texture","id","lineHeight"];
com_genome2d_text_GTextureFont.PROTOTYPE_PROPERTY_TYPES = ["GTexture","String","Int"];
com_genome2d_text_GTextureFont.PROTOTYPE_PROPERTY_EXTRAS = [0,0,0];
com_genome2d_text_GTextureFont.PROTOTYPE_NAME = "GTextureFont";
com_genome2d_text_GTextureFont.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_textures_GTextureBase.g2d_instanceCount = 0;
com_genome2d_textures_GTextureBase.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_textures_GTextureBase.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_textures_GTextureBase.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_textures_GTextureBase.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_textures_GTextureBase.PROTOTYPE_NAME = "GTextureBase";
com_genome2d_textures_GTextureBase.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_textures_GTexture.PROTOTYPE_PROPERTY_DEFAULTS = [];
com_genome2d_textures_GTexture.PROTOTYPE_PROPERTY_NAMES = [];
com_genome2d_textures_GTexture.PROTOTYPE_PROPERTY_TYPES = [];
com_genome2d_textures_GTexture.PROTOTYPE_PROPERTY_EXTRAS = [];
com_genome2d_textures_GTexture.PROTOTYPE_NAME = "GTexture";
com_genome2d_textures_GTexture.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_textures_GTextureFilteringType.NEAREST = 0;
com_genome2d_textures_GTextureFilteringType.LINEAR = 1;
com_genome2d_textures_GTextureManager.defaultFilteringType = 1;
com_genome2d_textures_GTextureSourceType.BITMAPDATA = 1;
com_genome2d_textures_GTextureSourceType.BYTEARRAY = 2;
com_genome2d_textures_GTextureSourceType.RENDER_TARGET = 3;
com_genome2d_textures_GTextureSourceType.ATF_BGRA = 4;
com_genome2d_textures_GTextureSourceType.ATF_COMPRESSED = 5;
com_genome2d_textures_GTextureSourceType.ATF_COMPRESSEDALPHA = 6;
com_genome2d_textures_GTextureSourceType.TEXTURE = 7;
com_genome2d_textures_GTextureSourceType.IMAGE = 8;
com_genome2d_ui_element_GUIElement.__meta__ = { obj : { prototypeName : ["element"], prototypeDefaultChildGroup : ["element"]}, fields : { alpha : { prototype : null}, color : { prototype : null}, mouseEnabled : { prototype : null}, mouseChildren : { prototype : null}, visible : { prototype : null}, flushBatch : { prototype : null}, name : { prototype : null}, scrollable : { prototype : null}, setAlign : { prototype : null}, setAnchorAlign : { prototype : null}, setPivotAlign : { prototype : null}, mouseDown : { prototype : null}, mouseUp : { prototype : null}, mouseClick : { prototype : null}, mouseOver : { prototype : null}, mouseOut : { prototype : null}, mouseMove : { prototype : null}, setModel : { prototype : null}, layout : { prototype : null}, skin : { prototype : ["getReference"]}, anchorX : { prototype : null}, anchorY : { prototype : null}, anchorLeft : { prototype : null}, anchorTop : { prototype : null}, anchorRight : { prototype : null}, anchorBottom : { prototype : null}, left : { prototype : null}, top : { prototype : null}, right : { prototype : null}, bottom : { prototype : null}, pivotX : { prototype : null}, pivotY : { prototype : null}, expand : { prototype : null}, preferredWidth : { prototype : null}, preferredHeight : { prototype : null}}};
com_genome2d_ui_element_GUIElement.dragSensitivity = 0;
com_genome2d_ui_element_GUIElement.PROTOTYPE_PROPERTY_DEFAULTS = [1,0,true,true,true,false,"",false,null,null,null,"","","","","","",null,null,null,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,true,0.0,0.0];
com_genome2d_ui_element_GUIElement.PROTOTYPE_PROPERTY_NAMES = ["alpha","color","mouseEnabled","mouseChildren","visible","flushBatch","name","scrollable","setAlign","setAnchorAlign","setPivotAlign","mouseDown","mouseUp","mouseClick","mouseOver","mouseOut","mouseMove","setModel","layout","skin","anchorX","anchorY","anchorLeft","anchorTop","anchorRight","anchorBottom","left","top","right","bottom","pivotX","pivotY","expand","preferredWidth","preferredHeight"];
com_genome2d_ui_element_GUIElement.PROTOTYPE_PROPERTY_TYPES = ["Float","Int","Bool","Bool","Bool","Bool","String","Bool","Int","Int","Int","String","String","String","String","String","String","Dynamic","GUILayout","GUISkin","Float","Float","Float","Float","Float","Float","Float","Float","Float","Float","Float","Float","Bool","Float","Float"];
com_genome2d_ui_element_GUIElement.PROTOTYPE_PROPERTY_EXTRAS = [0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
com_genome2d_ui_element_GUIElement.PROTOTYPE_NAME = "element";
com_genome2d_ui_element_GUIElement.PROTOTYPE_DEFAULT_CHILD_GROUP = "element";
com_genome2d_ui_layout_GUILayout.__meta__ = { obj : { prototypeName : ["layout"]}, fields : { type : { prototype : null}}};
com_genome2d_ui_layout_GUILayout.PROTOTYPE_PROPERTY_DEFAULTS = [2];
com_genome2d_ui_layout_GUILayout.PROTOTYPE_PROPERTY_NAMES = ["type"];
com_genome2d_ui_layout_GUILayout.PROTOTYPE_PROPERTY_TYPES = ["Int"];
com_genome2d_ui_layout_GUILayout.PROTOTYPE_PROPERTY_EXTRAS = [0];
com_genome2d_ui_layout_GUILayout.PROTOTYPE_NAME = "layout";
com_genome2d_ui_layout_GUILayout.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_ui_layout_GUIHorizontalLayout.__meta__ = { obj : { prototypeName : ["horizontal"]}, fields : { gap : { prototype : null}}};
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_PROPERTY_DEFAULTS = [0];
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_PROPERTY_NAMES = ["gap"];
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_PROPERTY_TYPES = ["Float"];
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_PROPERTY_EXTRAS = [0];
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_NAME = "horizontal";
com_genome2d_ui_layout_GUIHorizontalLayout.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_ui_layout_GUILayoutType.VERTICAL = 1;
com_genome2d_ui_layout_GUILayoutType.HORIZONTAL = 2;
com_genome2d_ui_layout_GUILayoutType.GRID_VERTICAL = 3;
com_genome2d_ui_layout_GUILayoutType.GRID_HORIZONTAL = 4;
com_genome2d_ui_layout_GUIVerticalLayout.__meta__ = { obj : { prototypeName : ["vertical"]}, fields : { gap : { prototype : null}}};
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_PROPERTY_DEFAULTS = [0];
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_PROPERTY_NAMES = ["gap"];
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_PROPERTY_TYPES = ["Float"];
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_PROPERTY_EXTRAS = [0];
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_NAME = "vertical";
com_genome2d_ui_layout_GUIVerticalLayout.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_ui_skin_GUISkin.__meta__ = { fields : { id : { prototype : null}}};
com_genome2d_ui_skin_GUISkin.g2d_instanceCount = 0;
com_genome2d_ui_skin_GUISkin.PROTOTYPE_PROPERTY_DEFAULTS = [""];
com_genome2d_ui_skin_GUISkin.PROTOTYPE_PROPERTY_NAMES = ["id"];
com_genome2d_ui_skin_GUISkin.PROTOTYPE_PROPERTY_TYPES = ["String"];
com_genome2d_ui_skin_GUISkin.PROTOTYPE_PROPERTY_EXTRAS = [0];
com_genome2d_ui_skin_GUISkin.PROTOTYPE_NAME = "GUISkin";
com_genome2d_ui_skin_GUISkin.PROTOTYPE_DEFAULT_CHILD_GROUP = "default";
com_genome2d_utils_GHAlignType.LEFT = 0;
com_genome2d_utils_GHAlignType.CENTER = 1;
com_genome2d_utils_GHAlignType.RIGHT = 2;
com_genome2d_utils_GVAlignType.TOP = 0;
com_genome2d_utils_GVAlignType.MIDDLE = 1;
com_genome2d_utils_GVAlignType.BOTTOM = 2;
haxe_ds_ObjectMap.count = 0;
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
haxe_xml_Parser.escapes = (function($this) {
	var $r;
	var h = new haxe_ds_StringMap();
	if(__map_reserved.lt != null) h.setReserved("lt","<"); else h.h["lt"] = "<";
	if(__map_reserved.gt != null) h.setReserved("gt",">"); else h.h["gt"] = ">";
	if(__map_reserved.amp != null) h.setReserved("amp","&"); else h.h["amp"] = "&";
	if(__map_reserved.quot != null) h.setReserved("quot","\""); else h.h["quot"] = "\"";
	if(__map_reserved.apos != null) h.setReserved("apos","'"); else h.h["apos"] = "'";
	$r = h;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
motion_actuators_SimpleActuator.actuators = [];
motion_actuators_SimpleActuator.actuatorsLength = 0;
motion_actuators_SimpleActuator.addedEvent = false;
motion_Actuate.defaultActuator = motion_actuators_SimpleActuator;
motion_Actuate.defaultEase = motion_easing_Expo.get_easeOut();
motion_Actuate.targetLibraries = new haxe_ds_ObjectMap();
Test.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=Example.js.map