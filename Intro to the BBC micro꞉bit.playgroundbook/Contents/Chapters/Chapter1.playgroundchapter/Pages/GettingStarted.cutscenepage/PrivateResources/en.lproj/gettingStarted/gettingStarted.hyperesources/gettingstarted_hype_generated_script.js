//	HYPE.documents["gettingStarted"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "gettingStarted.hyperesources";
	var documentName = "gettingStarted";
	var documentLoaderFilename = "gettingstarted_hype_generated_script.js";
	var mainContainerID = "gettingstarted_hype_container";

	// find the URL for this script's absolute path and set as the resourceFolderName
	try {
		var scripts = document.getElementsByTagName('script');
		for(var i = 0; i < scripts.length; i++) {
			var scriptSrc = scripts[i].src;
			if(scriptSrc != null && scriptSrc.indexOf(documentLoaderFilename) != -1) {
				resourcesFolderName = scriptSrc.substr(0, scriptSrc.lastIndexOf("/"));
				break;
			}
		}
	} catch(err) {	}

	// Legacy support
	if (typeof window.HYPE_DocumentsToLoad == "undefined") {
		window.HYPE_DocumentsToLoad = new Array();
	}
 
	// load HYPE.js if it hasn't been loaded yet
	if(typeof HYPE_160 == "undefined") {
		if(typeof window.HYPE_160_DocumentsToLoad == "undefined") {
			window.HYPE_160_DocumentsToLoad = new Array();
			window.HYPE_160_DocumentsToLoad.push(HYPE_DocumentLoader);

			var headElement = document.getElementsByTagName('head')[0];
			var scriptElement = document.createElement('script');
			scriptElement.type= 'text/javascript';
			scriptElement.src = resourcesFolderName + '/' + 'HYPE.js?hype_version=160';
			headElement.appendChild(scriptElement);
		} else {
			window.HYPE_160_DocumentsToLoad.push(HYPE_DocumentLoader);
		}
		return;
	}
	
	// handle attempting to load multiple times
	if(HYPE.documents[documentName] != null) {
		var index = 1;
		var originalDocumentName = documentName;
		do {
			documentName = "" + originalDocumentName + "-" + (index++);
		} while(HYPE.documents[documentName] != null);
		
		var allDivs = document.getElementsByTagName("div");
		var foundEligibleContainer = false;
		for(var i = 0; i < allDivs.length; i++) {
			if(allDivs[i].id == mainContainerID && allDivs[i].getAttribute("HYPE_documentName") == null) {
				var index = 1;
				var originalMainContainerID = mainContainerID;
				do {
					mainContainerID = "" + originalMainContainerID + "-" + (index++);
				} while(document.getElementById(mainContainerID) != null);
				
				allDivs[i].id = mainContainerID;
				foundEligibleContainer = true;
				break;
			}
		}
		
		if(foundEligibleContainer == false) {
			return;
		}
	}
	
	var hypeDoc = new HYPE_160();
	
	var attributeTransformerMapping = {b:"i",c:"i",bC:"i",d:"i",aS:"i",M:"i",e:"f",aT:"i",N:"i",f:"d",O:"i",g:"c",aU:"i",P:"i",Q:"i",aV:"i",R:"c",bG:"f",aW:"f",aI:"i",S:"i",bH:"d",l:"d",aX:"i",T:"i",m:"c",bI:"f",aJ:"i",n:"c",aK:"i",bJ:"f",X:"i",aL:"i",A:"c",aZ:"i",Y:"bM",B:"c",bK:"f",bL:"f",C:"c",D:"c",t:"i",E:"i",G:"c",bA:"c",a:"i",bB:"i"};
	
	var resources = {"0":{n:"background.png",p:1},"1":{n:"logo.svg",p:1},"2":{n:"microbit-drawing.svg",p:1}};
	
	var scenes = [{x:0,p:"600px",c:"#FFFFFF",v:{"13":{o:"content-box",h:"2",x:"visible",aW:"0.000000",q:"100% 100%",a:649,j:"absolute",r:"inline",c:359,k:"div",z:"10",d:289,aX:0,b:109},"7":{c:1024,d:72,I:"None",J:"None",K:"None",g:"#000000",L:"None",M:0,N:0,A:"#A0A0A0",x:"visible",j:"absolute",B:"#A0A0A0",P:0,k:"div",C:"#A0A0A0",z:"3",O:0,D:"#A0A0A0",a:0,b:0},"10":{aU:8,G:"#000000",c:493,aV:8,r:"inline",d:495,s:"'Helvetica Neue',Arial,Helvetica,Sans-Serif",t:16,Z:"break-word",aP:"auto",w:"<div><b><font size=\"4\">Welcome to the micro:bit Swift Playground</font></b></div><div>Thanks for downloading this Swift Playground for the BBC micro:bit. By working through this book you\u2019ll learn the basics of interaction with the micro:bit using Swift, making some fun games and experiments along the way. <b>It has lots of information about the micro:bit, but assumes you already know a bit about Swift syntax.</b></div><div><br></div><div><b><font size=\"4\">Do I need a BBC micro:bit?</font></b></div><div><div>This book is designed to be used with a BBC micro:bit, and it\u2019s much more fun if you can play along with a real device. Don\u2019t worry if you haven\u2019t got one, though. Each page has a simulated micro:bit on the right hand side that you can use instead.</div><div>&nbsp;</div></div><div><font size=\"4\"><b>Preparing your device</b></font></div><div><div>In this book, we use Bluetooth to communicate with the micro:bit, and you need to flash the right hex file to your device over USB before you start. <b>Do not skip this step \u2013 even though you may be able to pair your micro:bit without it, the activities in the book won\u2019t work properly.</b></div><div><br></div><div>Please visit <font color=\"#0000ff\"><u>http://bit.ly/microbit-swift</u></font> to get the right hex file and instructions setting up your micro:bit.</div></div>",j:"absolute",x:"visible",aA:[],k:"div",y:"preserve",z:"8",aS:8,aT:8,a:74,b:158},"8":{b:120,z:"7",K:"None",c:578,L:"None",aS:0,d:605,M:0,e:"1.000000",N:0,aT:0,O:0,g:"#FFFFFF",aU:0,P:0,Q:20,aV:0,R:"#333333",j:"absolute",S:3,aI:24,k:"div",T:3,aJ:24,aK:24,aL:24,A:"#A0A0A0",B:"#A0A0A0",C:"#A0A0A0",D:"#A0A0A0",w:"",x:"visible",I:"None",a:40,J:"None"},"11":{o:"content-box",h:"1",x:"visible",a:782,q:"100% 100%",b:19,j:"absolute",r:"inline",c:195.47399999999999,k:"div",z:"4",d:34.210500000000003},"5":{o:"content-box",w:"",h:"0",p:"repeat-y",x:"visible",a:0,b:72,j:"absolute",r:"inline",c:1024,k:"div",z:"2",d:696},"12":{b:679,z:"9",K:"None",c:171,L:"None",d:22,aS:12,M:0,e:"1.000000",bD:"none",N:0,aT:12,O:0,g:"#FFFFFF",aU:12,P:0,aV:12,j:"absolute",aI:21,k:"div",aJ:21,aK:21,aL:21,A:"#A0A0A0",B:"#A0A0A0",Z:"break-word",r:"inline",C:"#A0A0A0",D:"#A0A0A0",t:18,aA:[{goToURL:"@next",type:5,openInNewWindow:false}],F:"center",G:"#F94E31",aP:"pointer",w:"Let's Start Coding!",x:"visible",I:"None",a:797,y:"preserve",J:"None"},"6":{c:1024,d:768,I:"None",J:"None",K:"None",g:"#DDEEFF",L:"None",M:0,N:0,A:"#A0A0A0",x:"visible",j:"absolute",B:"#A0A0A0",k:"div",O:0,l:"90deg",z:"1",P:0,D:"#A0A0A0",m:"#23D629",C:"#A0A0A0",n:"#56E1FD",a:0,b:0},"2":{aU:8,bB:0,c:659,G:"#FFFFFF",aV:8,r:"inline",d:35,bC:0,s:"'Helvetica Neue',Arial,Helvetica,Sans-Serif",t:28,Z:"break-word",w:"Welcome to Swift Playgrounds for the BBC micro:bit",j:"absolute",x:"visible",aZ:0,k:"div",y:"preserve",z:"5",aS:8,aT:8,a:93,bA:"#000000",b:10},"15":{aV:8,w:"Version 1.1.0",a:483,x:"visible",Z:"break-word",y:"preserve",j:"absolute",r:"inline",c:103,k:"div",z:"11",aT:8,d:18,F:"right",t:16,b:685,aU:8,G:"#000000",aS:8}},n:"Scene1",onSceneLoadActions:[{type:0}],T:{kTimelineDefaultIdentifier:{d:0,i:"kTimelineDefaultIdentifier",n:"Main Timeline",a:[],f:30}},o:"1"}];
	
	var javascripts = [];
	
	var functions = {};
	var javascriptMapping = {};
	for(var i = 0; i < javascripts.length; i++) {
		try {
			javascriptMapping[javascripts[i].identifier] = javascripts[i].name;
			eval("functions." + javascripts[i].name + " = " + javascripts[i].source);
		} catch (e) {
			hypeDoc.log(e);
			functions[javascripts[i].name] = (function () {});
		}
	}
	
	hypeDoc.setAttributeTransformerMapping(attributeTransformerMapping);
	hypeDoc.setResources(resources);
	hypeDoc.setScenes(scenes);
	hypeDoc.setJavascriptMapping(javascriptMapping);
	hypeDoc.functions = functions;
	hypeDoc.setCurrentSceneIndex(0);
	hypeDoc.setMainContentContainerID(mainContainerID);
	hypeDoc.setResourcesFolderName(resourcesFolderName);
	hypeDoc.setShowHypeBuiltWatermark(0);
	hypeDoc.setShowLoadingPage(false);
	hypeDoc.setDrawSceneBackgrounds(false);
	hypeDoc.setGraphicsAcceleration(true);
	hypeDoc.setDocumentName(documentName);

	HYPE.documents[documentName] = hypeDoc.API;
	document.getElementById(mainContainerID).setAttribute("HYPE_documentName", documentName);

	hypeDoc.documentLoad(this.body);
}());

