var Hellobar = {
  initialize: function(){
    var self = this;

    if(self.getCookie('hellobar_show') == 'false') {
      self.showOpenButton();
    } else {
      self.showHellobar();
    }

    $(document).on("click", "#hellobar-close", function(e){
      e.preventDefault();

      $.when(
        self.hideHellobar()
      ).then(
        self.showOpenButton()
      );

      document.cookie="hellobar_show=false;path=/";
    });

    $(document).on("click", "#hellobar-open", function(e){
      e.preventDefault();

      $.when(
        self.hideOpenButton()
      ).then(
        self.showHellobar()
      )

      document.cookie="hellobar_show=; expires=Thu, 01 Jan 1970 00:00:01 GMT";
    });

  },

  showHellobar: function(){
    $("#hellobar, #hellobar-pusher").animate({ top: '0px', height: '33px' }, {duration: 300, easing: 'easeInOutQuint'});
  },

  hideHellobar: function(){
    $("#hellobar, #hellobar-pusher").animate({ top: '-33px', height: '0px' }, {duration: 300, easing: 'easeInOutQuint'});
  },

  showOpenButton: function(){
    $("#hellobar-open").animate({ top: '0' }, {duration: 300, easing: 'easeInOutQuint'});
  },

  hideOpenButton: function() {
    $("#hellobar-open").animate({ top: '-60px' }, {duration: 300, easing: 'easeInOutQuint'} );
  },

  getCookie: function(c_name) {
    var i, x, y, ARRcookies = document.cookie.split(";");
    for (i = 0; i < ARRcookies.length; i++) {
        x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
        y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
        x = x.replace(/^\s+|\s+$/g, "");
        if (x == c_name) {
            return unescape(y);
        }
    }
  }
}
