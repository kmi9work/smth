# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



sendCountryOk = ->
  $.ajax
    url: "country_ok_ajax"
    type: "POST"
    data: $('#autocomplete_country').attr('value')

jQuery ->
  $('#autocomplete_country').autocomplete
    source: $('#autocomplete_country').data('autocomplete-source')
  $('#autocomplete_city').autocomplete
    source: $('#autocomplete_city').data('autocomplete-source')
  $('#autocomplete_school').autocomplete
    source: $('#autocomplete_school').data('autocomplete-source')
  $('#autocomplete_university').autocomplete
    source: $('#autocomplete_university').data('autocomplete-source')
  # city = ""
  # country = ""
  # 
  #   
  # $('#autocomplete_country').blur ->
  #   country = "country=" + $(@).attr('value')
  #   $('#autocomplete_city').attr('data-autocomplete-source', "/city_autocomplete?" + country)
  #   
  #   
  # $('#autocomplete_city').blur ->
  #   city = "city=" + $(@).attr('value')
  #   $('#autocomplete_school').attr('data-autocomplete-source', "/school_autocomplete?" + city)
  #   $('#autocomplete_university').attr('data-autocomplete-source', "/school_autocomplete?" + country + "&" + city)
    
    


#   '<input data-autocomplete-source="/city_autocomplete" 
          # id="autocomplete_city" 
          # name="city" 
          # type="text" 
          # class="ui-autocomplete-input" 
          # autocomplete="off" 
          # role="textbox" 
          # aria-autocomplete="list" 
          # aria-haspopup="true">'
  