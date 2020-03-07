$ ->
  window.DpReposition =
    call: (source, url) ->
      $(source).sortable(
        update: (e, ui) ->
          itemId = ui.item.attr('id')
          prevId = ui.item.prev().attr('id')
          nextId = ui.item.next().attr('id')

          $.ajax
            url: url.replace(':id', itemId.split('_').pop())
            type: "POST"
            data:
              id: itemId
              prev_id: prevId
              next_id: nextId
      );