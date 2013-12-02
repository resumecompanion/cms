var Hellobar = {
  initialize: function(){
    var self = this;

    self.showHellobar();

    $(document).on("click", "#hellobar-close", function(e){
      e.preventDefault();

      $.when(
        self.hideHellobar()
      ).then(
        self.showOpenButton()
      );
    });

    $(document).on("click", "#hellobar-open", function(e){
      e.preventDefault();

      $.when(
        self.hideOpenButton()
      ).then(
        self.showHellobar()
      )
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
  }
}
