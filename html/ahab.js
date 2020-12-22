
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
// Holds the secret symbols
var symbols = ['?', '$', '%']

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
  var sear = document.getElementById("searchcontainer");

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

  // Sets up the secret button
  let button0 = document.getElementById("button0");
  if(button0 == null){
    button0 = document.createElement("button");
		sear.appendChild(button0);
  }
  button0.setAttribute("id", "button0");
  button0.setAttribute("style", "display:none;");
  button0.setAttribute("class", "sort");
  button0.innerHTML = "Secret"

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
function buttonRespond(event, name, ticker, sector, industry, description, website, mx){
  modal.style.display = "block";
  modalText.innerHTML = '<h1>'+name.replaceAll("-apos", "&apos;")+' ['+ticker+']</h1>'+
                        '<h4>'+industry+' - '+sector+'</h4>'+
                        '<p>'+description.replaceAll("-apos", "&apos;")+'</p>'+
                        '<p><div id="modal-links"><div id="left"><a href="'+website+'" target="_blank">'+website+'</a></div>'+
                        '<div id="right"><img class="mag" onclick="peerRespond(event, \''+ticker+'\')" src="./html/magnify.png" alt="P" height="20px" width="20px">'+
                        '<a href="https://www.google.com/search?q=stock:'+ticker+'" target="_blank">'+
                        '<img src="./html/google.png" alt="G" height="20px" width="20px"></a> '+
                        '<a href="https://seekingalpha.com/symbol/'+ticker+'" target="_blank">'+
                        '<img src="./html/seeking_alpha.png" alt="S" height="20px" width="20px"></a> '+
                        '<a href="https://www.morningstar.com/stocks/'+mx+'/'+ticker+'/quote" target="_blank">'+
                        '<img src="./html/morning_star.png" alt="M" height="20px" width="20px"></a> '+
                        '<a href="https://finance.yahoo.com/quote/'+ticker.replace(".", "")+'" target="_blank">'+
                        '<img src="./html/yahoo.png" alt="Y" height="20px" width="20px"></a></div><br style="clear:both;"/></div>';
}

// Custom search function to just search on particular rows
function searchRespond(event){

  if(curList === undefined){
    curList = numList(counter);
  }

  if(searchbar.value.charAt(0) == "_"){
    if(symbols.includes(searchbar.value.charAt(1))){
      activateSecret(searchbar.value.charAt(1), searchbar.value)
    }else if(searchbar.value.length > 1){
      activateSecret("", searchbar.value)
    }
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

      // For completely random (Yates method)
      else if(type.charAt(0) === 'r'){
        for(let i = sortable.length-1; i > 0; i--){
          let j = Math.floor(Math.random() * i);
          let k = sortable[i];
          sortable[i] = sortable[j];
          sortable[j] = k;
        }
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

// ------------------------
// SECRET FUNCTIONALITY
// ------------------------

function activateSecret(symbol, searchbar){

  // Sets up the secret button
  let button0 = document.getElementById("button0");
  if(button0 == null){
    button0 = document.createElement("button");
		sear.appendChild(button0);
  }
  button0.setAttribute("id", "button0");
  button0.setAttribute("class", "sort");
  if(symbol == "")
    button0.setAttribute("style", "display:none;");
  else
    button0.setAttribute("style", "display:inline-block;");

  if(symbol == symbols[0]){
    button0.setAttribute("onclick", "randomSort(event)");
    button0.innerHTML = "Random Sort"
  }else if(symbol == symbols[1]){
    button0.setAttribute("onclick", "exactItems(event, \'"+searchbar.replace("'","")+"\')");
    button0.innerHTML = "List Tickers"
  }else if(symbol == symbols[2]){
    button0.setAttribute("onclick", "investCalc(event, \'"+searchbar.replace("'","")+"\')");
    button0.innerHTML = "Calculator";
  }
}

function randomSort(event){
  itemsort("", "r")
  generateTable(curList)
}

function exactItems(event, searchlist){
  // Grab all the keys and the delimiters
  let keys = Object.keys(allItems)

  // Get the regular Expression
  let re = new RegExp("[ :;,]+", 'i')
  let tmpmatch = searchlist.split(re)

  // Clear out list and put exact items
  curList = []
  for(let i = 0; i < tmpmatch.length; i++){
    if(keys.includes(tmpmatch[i]))
      curList.push(allItems[tmpmatch[i]]._id)
  }

  // Draw out the table
  generateTable(curList)

}

function investCalc(event, searchlist){
  modal.style.display = "block";
  modalText.innerHTML = '<h1 style="text-align: center;">Investment Calculator (Prototype)</h1>'+
                        '<div id="left">'+
                        '<p>Rate of Return<br/><input type="text" class="ic"></p>'+
                        '<p>Principal<br/><input type="text" class="ic"></p>'+
                        '<p>Contribution<br/><input type="text" class="ic"></p>'+
                        '<p>Compounding Frequency<br/><input type="text" class="ic"></p>'+
                        '<p>Investment Time<br/><input type="text" class="ic"></p>'+
                        '<button id="ib" >Calculate</button></div>'+
                        '<div id="right"></div><br style="clear:both;"/>';

  // Grab the button
  let button = document.getElementById("ib");
  button.setAttribute("class", "sort")
  button.setAttribute("onclick", "calculateModal(event)")

  // Get the regular Expression
  let re = new RegExp("[ :;,]+", 'i')
  let tmpMatch = searchlist.split(re)

  // If there are values in the searchbar
  if(tmpMatch.length > 1){

    // Grab all the class items
    let items = document.getElementsByClassName('ic');

    // Stores the values into the list
    for(let i = 1; i < tmpMatch.length; i++)
      items[i-1].value = tmpMatch[i];
  }

}

function calculateModal(event){

  // Get all the items in the list
  let items = document.getElementsByClassName('ic');
  let list = calculateAnnualizedInvestment(items[0].value, items[1].value,
                          items[2].value, items[3].value, items[4].value);

  // Collect all the data
  let data = '<h2>Value (per Year)</h2>';
  for(let i = 0; i < list.length; i++){
    data += '<p>'+list[i]+'</p>'
  }

  // Output the data on the modal
  let right = document.getElementById('right');
  right.innerHTML = data
}

function peerRespond(event, key){

  // Get all the peers and make sure the key is the first one
  let peers = allItems[key].peers;
  peers.unshift(key);

  // Grab all the peers and list them in the ticker list
  let tmptext = "_$ ";
  for(let i = 0; i < peers.length; i++)
    tmptext += peers[i] + " ";
  searchbar.value = tmptext;

  // Activate the bar
  activateSecret('$', searchbar.value)

  // Automatically doing it is a jarring experience sometimes
  //exactItems(undefined, searchbar.value)

  // Send them back so they can list tickers if they want to
  modal.style.display = "none";
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

// --------------------------------
// EQUITY REFINERY
// Investment Calculator Functions
// --------------------------------

function calculateInvestment(rate, principal, contributions, periods, time) {
  var base = 1 + rate / periods;
  var nt = periods * time;

  return (principal * base ** nt) + contributions * (base ** (nt + 1) - base) / rate;
}

function calculateAnnualizedInvestment(rate, principal, contributions, periods, time) {
  var years = [];

  for(i = 0; i < time; ++i) {
    years.push(calculateInvestment(rate, principal, contributions, periods, i + 1));
  }

  return years;
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

  let re = new RegExp("['\"]", 'g')

  // Goes through all the list items and forms them to my will
  Object.keys(objt).forEach(function(key) {

    // Make some extra objects
    objt[key]['_id'] = counter;
    objt[key]['_ticker'] = key;
    // Not needed since sorting algorithms improved
    //objt[key]['_score'] = 10000000-(parseInt(objt[key].score*100)+1000000);

    // Grab all the items
    var value = objt[key];

    // Grabs all the jsonkeys for sorting purposes
    if(jsonkeys === undefined)
      jsonkeys = Object.keys(objt[key])
      // Generic thing for the ticker (which is also a key)
      jsonkeys.unshift("")

    // Add the row to it
    column = document.createElement('tr');
    table.appendChild(column);
    column.setAttribute("class", "block");
    column.setAttribute("id", ""+counter)

    // The name
    let nameurl = '<span class="mag" onclick="buttonRespond(event, \''+
                        value.name.replaceAll(re, '-apos')+'\', \''+key.toUpperCase()+'\', \''+
                        value.sector+'\', \''+value.industry+'\', \''+
                        value.description.replaceAll(re, '-apos')+'\', \''+value.website+'\', \''+
                        value.mx+'\' )">'+value.name+' <img src="./html/info.png" alt="'+
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
