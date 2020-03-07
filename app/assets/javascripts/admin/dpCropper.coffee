$ ->
  window.DpCropper =
    call: (source, cropbox, options = {}) ->
      @sourceChangeShowImg(source, cropbox, options)

    sourceChangeShowImg: (source, cropbox, options) ->
      that = @
      source.change ->
        $('#remote_img_url').val('');
        reader = new FileReader()
        reader.onload = (e) ->
          that.toCropbox(cropbox, e.target.result, options)
        reader.readAsDataURL(this.files[0])

    toCropbox: (cropbox, img, options = {}) ->
      if DpCropper.cropper
        DpCropper.cropper.setImage(img)
      else
        default_options = {
          boxWidth: 600
          bgOpacity: .2
          setSelect: [0, 0, 300]
          onSelect: @updateCoords
          onChange: @updateCoords
        }
        DpCropper.cropper = $.Jcrop(cropbox, $.extend({}, default_options, options))
        DpCropper.cropper.setImage(img)

    updateCoords: (coords) ->
      $('#crop_x').val(coords.x)
      $('#crop_y').val(coords.y)
      $('#crop_w').val(coords.w)
      $('#crop_h').val(coords.h)
