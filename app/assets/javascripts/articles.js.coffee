jQuery ->
  $('.filter_link').click ->
    $.get($(@).attr('href') + '.json', (data) -> 
      filter = data[0]
      str = "<div class=\"criterions_filter\" id = \"criterions_filter_#{filter.id}\">
        <div class=\"filter selected\" id = \"filter#{filter.id}\"
          <a>#{filter.name}</a>
        </div>
        <ul>"
      for criterion in data[1]
        str += "<li> <a title = \"#{criterion.name}\">#{criterion.name}</a></li>"
      str += "<hr>
        <a id = \"criterions_filter_#{filter.id}_hide\">ok</a>"
      $('#left_container').attr('style', "width: #{154 + ($('.criterions_filter').length)*102}px;")
      $('#left_container').append str
    )
    false
# jQuery ->
#   $('#add_criterion_link').click ->
#     str = "<div id='select_filter' class='select inline'>
#       <select id='criterions_#{gon.criterion_count}_filter_id' 
#               name='criterions[#{gon.criterion_count}][filter_id]' 
#               criterionnum=\"#{gon.criterion_count}\"
#               class=\"criterions_filter_select\">"
#     for filter in gon.filters
#       str += "<option value='#{filter.id}'>#{filter.name}</option>"
#     str += "</select>"
#     str += "</div>"
#     str += "<div id='autocomplete_criterion', class='inline'>"
#     str += "<input data-autocomplete-source=\"/criterions/1/autocomplete.json\" 
#               id=\"criterions_#{gon.criterion_count}_name\" 
#               name=\"criterions[#{gon.criterion_count}][name]\" 
#               type=\"text\"
#               class=\"criterions_name_field\">"
#     str += "</div>"
#     str += "<br>"
#     $('#add_criterions').append(str)
#     gon.criterion_count++
#     enable_select_handler()
#     enable_autocomplete()
#     false
#   
# enable_select_handler = ->
#   $('select.criterions_filter_select').change ->
#     criterion_num = $(@).attr('criterionnum')
#     filter_id = $(@).find('option:selected').attr("value")
#     $("#criterions_#{criterion_num}_name").attr('data-autocomplete-source', "/criterions/#{filter_id}/autocomplete.json")
#     enable_autocomplete() 
#   
#   
# enable_autocomplete = ->  
#   $('input.criterions_name_field').each -> 
#     $(@).autocomplete
#       source: $(@).attr('data-autocomplete-source')
#   
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
# jQuery ->
#   split = (val)-> 
#     val.split( /,\s*/ )
#   extractLast = (term) ->
#     split( term ).pop()
#   $("#ololo")
#     .bind "keydown", (event) -> 
#       if ( event.keyCode == $.ui.keyCode.TAB && $( this ).data( "autocomplete" ).menu.active ) 
#         event.preventDefault();
#     .autocomplete({
#       source: ( request, response ) ->
#         $.getJSON("/criterions/2/autocomplete.json", {term: extractLast( request.term )}, response)
#       search: ->
#         term = extractLast( this.value )
#         if term.length < 1 then return false                
#       focus: -> 
#         return false
#       select: (event, ui) ->
#         terms = split( this.value )
#         # remove the current input
#         terms.pop()
#         # add the selected item
#         terms.push( ui.item.value )
#         # add placeholder to get the comma-and-space at the end
#         terms.push( "" )
#         @.value = terms.join(", ")
#         return false
#       create: -> $(this).autocomplete("search", '')
#       close: -> $(this).autocomplete("search", '')
#     });
# 
# jQuery -> 
#   $("#ololo").autocomplete
#     source: [ 'Toyota', 'Honda', 'Nissan', 'Ford', 'GM' ],
#     minLength: 0
#     
#     select: -> $(this).autocomplete("search", '')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
