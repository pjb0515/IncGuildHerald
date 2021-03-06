function capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
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


$( document ).on('turbolinks:load', function() {
  $(".search-top-players-form").bind('submit', function(event) {
    var currentForm = $(this).closest("form");
    
    var realm = "";
    var duration = "";
    
    realm = $('input[name=select-realm]:checked').val();
    duration = $('input[name=select-duration]:checked').val();
    
    daocClass = "all-classes";
    
    if(realm == "hibernia")
    {
      var classType = $('input[name=select-hib-class-type]:checked').val();
      
      if (classType !== "all-classes")
      {
        daocClass = $('input[name=select-hib-class-'+classType+']:checked').val();
      }        
    }
    else if (realm == "midgard")
    {
      var classType = $('input[name=select-mid-class-type]:checked').val();
      
      if (classType !== "all-classes")
      {
        daocClass = $('input[name=select-mid-class-'+classType+']:checked').val();
      }  
    }
    else if (realm == "albion")
    {
      var classType = $('input[name=select-alb-class-type]:checked').val();
      
      if (classType !== "all-classes")
      {
        daocClass = $('input[name=select-alb-class-'+classType+']:checked').val();
      }  
    }
    
    getTopPlayers(realm, duration, daocClass, function(responseJSON) {
      $("#top-players-table tbody tr").remove();
      
      $.each(responseJSON.players, function(index) {
        $("#top-players-table tbody").append(
          "<tr>"+
            "<td>"+(index+1)+"</td>"+
            "<td><a href='/herald/player/find/"+this.name+"'>"+this.name+"</a></td>"+
            "<td>"+this.rps+"</td>"+
            "<td>"+this.realm_level+"</td>"+
            "<td class='"+this.realm+"'>"+capitalize(this.realm)+"</td>"+
            "<td>"+capitalize(this.daoc_class)+"</td>"+
            "<td>"+getGuildLinkHtml(this.guild)+"</td>"+
          "</tr>"
        );
      });
    });
    event.preventDefault();
  });
  
  $(".search-top-guilds-form").bind('submit', function(event) {
    var currentForm = $(this).closest("form");
    
    var realm = "";
    var duration = "";
    
    realm = $('input[name=select-realm]:checked').val();
    duration = $('input[name=select-duration]:checked').val();
    
    getTopGuilds(realm, duration, function(responseJSON) {
      $("#top-guilds-table tbody tr").remove();
      
      $.each(responseJSON.guilds, function(index) {
        $("#top-guilds-table tbody").append(
          "<tr>"+
            "<td>"+(index+1)+"</td>"+
            "<td>"+getGuildLinkHtml(this.name)+"</td>"+
            "<td>"+this.rps+"</td>"+
            "<td class='"+this.realm+"'>"+capitalize(this.realm)+"</td>"+
            "<td>"+this.character_count+"</td>"+
          "</tr>"
        );
      });
    });
    event.preventDefault();
  });
  
  $('input[type=radio][name=select-realm]').bind('change', function() {
    $(".top-players-class-type-filter").hide();
    $(".top-players-class-filter").hide();
    if (this.value == 'hibernia') {
        $(".top-players-hib-class-type-filter").show();
    }
    else if (this.value == 'midgard') {
        $(".top-players-mid-class-type-filter").show();
    }
    else if (this.value == 'albion') {
        $(".top-players-alb-class-type-filter").show();
    }
  });
  
  $('input[type=radio][name=select-hib-class-type]').bind('change', function() {
    $(".top-players-class-filter").hide();
    
    if(this.value !== "all-classes") {
      $(".top-players-hib-class-"+this.value+"-filter").show();
    }
  });
  
  $('input[type=radio][name=select-mid-class-type]').bind('change', function() {
    $(".top-players-class-filter").hide();
    
    if(this.value !== "all-classes") {
      $(".top-players-mid-class-"+this.value+"-filter").show();
    }
  });
  
  $('input[type=radio][name=select-alb-class-type]').bind('change', function() {
    $(".top-players-class-filter").hide();
    
    if(this.value !== "all-classes") {
      $(".top-players-alb-class-"+this.value+"-filter").show();
    }
  });
  
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-92763506-1', 'auto');
    ga('send', 'pageview');
    
  $('#inc-highlights').on('ended', function () {
    this.load();
    this.play();
  });

});

function getGuildLinkHtml(guildName) {
  if(isBlank(guildName))
  {
    return "";
  }
  else
  {
    return "<a href='/herald/guild/find/"+encodeURIComponent(guildName)+"'>"+guildName+"</a>";
  }
}

function getTopPlayers(realm, duration, daocClass, callback)
{
  var params = "realm="+realm+
                  "&duration="+duration+
                  "&daoc_class="+daocClass;
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

function getTopGuilds(realm, duration, callback)
{
  var params = "realm="+realm+
                  "&duration="+duration;
  var xmlhttp = createCORSRequest('GET', "/herald/guild/top_rps?"+params);
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


$(document).on('turbolinks:load', function() {
  
  if ( $( "#guild-members-table" ).length ){
    $('#guild-members-table').DataTable( {
      "paging":   false,
      "searching": false,
      "info": false
    });
  }

  if ( $( "#rp-distribution-chart" ).length && $( "#rp-distribution-chart" ).children().length == 0) {
    // Donut Chart
    Morris.Donut({
        element: 'rp-distribution-chart',
        colors: ["green", "blue", "red"],
        data: [{
            label: "Hibernia",
            value: $(".realm_total_rps").data("hibernia-total-rps")
        }, {
            label: "Midgard",
            value: $(".realm_total_rps").data("midgard-total-rps")
        }, {
            label: "Albion",
            value: $(".realm_total_rps").data("albion-total-rps")
        }],
        resize: true
    });
  }

  if ( $( "#l7d-distribution-chart" ).length && $( "#l7d-distribution-chart" ).children().length == 0) {
    // Donut Chart
    Morris.Donut({
        element: 'l7d-distribution-chart',
        colors: ["green", "blue", "red"],
        data: [{
            label: "Hibernia",
            value: $(".realm_l7d_rps").data("hibernia-total-rps")
        }, {
            label: "Midgard",
            value: $(".realm_l7d_rps").data("midgard-total-rps")
        }, {
            label: "Albion",
            value: $(".realm_l7d_rps").data("albion-total-rps")
        }],
        resize: true
    });
  }
  
  if ( $( "#level-50-distribution-chart" ).length && $( "#level-50-distribution-chart" ).children().length == 0) {
    // Donut Chart
    Morris.Donut({
        element: 'level-50-distribution-chart',
        colors: ["green", "blue", "red"],
        data: [{
            label: "Hibernia",
            value: $(".realm-level-50s").data("hibernia-total-50s")
        }, {
            label: "Midgard",
            value: $(".realm-level-50s").data("midgard-total-50s")
        }, {
            label: "Albion",
            value: $(".realm-level-50s").data("albion-total-50s")
        }],
        resize: true
    });
  }
  
  if ( $( "#player-distribution-chart" ).length && $( "#player-distribution-chart" ).children().length == 0) {
    // Donut Chart
    Morris.Donut({
        element: 'player-distribution-chart',
        colors: ["green", "blue", "red"],
        data: [{
            label: "Hibernia",
            value: $(".realm-player-count").data("hibernia-count")
        }, {
            label: "Midgard",
            value: $(".realm-player-count").data("midgard-count")
        }, {
            label: "Albion",
            value: $(".realm-player-count").data("albion-count")
        }],
        resize: true
    });
  }
});