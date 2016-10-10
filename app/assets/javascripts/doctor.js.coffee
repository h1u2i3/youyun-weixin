#= require jquery
#= require jquery_ujs
#= require fastclick
#= require_tree ./doctor

$ ->
  FastClick.attach(document.body)

  $('.weui_cell, .nm_btn').click ->
    if $(this).data('link')
      window.location = "#{location.origin}#{$(this).data('link')}"

  $('.back, .back_link, .back_btn').click ->
    window.location = "#{location.origin}#{$('.back.icon').data('link')}"
