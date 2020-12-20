
// MODAL VARIABLES
// ----------------

// Testing the modal (need to cleanup)
var modal;
// Testing for editable text (need to cleanup)
var modalText;


// MAIN FUNCTION
// ---------------

// When the window opens, do this!
window.onload = function(){

  quickRequest("GET", "./allstonks.json", "", true);



  // MODAL FUNCTIONALITY
  // --------------------

  // Initialize the modal stuff
  modal = document.getElementById("myModal");
  modalText = document.getElementById("myModalText");

  // Allows the modal to close when you click outside of it
  var span = document.getElementsByClassName("close")[0];
  span.setAttribute("onclick", "spanRespond(event)");
}

// When the user clicks on the button, open the modal
// Used to format the modal text (allowing for some flexibility)
function buttonRespond(event, name, ticker, sector, industry, description, website){
  modal.style.display = "block";
  modalText.innerHTML = '<h1>'+name.replaceAll("-apos", "&apos;")+' ['+ticker+']</h1>'+
                        '<h4>'+industry+' - '+sector+'</h4>'+
                        '<p>'+description.replaceAll("-apos", "&apos;")+'</p>'+
                        '<a href="'+website+'" target="_blank">'+website+'</a>';
}

// -------------------------
// GENERIC MODAL FUNCTIONS
// -------------------------

// When the user clicks on <span> (x), close the modal
function spanRespond(event){
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

// ---------------------
// Generic Server Code
// ---------------------

// This is for handling the server requests
function respondObj(objt){

  // We are going to have to generate a new table every time with different elements
  // Get the table element
  var table = document.getElementsByClassName("list")[0];

  var column;
  var row;

  // Goes through all the list items and forms them to my will
  Object.keys(objt).forEach(function(key) {
    var value = objt[key];

    // Add the row to it
    column = document.createElement('tr');
    table.appendChild(column);
    column.setAttribute("class", "block");

    // The name
    let nameurl = '<span class="mag" onclick="buttonRespond(event, \''+
                        value.name.replaceAll("'", '-apos')+'\', \''+key.toUpperCase()+'\', \''+
                        value.sector+'\', \''+value.industry+'\', \''+
                        value.description.replaceAll("'", '-apos')+'\', \''+value.website+'\' )">'+
                        value.name+' <img src="./internal/info.png" alt="'+
                        key+'" height="14px" width="14px" ></span>';
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','name');
    row.innerHTML = nameurl;

    // The ticker
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','ticker');
    row.innerHTML = key;

    // The links
    let link = '<a href="https://www.google.com/search?q=stock:'+key+'" target="_blank">'+
            '<img src="./internal/google.png" alt="G"></a> '+
            '<a href="https://seekingalpha.com/symbol/'+key+'" target="_blank">'+
            '<img src="./internal/seeking_alpha.png" alt="S"></a> '+
            '<a href="https://www.morningstar.com/stocks/'+value.mx+'/'+key+'/quote" target="_blank">'+
            '<img src="./internal/morning_star.png" alt="M"></a> '+
            '<a href="https://finance.yahoo.com/quote/'+key.replace(".", "")+'" target="_blank">'+
            '<img src="./internal/yahoo.png" alt="Y"></a> ';
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','link');
    row.innerHTML = link;

    // The score
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','score');
    row.innerHTML = value.score;
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

		}else{
      console.log("A problem occurred with communicating between " +
					       "the XMLHttpRequest object and the server program.");
    }
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
