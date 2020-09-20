
var options;
var values;
var coolist;

window.onload = function(){

  options = {
    valueNames: [ 'name', 'ticker', 'score' ],
    item: '<li><h3 class="name"></h3><p class="ticker"></p><p class="score"></p></li>'
  };

  values = [];

  coollist = new List('hacker-list', options, values);

  quickRequest("GET", "./out.json", "", true);

  //var options = {
  //  valueNames: [ 'name', 'city' ],
  //  item: '<li><h3 class="name"></h3><p class="city"></p></li>'
  //};

  //var values = [
  //  { name: 'Jonny', city:'Stockholm' }
  //  , { name: 'Jonas', city:'Berlin' }
  //];

  //hackerList.add( { name: 'Cooler', city:'Beans' } );

  //Sets up a text box (that will be hidden eventually)
	//var outerdiv = document.getElementById("outText");
	//if(outerdiv == null){
	//	outerdiv = document.createElement("div");
	//	document.body.appendChild(outerdiv);
	//}
	//outerdiv.setAttribute("id", "outText");
}

// ---------------------
// Generic Server Code
// ---------------------

// This is for handling the server requests
function respondObj(objt){

  Object.keys(objt).forEach(function(key) {
    var value = objt[key];
    coollist.add( { name: '<a href="https://www.google.com/search?q=stock:'+key+'" target="_blank">'+value.name+'</a>',
                    ticker: '<a href="https://www.morningstar.com/stocks/xnas/'+key+'/quote" target="_blank">'+key+'</a>',
                    score: value.score } );
  });

	// This gets the last bit of online game data
	//if(objt.hasOwnProperty('getData')){
	//	odata = objt.getData;
	//}
}


// ----------------------
// AJAX Communication
// ----------------------

function handleResponse(){
	if(request.readyState == 4){
		if(request.status == 200){

      // --------------------
      // JSON response setup
      // --------------------

      //request.responseText (Gets the response from the server and does something...)
			var resp = request.responseText;
			//Makes a function out of the JSON object
			var func = new Function("return "+resp);
      // Change into global if dealing with ajax, and check for null
			var objt = func();

      // -----------------------
      // JSON Function Response
      // -----------------------
      respondObj(objt);

      // -----------------------
      // Update Functions Here
      // -----------------------
			//setTimeout(runGame, stored);

		}else
			alert("A problem occurred with communicating between " +
					"the XMLHttpRequest object and the server program.");
	}//end outer if...
}

// -------------------------
// Server Functionality
// -------------------------

//The code under here is the AJAX transaction code
//Make sure to include a handleResponse somewhere...

// Wrapper on Wrapper on Wrapper code
// Further simplifies the AJAX code to handle GET and POST requests
// In one quick and dirty function
function quickRequest(reqType, url, urlFrag, asynch){
  if(reqType == "POST"){
    httpRequest("POST", url, asynch, urlFrag);
  }else{
    httpRequest("GET", url+"?"+urlFrag, asynch, null);
  }
}

/* Initialize a request object that is already constructed
Parameters:
	reqType: the HTTP request type, such as GET or POST
	url: The URL of the server program
	isAsynch: Whether to send the data asynchronously or not */
function initReq(reqType, url, isAsynch, send){
	//Specify the function that will handle the HTTP response
	request.onreadystatechange = handleResponse;
	request.open(reqType, url, isAsynch);
	// Set the Content-Type header for a POST request
	request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	request.send(send);
}

/* Wrapper function for constructing a request object
Parameters:
	reqType: the HTTP request type, such as GET or POST
	url: The URL of the server program
	asynch: Whether to send the data asynchronously or not */
function httpRequest(reqType, url, asynch, send){
	//Mozilla-based browsers
	if(window.XMLHttpRequest){
		request = new XMLHttpRequest();
	}else if(window.ActiveXObject){
		request = newActiveXObject("Msxml2.XMLHTTP");
		if(!request)
			request = new ActiveXObject("Microsoft.XMLHTTP");
	}
	if(request)
		initReq(reqType, url, asynch, send);
	else
		alert("There is a problem with the AJAX features in your browser");
}
