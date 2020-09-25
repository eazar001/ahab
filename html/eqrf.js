
// The List options
var options;
// The list values
var values;
// The list itself
var coolist;
// My own custom search bar (that works the same I promise)
var searchbar;

// When the window opens, do this!
window.onload = function(){

  // Stores all the options for the list
  options = {
    valueNames: [ 'name', 'nameurl', 'ticker', 'tickerurl', 'score', 'scorefix' ],
    item: '<tr class="block">'+
          '<td class="name" style="display:none;"></td>'+
          '<td class="nameurl"></td>'+
          '<td class="ticker" style="display:none;"></td>'+
          '<td class="tickerurl"></td>'+
          '<td class="score"></td>'+
          '<td class="scorefix" style="display:none;"></td>'+
          '</tr>'
  };

  // Stores all the values for the list (pretty empty looking)
  values = [];

  // Actually creates the list
  coollist = new List('hacker-list', options, values);

  // This is to invoke the JSON (custom made crap)
  quickRequest("GET", "./out.json", "", true);

  // Creates a new search if one isn't made already
	searchbar = document.getElementById("mysearch");
	if(searchbar == null){
		searchbar = document.createElement("input");
		document.body.appendChild(searchbar);
	}

	//Sets up the canvas if it isn't set up already
	searchbar.setAttribute("id", "mysearch");
  searchbar.setAttribute("onkeyup", "searchRespond(event)");
}

// Custom search function to just search on particular rows
function searchRespond(event){
  coollist.search(searchbar.value, ['name', 'ticker', 'score']);
}

// ---------------------
// Generic Server Code
// ---------------------

// This is for handling the server requests
function respondObj(objt){

  // Goes through all the list items and forms them to my will
  Object.keys(objt).forEach(function(key) {
    var value = objt[key];
    coollist.add( { name: value.name,
                    nameurl: '<a href="https://www.google.com/search?q=stock:'+key+'" target="_blank">'+value.name+'</a>',
                    ticker: key,
                    tickerurl: '<a href="https://www.morningstar.com/search?query='+key+'" target="_blank">'+key+'</a>',
                    score: value.score,
                    scorefix: parseInt(value.score*100)+1000000} );
  });
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
