$(document).ready(function(){
  var getCookie = function(c_name){
    var i,x,y,ARRcookies=document.cookie.split(";");
    for (i=0;i<ARRcookies.length;i++){
      x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
      y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
      x=x.replace(/^\s+|\s+$/g,"");
      if (x==c_name){
        return unescape(y);
      }
    }
  }

  var setCookie = function(c_name,value,exdays){
    var exdate=new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
    document.cookie=c_name + "=" + c_value;
  }

  var checkCookie = function(){
    var popup=getCookie("popup");
    if (!popup){
        showPopup();
        setCookie("popup","true",365);
    }
  }

  var showPopup = function(){
    $('#popup').fancybox({
      'margin': 0,
      'padding': 0,
      'content': $('#popup').html()
    });

    setTimeout(function(){
      $('#popup').trigger('click');
    }, 5000);
  }
  checkCookie();

});
