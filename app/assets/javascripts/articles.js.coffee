jQuery ->
  $('#add_criterion_link').click ->
    str = "<div id='select_filter' class='select inline'>
      <select id='criterions_#{gon.criterion_count}_filter_id' 
              name='criterions[#{gon.criterion_count}][filter_id]' 
              criterionnum=\"#{gon.criterion_count}\"
              class=\"criterions_filter_select\">"
    for filter in gon.filters
      str += "<option value='#{filter.id}'>#{filter.name}</option>"
    str += "</select>"
    str += "</div>"
    str += "<div id='autocomplete_criterion', class='inline'>"
    str += "<input data-autocomplete-source=\"/autocomplete_criterion/1.json\" 
              id=\"criterions_#{gon.criterion_count}_name\" 
              name=\"criterions[#{gon.criterion_count}][name]\" 
              type=\"text\"
              class=\"criterions_name_field\">"
    str += "</div>"
    str += "<br>"
    $('#add_criterions').append(str)
    gon.criterion_count++
    enable_select_handler()
    enable_autocomplete()
    false
  
enable_select_handler = ->
  $('select.criterions_filter_select').change ->
    criterion_num = $(@).attr('criterionnum')
    filter_id = $(@).find('option:selected').attr("value")
    $("#criterions_#{criterion_num}_name").attr('data-autocomplete-source', "/autocomplete_criterion/#{filter_id}.json")
    enable_autocomplete() 
  
  
enable_autocomplete = ->  
  $('input.criterions_name_field').each -> 
    $(@).autocomplete
      source: $(@).attr('data-autocomplete-source')