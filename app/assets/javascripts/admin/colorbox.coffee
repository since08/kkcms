$ ->
  $('.color-box').on('click', (e) ->
    $(this).colorbox({
      rel: 'group',
      transition: 'fade'
    });
  );

  $('.color-box-group').on('click', (e) ->
    group = this.dataset.group
    $('.group' + group).colorbox({
      rel: 'group' + group,
      transition: 'fade'
    });
  );