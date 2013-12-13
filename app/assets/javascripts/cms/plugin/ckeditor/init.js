//= require_self
//= require blog/plugin/ckeditor/ckeditor

(function() {
  if (typeof window['CKEDITOR_BASEPATH'] === "undefined" || window['CKEDITOR_BASEPATH'] === null) {
    window['CKEDITOR_BASEPATH'] = "/assets/blog/plugin/ckeditor/";
  }
}).call(this);
