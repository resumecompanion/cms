// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  if($("#sidebar-content-editor").length > 0){
    var target = $("#sidebar-content-editor");
    var broswe = $("#sidebar-content-editor").attr("data-broswe");
    var upload = $("#sidebar-content-editor").attr("data-upload");
    CKEDITOR.replace('sidebar-content-editor', {
      filebrowserBrowseUrl : broswe,
      filebrowserUploadUrl : upload,
      filebrowserWindowWidth : '640',
      filebrowserWindowHeight : '480'
    });
  }
});