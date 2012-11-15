// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){

  if($("#page-list").length > 0){
    $(document).on("click", ".open-folder", function(){
      var self = this
      var url = $(self).attr("data-url");

      if($(self).hasClass("closed")){
        Overlay.enable();
        $(self).removeClass("closed");
        $(self).addClass("open");

        $.get(url, function(data){
          $(self).parent().append(data);
          Overlay.disable();
        });
      }else {
        $(self).removeClass("open");
        $(self).addClass("closed");

        $(self).parent().find(".children").first().remove();
      }

      return false;
    });

    $(document).on("click", ".delete-page-button", function(){
      Overlay.enable();
    });
  }

  if($("#content-editor").length > 0){
    var target = $("#content-editor");
    var broswe = $("#content-editor").attr("data-broswe");
    var upload = $("#content-editor").attr("data-upload");
    CKEDITOR.replace('content-editor', {
      filebrowserBrowseUrl : broswe,
      filebrowserUploadUrl : upload,
      filebrowserWindowWidth : '640',
      filebrowserWindowHeight : '480'
    });
  }

  if($(".parent-id-selector").length > 0){
    $(document).on("change", ".parent-id-selector", function(){
      var self = this;
      var id = $(self).val();
      var url = $(self).attr("data-url") + "?id=" + id;
      var $selectors = $(".parent-id-selector")
      var position = $selectors.index(self);


      if(id == ""){
        if(position != 0 ){
          selected_value = $(self).parent().prev().find(".parent-id-selector").val(); // Find previous selector
        }else{
          selected_value = "";
        }
      }else{
        selected_value = id;
      }

      $("#parent-id").val(selected_value);

      $selectors.each(function(index, selector){
        if(index > position){
          $(selector).parent().remove();
        }
      });

      $.get(url, function(data){
        $(self).parent().after(data);
      });

    });
  }
});