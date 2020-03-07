class Simditor.BackgroundColorButton extends Simditor.Button

  name: 'backgroundColor'

  icon: 'background-color'

  disableTag: 'pre'

  menu: true

  render: (args...) ->
    super args...
    @editor.formatter._allowedStyles.span.push('background-color')
    @editor.formatter._allowedStyles.b.push('background-color')
    @editor.formatter._allowedStyles.i.push('background-color')
    @editor.formatter._allowedStyles.strong.push('background-color')
    @editor.formatter._allowedStyles.strike.push('background-color')
    @editor.formatter._allowedStyles.u.push('background-color')

  renderMenu: ->

    lis = ''
    for i in  [1..23]
      lis += """
        <li><a href="javascript:;" class="font-color font-color-#{i}"></a></li>
      """

    $("""
    <ul class="color-list">
      <li><a href="javascript:;" class="font-color font-color-default"></a></li>
      #{lis}
      <li><a href="javascript:;" class="font-color font-color-variable"></a></li>
      <input type="text" class="toolbar-menu-input color-input">
    </ul>
    """).appendTo(@menuWrapper)
    @menuWrapper.on 'mousedown', '.color-list', (e) ->
      false

    @menuWrapper.on 'mousedown', '.color-input', (e) ->
      this.focus()

    @menuWrapper.on 'keyup', '.color-input', (e) ->
      $('.font-color-variable').css("background","##{$(this).val()}");

    @menuWrapper.on 'keypress', '.color-input', (e) ->
      if e.keyCode == 13
        console.log($(this).val())
        return false;


    @menuWrapper.on 'click', '.font-color', (e) =>
      @wrapper.removeClass('menu-on')
      $link = $(e.currentTarget)

      if $link.hasClass 'font-color-default'
        $p = @editor.body.find 'p, li'
        return unless $p.length > 0
        rgb = window.getComputedStyle($p[0], null).getPropertyValue('color')
        hex = @_convertRgbToHex rgb
      else
        rgb = window.getComputedStyle($link[0], null)
          .getPropertyValue('background-color')
        hex = @_convertRgbToHex rgb

      return unless hex

      range = @editor.selection.range()

      if !$link.hasClass('font-color-default') and range.collapsed
        textNode = document.createTextNode(@_t('coloredText'))
        range.insertNode textNode
        range.selectNodeContents textNode

      # 为了搜狗解决浏览器的兼容性问题
      @editor.selection.range range

      # Use span[style] instead of font[color]
      document.execCommand 'styleWithCSS', false, true
      document.execCommand 'BackColor', false, hex
      document.execCommand 'styleWithCSS', false, false

      unless @editor.util.support.oninput
        @editor.trigger 'valuechanged'

  _convertRgbToHex:(rgb) ->
    re = /rgb\((\d+),\s?(\d+),\s?(\d+)\)/g
    match = re.exec rgb
    return '' unless match

    rgbToHex = (r, g, b) ->
      componentToHex = (c) ->
        hex = c.toString(16)
        if hex.length == 1 then '0' + hex else hex
      "#" + componentToHex(r) + componentToHex(g) + componentToHex(b)

    rgbToHex match[1] * 1, match[2] * 1, match[3] * 1


Simditor.Toolbar.addButton Simditor.BackgroundColorButton