String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

function isBlank(str) {
    return (!str || /^\s*$/.test(str));
}

function createCORSRequest(method, url)
{
	return createCORSRequestWithDataType(method, url, "x-www-form-urlencoded");
}

function createCORSRequestWithDataType(method, url, dataType)
{
  var xhr = new XMLHttpRequest();
	if ("withCredentials" in xhr)
	{
		// Check if the XMLHttpRequest object has a "withCredentials" property.
		// "withCredentials" only exists on XMLHTTPRequest2 objects.
		xhr.open(method, url, true);
	}
	else if (typeof XDomainRequest != "undefined")
	{
		// Otherwise, check if XDomainRequest.
		// XDomainRequest only exists in IE, and is IE's way of making CORS requests.
		xhr = new XDomainRequest();
		xhr.open(method, url);
	}
	else
	{
		// Otherwise, CORS is not supported by the browser.
		xhr = null;
	}

	xhr.setRequestHeader("Content-type","application/"+dataType);
   
   var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
	xhr.setRequestHeader("X-CSRF-Token", AUTH_TOKEN);

	return xhr;
}


$(function() {
  $(".search-top-players-form").bind('submit', function(event) {
    var currentForm = $(this).closest("form");
    
    var realm = "";
    var duration = "";
    
    realm = $('input[name=select-realm]:checked').val();
    duration = $('input[name=select-duration]:checked').val();
    
    getTopPlayers(realm, duration, function(responseJSON) {
        
    });
    event.preventDefault();
  });
});

function getTopPlayers(realm, duration, callback)
{
  var params = "realm="+realm+
                  "&duration="+duration;
  var xmlhttp = createCORSRequest('GET', "/herald/player/top_rps?"+params);
	if(!xmlhttp)
	{
		document.body.innerHTML = "Sorry, your browser isn't supported.  <a href=\"http://caniuse.com/#feat=cors\">Click here for a list of supported browsers</a>";
		return false;
	}

	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
      callback(JSON.parse(xmlhttp.responseText));
    }
	}
	xmlhttp.send();
	
	return false;
}