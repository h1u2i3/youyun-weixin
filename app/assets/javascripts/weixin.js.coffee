#= require jquery
#= require jquery_ujs
#= require jquery.qrcode.min
#= require rating
#= require fastclick
#= require cable
#= require weixin_cable
#= require_tree ./cable
#= require_tree ./weixin

$ ->

  FastClick.attach(document.body)

  # sidebar = new Sidebar
  # sidebar.start()

  $('.weui_cell, .nm_btn').click ->
    if $(this).data('link')
      window.location = "#{$(this).data('link')}"

  $('.back, .back_link, .back_btn').click ->
    window.location = "#{location.origin}#{$('.back.icon').data('link')}"

  # fix form enter to submit
  $('form').on 'keypress', (e) ->
    if e.keyCode == 13
      return false
