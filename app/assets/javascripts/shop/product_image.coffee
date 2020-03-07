$ ->
  if ($('#index_table_images').length > 0)
    $('#index_table_images tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/shop/products/0/images/#{itemId.split('_').pop()}/reposition"
          type: "POST"
          data:
            id      : itemId
            prev_id : prevId
            next_id : nextId
    );
