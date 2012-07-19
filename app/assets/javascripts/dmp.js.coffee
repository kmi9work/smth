# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#autocomplete_country').autocomplete
    source: $('#autocomplete_country').data('autocomplete-source')

jQuery ->
  $('#autocomplete_city').autocomplete
    source: $('#autocomplete_city').data('autocomplete-source')

jQuery ->
  $('#autocomplete_school').autocomplete
    source: $('#autocomplete_school').data('autocomplete-source')

jQuery ->
  $('#autocomplete_university').autocomplete
    source: $('#autocomplete_university').data('autocomplete-source')