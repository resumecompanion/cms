$(function() {
  local_link = new RegExp(".*" + document.location.hostname + ".*")

  $("a").each(function(index, link) {
    if (!local_link.test(link.href)) {
      $(link).attr('target','_blank');
    }
  })
})
