
// We need to build a sorting algorithm for the objt class

// GLOBAL VARIABLES
// ----------------

// All the JSON values for the stocks
var allItems;
// Holds the searchbar
var searchbar;
// Holds the max amount of stocks
var counter;
// Holds all the json keys
var jsonkeys;
// Holds the last sort button pressed
var sortIndex = 0;
// Holds the current list
var curList;

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

  // TABLE FUNCTIONALITY
  // -------------------

  var span = document.getElementById("tablecontainer");
  var bttn = document.getElementById("buttoncontainer");

  // Creates one real table
  let real = document.createElement('table');
  real.setAttribute("class", "list");
  real.setAttribute("id", "real");
  real.setAttribute("style", "width:100%;");
  span.appendChild(real);

  // Creates one fake table
  let fake = document.createElement('table');
  fake.setAttribute("class", "list");
  fake.setAttribute("id", "fake");
  fake.setAttribute("style", "width:100%; display:none;");
  span.appendChild(fake);

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

  // Sets up some buttons for clicking
  let button1 = document.getElementById("button1");
  if(button1 == null){
    button1 = document.createElement("button");
		bttn.appendChild(button1);
  }
  button1.setAttribute("id", "button1");
  button1.setAttribute("class", "sort");
  button1.setAttribute("onclick", "sortRespond(event, 'name', 'l')")
  button1.innerHTML = "Sort by Name"

  let button2 = document.getElementById("button2");
  if(button2 == null){
    button2 = document.createElement("button");
		bttn.appendChild(button2);
  }
  button2.setAttribute("id", "button2");
  button2.setAttribute("class", "sort");
  button2.setAttribute("onclick", "sortRespond(event, '', 'l')")
  button2.innerHTML = "Sort by Ticker"

  let button3 = document.getElementById("button3");
  if(button3 == null){
    button3 = document.createElement("button");
		bttn.appendChild(button3);
  }
  button3.setAttribute("id", "button3");
  button3.setAttribute("class", "sort");
  button3.setAttribute("onclick", "sortRespond(event, 'score', 'n')")
  button3.innerHTML = "Sort by Score"

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

// Custom search function to just search on particular rows
function searchRespond(event){

  if(curList === undefined){
    curList = numList(counter);
  }

  if(searchbar.value.charAt(0) == "_"){
    if(searchbar.value.length == 1){
      console.log("Let the games begin!")
    }
    //generateTable(numList(counter))
  }else{
    generateTable(itemfilter(searchbar.value, curList, ["name", "^", "^score"], 'i'))
  }
}

// Custom sorting function to sort items depending on the clicks
function sortRespond(event, name, type){

  // If you don't find the name, don't sort anything
  if(jsonkeys.includes(name)){

    let ind = jsonkeys.indexOf(name)+1

    if(ind === Math.abs(sortIndex)){
      sortIndex *= -1;
    }else{
      sortIndex = ind
    }

    if(type.length >= 1){

      // Sort using letter sorting
      if(type.charAt(0) === 'l'){
        if(sortIndex > 0){
          itemsort(name, 'a')
        }else{
          itemsort(name, 'd')
        }
      }
      // Sort using numeric sorting
      else{
        if(sortIndex > 0){
          itemsort(name, '+')
        }else{
          itemsort(name, '-')
        }
      }
    }

    searchRespond(event)
  }
}

// The function for filtering the items
function itemfilter(text, list, searchname, attr){

  // If there is actual text in the filter
  if(text !== ""){

    // Get an empty list started
    let tmplist = [];

    // Get all keys
    let keys = Object.keys(allItems)

    // Get the regular Expression
    let re = new RegExp(text+".*", attr)

    // Get the beginning Expression
    let be = new RegExp("^"+text+".*", attr)

    // If searchname is empty, use keys to filter
    if(searchname.length < 1){

      // Go through all the elements and get the ones that match
      for(let i = 0; i < list.length; i++){

        // If key matches, push it onto the list
        // Blank checks only the ticker
        if(be.test(keys[list[i]]))
          tmplist.push(list[i]);

      }

    }else{

      // Go through all the elements and get the ones that match
      for(let i = 0; i < list.length; i++){

        // We need to look through all the search names too
        for(let j = 0; j < searchname.length; j++){

          // This makes it search the start of a string
          if(searchname[j].charAt(0) === "^"){
            // If it is blank, check the key
            if(searchname[j].length == 1){
              if(be.test(keys[list[i]]))
                tmplist.push(list[i]);
            }
            // If inner key matches, push it onto the list
            else{
              if(be.test(allItems[keys[list[i]]][searchname[j].substr(1)]))
                tmplist.push(list[i]);
            }
          }
          // Otherwise searches the entire word
          else{
            // If it is blank, check the key
            if(searchname[j] === ""){
              if(re.test(keys[list[i]]))
                tmplist.push(list[i]);
            }
            // If inner key matches, push it onto the list
            else{
              if(re.test(allItems[keys[list[i]]][searchname[j]]))
                tmplist.push(list[i]);
            }
          }
        }
      }
    }

    // Return the list
    return tmplist

  }

  // We will handle functionality for underscore in here later
  return list
}

// The function for sorting the items
function itemsort(name, type){

  // sortable array
  let sortable = [];

  // Turn the entire thing into a sortable array first
  for (var item in allItems) {
    sortable.push([item, allItems[item][name], allItems[item]._id]);
  }

  // We change how we sort depending on the type
  let tind = 1;
  if(name === ""){
    tind = 0;
  }
  if(jsonkeys.includes(name)){
    if(type.length >= 1){
      // For numeric (ascending number order)
      if(type.charAt(0) === '+'){
        sortable.sort(function(a, b){
          return a[tind] - b[tind];
        });
      }

      // For numeric (decending number order)
      else if(type.charAt(0) === '-'){
        sortable.sort(function(a, b){
          return b[tind] - a[tind];
        });
      }

      else if(type.charAt(0) === 'a'){
        sortable.sort(function(a, b){
          let x = a[tind].toLowerCase();
          let y = b[tind].toLowerCase();
          if (x < y) {
            return -1;
          }
          if (x > y) {
            return 1;
          }
          return 0;
        });
      }

      // For numeric (decending number order)
      else if(type.charAt(0) === 'd'){
        sortable.sort(function(a, b){
          let x = a[tind].toLowerCase();
          let y = b[tind].toLowerCase();
          if (x < y) {
            return 1;
          }
          if (x > y) {
            return -1;
          }
          return 0;
        });
      }

      // Change the curList here
      curList = [];
      for(let i = 0; i < sortable.length; i++){
        curList.push(sortable[i][2])
      }

    }else{
      console.log("ERROR: To use this function you need a type [+,-,a,d]")
    }

  }else{
    console.log("ERROR: Invalid name construct")
  }
}



// Generates a table depending on the search variables
function generateTable(list){

  let real = document.getElementById("real");
  let fake = document.getElementById("fake");

  // Grab all nodes and put them into the fake table
  for(let i = 0; i < counter; i++){
    fake.appendChild(document.getElementById(""+i))
  }

  // Take all nodes and put them into a list
  for(let i = 0; i < list.length; i++){
    real.appendChild(document.getElementById(""+list[i]))
  }
}

// Generates list depending on stuff
// Generates a list of all the numbers
function numList(max){
  let list = Array(max);
  for(let i = 0; i < max; i++)
    list[i] = i;
  return list
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

  // Get the table element
  let table = document.getElementsByClassName("list")[0];

  let column;
  let row;
  counter = 0;

  // Goes through all the list items and forms them to my will
  Object.keys(objt).forEach(function(key) {

    // Make some extra objects
    objt[key]['_id'] = counter;
    // Not needed since sorting algorithms improved
    //objt[key]['_score'] = 10000000-(parseInt(objt[key].score*100)+1000000);

    // Grab all the items
    var value = objt[key];

    // Grabs all the jsonkeys for sorting purposes
    if(jsonkeys === undefined)
      jsonkeys = Object.keys(objt[key])
      jsonkeys.unshift("")

    // Add the row to it
    column = document.createElement('tr');
    table.appendChild(column);
    column.setAttribute("class", "block");
    column.setAttribute("id", ""+counter)

    // The name
    let nameurl = '<span class="mag" onclick="buttonRespond(event, \''+
                        value.name.replaceAll("'", '-apos')+'\', \''+key.toUpperCase()+'\', \''+
                        value.sector+'\', \''+value.industry+'\', \''+
                        value.description.replaceAll("'", '-apos')+'\', \''+value.website+'\' )">'+
                        value.name+' <img src="./html/info.png" alt="'+
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
            '<img src="./html/google.png" alt="G"></a> '+
            '<a href="https://seekingalpha.com/symbol/'+key+'" target="_blank">'+
            '<img src="./html/seeking_alpha.png" alt="S"></a> '+
            '<a href="https://www.morningstar.com/stocks/'+value.mx+'/'+key+'/quote" target="_blank">'+
            '<img src="./html/morning_star.png" alt="M"></a> '+
            '<a href="https://finance.yahoo.com/quote/'+key.replace(".", "")+'" target="_blank">'+
            '<img src="./html/yahoo.png" alt="Y"></a> ';
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','link');
    row.innerHTML = link;

    // The score
    row = document.createElement('td');
    column.appendChild(row);
    row.setAttribute('class','score');
    row.innerHTML = value.score;

    // Add one to the counter
    counter = counter + 1;
  });

  // Store all the edited objects inside one easy to access variable
  allItems = objt;

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
