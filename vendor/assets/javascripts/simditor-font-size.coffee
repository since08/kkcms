class Simditor.FontSizeButton extends Simditor.Button

  name: 'fontSize'

  icon: 'font'

  disableTag: 'pre'

  menu: true

  constructor: (args...) ->
    super args...
    @editor.formatter._allowedStyles.span.push('font-size')
    @editor.formatter._allowedStyles.b.push('font-size')
    @editor.formatter._allowedStyles.i.push('font-size')
    @editor.formatter._allowedStyles.strong.push('font-size')
    @editor.formatter._allowedStyles.strike.push('font-size')
    @editor.formatter._allowedStyles.u.push('font-size')

  render: (args...) ->
    super args...

  renderMenu: ->

    lis = ''
    for i in  [10..36]
      lis += """
        <li><span class="font-size font-size-#{i}">#{i}</span></li>
      """

    $("""
    <ul class="font-size-list">
      #{lis}
    </ul>
    """).appendTo(@menuWrapper)
    @menuWrapper.on 'mousedown', '.font-size-list', (e) ->
      false

    @menuWrapper.on 'click', '.font-size', (e) =>
      @wrapper.removeClass('menu-on')
      range = @editor.selection.range()

      # 为了搜狗解决浏览器的兼容性问题
      @editor.selection.range range

      console.log(e.target.textContent)
      # Use span[style] instead of font[color]
      document.execCommand 'styleWithCSS', false, true
      document.execCommand("fontSize", false, "7");
      @editor.body.find('[style*="font-size: -webkit-xxx-large"]').css("font-size", "#{e.target.textContent}px")
      document.execCommand 'styleWithCSS', false, false

      unless @editor.util.support.oninput
        @editor.trigger 'valuechanged'

Simditor.Toolbar.addButton Simditor.FontSizeButton