$ ->
  if ($('#index_table_banners').length > 0)
    $('#index_table_banners tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/admin/banners/#{itemId.split('_').pop()}/reposition"
          type: "POST"
          data:
            id: itemId
            prev_id: prevId
            next_id: nextId
    );

  if ($('#index_table_recommends').length > 0)
    $('#index_table_recommends tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/admin/recommends/#{itemId.split('_').pop()}/reposition"
          type: "POST"
          data:
            id: itemId
            prev_id: prevId
            next_id: nextId
    );

  window.HomepageEvent =
    bindFormEvents: ->
      @bindSuccessCallback();
      @SourceTypeSelect();

    SourceTypeSelect: ->
      $("select.trigger_search_form").on "change", (e) ->
        switch this.value
          when 'hotel'
            $('div.hotels').show();
            $('div.infos').hide();
            $('#btn_search_hotels').click();
            $('#input_search_hotels').focus();
          when 'info'
            $('div.infos').show();
            $('div.hotels').hide();
            $('#btn_search_infos').click();
            $('#input_search_infos').focus();
          else
            $('div.infos').hide();
            $('div.hotels').hide();

    bindSuccessCallback: ->
      that = @
      $('.search_hotels_form').on 'ajax:success', (e, data) ->
        $('.hotels tbody tr').remove();
        $(that.createhotels(data)).appendTo('.hotels tbody')
        that.sourceClick();

      $('.search_infos_form').on 'ajax:success', (e, data) ->
        $('.infos tbody tr').remove();
        $(that.createInfos(data)).appendTo('.infos tbody')
        that.sourceClick();

    sourceClick: ->
      $('.sources tbody tr').on 'click', (e) ->
        id = $(this).data('id')
        title = $(this).data('title')
        $('input.source_id').val(id)
        $('input.source_title').val(title)

    createhotels: (hotels) ->
      if hotels.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for hotel in hotels
        trs += "<tr data-id=#{hotel.id} data-title=#{hotel.title} data-type='hotel'>"
        trs += "<td>#{hotel.id}</td>"
        trs += "<td>#{hotel.title}</td>"
        trs += '/<tr>'
      trs

    createInfos: (infos) ->
      if infos.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for info in infos
        trs += "<tr data-id=#{info.id} data-title=#{info.title} data-type='info'>"
        trs += "<td>#{info.id}</td>"
        trs += "<td>#{info.title}</td>"
        trs += '/<tr>'
      trs