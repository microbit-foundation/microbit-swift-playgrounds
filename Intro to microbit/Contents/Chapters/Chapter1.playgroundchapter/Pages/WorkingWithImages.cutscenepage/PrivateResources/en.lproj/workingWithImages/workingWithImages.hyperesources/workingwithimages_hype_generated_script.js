//	HYPE.documents["workingWithImages"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "workingWithImages.hyperesources";
	var documentName = "workingWithImages";
	var documentLoaderFilename = "workingwithimages_hype_generated_script.js";
	var mainContainerID = "workingwithimages_hype_container";

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
	
	var resources = {"3":{n:"image_debug.png",p:1},"1":{n:"logo.svg",p:1},"2":{n:"image_popover.png",p:1},"0":{n:"background.png",p:1}};
	
	var scenes = [{x:0,p:"600px",c:"#FFFFFF",v:{"10":{aU:8,G:"#000000",c:642,aV:8,r:"inline",d:176,s:"'Helvetica Neue',Arial,Helvetica,Sans-Serif",t:16,Z:"break-word",aP:"auto",w:"<div><span style=\"color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Arial, Helvetica, sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; letter-spacing: normal; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; background-color: rgb(255, 255, 255); text-decoration: none;\">Swift Playgrounds lets you preview some types of constants and variables. Notice that sometimes a small icon appears to the right of a line of code. Tapping that icon gives you a preview of that variable.</span><br></div><div><br></div><div>Sometimes it is useful to get a preview of the images you\u2019re making before you run your code. Perhaps you have an image that displays at the end of a program and you want to test what it will look like. The Swift type <b>MicrobitImage</b>&nbsp;can be previewed in this way.</div><div><br></div><div>To do that, click on the small image icon next to the definition of the image in your code.</div>",j:"absolute",x:"visible",aA:[],k:"div",y:"preserve",z:"8",aS:8,aT:8,a:74,b:158},"2":{aU:8,bB:0,c:598,G:"#FFFFFF",aV:8,r:"inline",d:35,bC:0,s:"'Helvetica Neue',Arial,Helvetica,Sans-Serif",t:28,Z:"break-word",w:"Working with micro:bit Images",j:"absolute",x:"visible",aZ:0,k:"div",y:"preserve",z:"5",aS:8,aT:8,a:99,bA:"#000000",b:10},"11":{o:"content-box",h:"1",x:"visible",a:760,q:"100% 100%",b:19,j:"absolute",r:"inline",c:195.47399999999999,k:"div",z:"4",d:34.210500000000003},"16":{c:185,d:20,I:"None",J:"None",K:"None",L:"None",aP:"pointer",M:0,N:0,A:"#A0A0A0",x:"visible",j:"absolute",B:"#A0A0A0",k:"div",aA:[{goToURL:"http://bit.ly/microbit-swift",type:5,openInNewWindow:true}],O:0,z:"12",P:0,D:"#A0A0A0",C:"#A0A0A0",a:166,b:563},"12":{b:679,z:"9",K:"None",c:171,L:"None",d:22,aS:12,M:0,e:"1.000000",bD:"none",N:0,aT:12,O:0,g:"#FFFFFF",aU:12,P:0,aV:12,j:"absolute",aI:21,k:"div",aJ:21,aK:21,aL:21,A:"#A0A0A0",B:"#A0A0A0",Z:"break-word",r:"inline",C:"#A0A0A0",D:"#A0A0A0",t:18,aA:[{goToURL:"@next",type:5,openInNewWindow:false}],F:"center",G:"#F94E31",aP:"pointer",w:"Carry on Coding!",x:"visible",I:"None",a:797,y:"preserve",J:"None"},"5":{o:"content-box",w:"",h:"0",p:"repeat-y",x:"visible",a:0,b:72,j:"absolute",r:"inline",c:1024,k:"div",z:"2",d:696},"17":{o:"content-box",h:"2",x:"visible",a:494,q:"100% 100%",b:446,j:"absolute",r:"inline",c:238,k:"div",z:"14",d:237},"6":{c:1024,d:768,I:"None",J:"None",K:"None",g:"#DDEEFF",L:"None",M:0,N:0,A:"#A0A0A0",x:"visible",j:"absolute",B:"#A0A0A0",k:"div",O:0,l:"90deg",z:"1",P:0,D:"#A0A0A0",m:"#23D629",C:"#A0A0A0",n:"#56E1FD",a:0,b:0},"7":{c:1024,d:72,I:"None",J:"None",K:"None",g:"#000000",L:"None",M:0,N:0,A:"#A0A0A0",x:"visible",j:"absolute",B:"#A0A0A0",P:0,k:"div",C:"#A0A0A0",z:"3",O:0,D:"#A0A0A0",a:0,b:0},"18":{o:"content-box",h:"3",x:"visible",a:80,q:"100% 100%",b:350,j:"absolute",r:"inline",c:459,k:"div",z:"13",d:223},"8":{b:120,z:"7",K:"None",c:730,L:"None",aS:0,d:605,M:0,e:"1.000000",N:0,aT:0,O:0,g:"#FFFFFF",aU:0,P:0,Q:20,aV:0,R:"#333333",j:"absolute",S:3,aI:24,k:"div",T:3,aJ:24,aK:24,aL:24,A:"#A0A0A0",B:"#A0A0A0",C:"#A0A0A0",D:"#A0A0A0",w:"",x:"visible",I:"None",a:40,J:"None"},"19":{aV:8,w:"<div>This will pop out a small preview of your image displayed on the micro:bit screen</div><div><br></div><div>This should help you have all sorts of fun making pictures on your micro:bit screen.</div><div><br></div>",a:74,x:"visible",Z:"break-word",y:"preserve",j:"absolute",r:"inline",c:392,k:"div",z:"15",aT:8,d:75,t:16,b:592,aS:8,aU:8,G:"#000000"}},n:"Scene1",onSceneLoadActions:[{type:0}],T:{kTimelineDefaultIdentifier:{d:0,i:"kTimelineDefaultIdentifier",n:"Main Timeline",a:[],f:30}},o:"1"}];
	
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

