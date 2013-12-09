var LetterBuilder = {
  initialize: function(){
    $(document).ready(function(){
      $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});
      $('select.country-select').chosen({allow_single_deselect: true});
      $('select#my_job_titles').chosen({allow_single_deselect: true}).change(function(e){
        var jtid = $(this).val();$('ul.job_titles').hide();
        if(jtid != ''){
          $('p.blank').hide();
          $('#job_title_' + jtid).show();
        }else{
          $('p.blank').show();
        }
      });
      if($('select#my_job_titles').val() != ''){
        $('select#my_job_titles').trigger('change');
      }
    });

    $(document).on('click', '.save-step', function(e){
      $(this).parent().parent().parent().next().find('a.title:first').trigger('click');
      if($(this).parent().parent().parent().next().find('input:first,textarea:first').length > 0){
        try{
          $(this).parent().parent().parent().next().find('input:first,textarea:first,select:first').trigger('focus');
        }catch(e){
          //Avoid IE error message!
        }
      }
    });

    $(document).on('focus', '#custom_salutation', function(e){
      $('.raio_custom_salutation').first().click();
    });

    $(document).on('blur', '#custom_salutation', function(e){
      $('.raio_custom_salutation').val($(this).val());
    });

    $(document).on('click', '#save-and-back', function(e){
      e.preventDefault();
      $('#choice-template').trigger('submit');
      $('#letter-preview-panel').dialog('close');
      return false;
    });

    $(document).on('click', '#save-and-redirect-to-index', function(e){
      e.preventDefault();
      $('#next_step').remove();
      $('#edit_letter').trigger('submit');
      return false;
    });

    $(document).on('click', 'a.change-step', function(e){
      e.preventDefault();
      var target = $('#' + $(this).data('target'));
      target.val(parseInt($(this).data('step')));
      $(target[0].form).trigger('submit');
    });

    $(document).on('click', '#letter-preview-panel #layout-selector a.resume-template', function(e){
      $('#letter-preview-panel #layout-selector a.resume-template').removeClass('active');
      $(this).addClass('active');
      $('#resume_preview').attr('class', $(this).data('layout-class'));
      $('#letter_layout_class').val($(this).data('layout-class'));
    });

    $(document).on('ajax:success', '#choice-template', function(){
      $('#letter-preview-panel').dialog('close');
    });

    $(document).on('click', '#proceed-to-export', function(e){
      e.preventDefault();
      var form = $('#' + $(this).data('target'));
      form.removeAttr('data-remote');
      form.trigger('submit');
      return false;
    });

    $(document).on("click", "a.show-next-ul", function(e){
      e.preventDefault();
      var ul = $(this).next();
      $('li.selected').removeClass('selected');
      if(ul.hasClass('active')){
        ul.removeClass('active');
      }else{
        $('.letter-subjects').removeClass('active');
        $(this).parent().addClass('selected');
        ul.addClass('active');
        $(ul).find("a.show-preview:first").trigger('click');
      }
      return false;
    });

    $(document).on('click', 'a.show-preview', function(e){
      e.preventDefault();
      $('a.selected-to-preview').removeClass('selected-to-preview');
      $(this).addClass('selected-to-preview');
      $('#preview-letter-template').html($('#' + $(this).data('target')).html());
      $('#letter_letter_template_id').val($(this).data('target-id'));
      return false;
    });

    $(document).on('click', '#edit-items li a.title', function(e){
//      e.preventDefault();
      $('#edit-items li a.title').removeClass('selected');
      $('#edit-items li .form').hide();
      $(this).addClass('selected');
      $(this).next().show();
//      return false;
    });

    if($('#select-cover-letter-template').length > 0){
      $('#select-cover-letter-template').dialog({
        autoOpen: true,
        width: 970,
        height: "auto",
        modal: true,
        position: ["middle", 100],
        resizable: false,
        title: 'Step 1: Select your template',
        closeOnEscape: false,
        open: function(){
          $('.ui-dialog-titlebar').hide();
          $('a.show-next-ul').first().click();
          $('a.show-preview').first().click();
        },
        close: function(){document.location.href = "/letters";}
      });
      $('#next').click(function(e){
        e.preventDefault();
        $('#new_letter').trigger('submit');
        return false;
      });
    }

    if($('#edit-items a.title:first').length > 0){
      // if error field found, then display it first
      if($('.field_with_errors').length > 0){
        $('.field_with_errors:first').parent().prev().trigger('click');
      }else{
        if(location.hash.slice(1) == ''){
          $('#edit-items a.title:first').first().click();
        }else{
          $('#' + location.hash.slice(1)).first().click();
        }
      }
    }

    $('#edit_letter').submit(function(e){
      $(this).find('textarea[name$="[statement]"]').removeAttr('disabled');
      return true;
    });

    $(document).on('click', 'a.preview', function(e){
      var url = $(this).attr("data-url");
      e.preventDefault();
      $('#letter-preview-panel').remove();
      $('textarea[name$="[statement]"]').removeAttr('disabled');
      $.post(url, $('#edit_letter').serialize(),function(data, status, xhr){
          $('body').append(data);
          $('textarea[name$="[statement]"]').attr('disabled', true);
          $('#letter-preview-panel').dialog({
            autoOpen: true,
            width: 970,
            height: "auto",
            modal: true,
            position: ["middle", 100],
            open: function(){
              $('.ui-dialog').css('top','50px');
              $('.ui-dialog-titlebar').hide();
              $('#resume_preview .after_comma:empty').hide();
            },
            resizable: false,
            title: "Select Your Letter Style"
          });
        }, 'html');
    });

    if($('#letter-preview-panel').length > 0) {
      $('#letter-preview-panel').dialog({
        autoOpen: true,
        width: 970,
        height: "auto",
        modal: true,
        position: ["middle", 100],
        resizable: false,
        title: "Select Your Letter Style",
        closeOnEscape: false,
        open: function(){
          $('.ui-dialog').css('top','50px');
          $('.ui-dialog-titlebar').hide();
          $('#resume_preview .after_comma:empty').hide();
        },
        close: function(){
          document.location.href = '/letters';
        }
      });
    }
  }
}
