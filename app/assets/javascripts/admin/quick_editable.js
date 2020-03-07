var quickEditable = {

  init: function(){
    quickEditable.set_admin_editable_events();
  },

  set_admin_editable_events: function(){
    $(".admin-editable").on("keypress", function(e){
      if ( e.keyCode==27 )
        $( e.currentTarget ).hide();

      if ( e.keyCode==13 ){
        var path        = $( e.currentTarget ).attr("data-path");
        var attr        = $( e.currentTarget ).attr("data-attr");
        var resource_class = $( e.currentTarget ).attr("data-resource-class");
        var val         = $( e.currentTarget ).val();

        val = $.trim(val);
        if (val.length==0)
          val = "&nbsp;";

        $("div#"+$( e.currentTarget ).attr("id")).html(val);
        $( e.currentTarget ).hide();

        var payload = {};
        payload[resource_class] = {};
        payload[resource_class][attr] = val;

        $.ajax({
          url: path,
          type: "PUT",
          data: payload
        }).done(function(result){
          console.log(result);
        });
      }
    });

    $(".admin-editable").on("blur", function(e){
      $( e.currentTarget ).hide();
    });
  },

  editable_text_column_do: function(el){
    var input = "input#"+$(el).attr("id");

    $(input).width( $(el).width()+4 ).height( $(el).height()+4 );
    $(input).css({top: ( $(el).offset().top-2 ), left: ( $(el).offset().left-2 ), position:'absolute'});

    val = $.trim( $(el).html() );
    if (val=="&nbsp;")
      val = "";

    $(input).val( val );
    $(input).show();
    $(input).focus();
  }
};

$( document ).ready(function() {
  quickEditable.init();
});