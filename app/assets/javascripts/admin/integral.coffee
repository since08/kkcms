$ ->
  if ($('#index_table_integral_rules').length > 0)
    $('#index_table_integral_rules tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/admin/integral_rules/#{itemId.split('_').pop()}/reposition"
          type: "POST"
          data:
            id: itemId
            prev_id: prevId
            next_id: nextId
    );