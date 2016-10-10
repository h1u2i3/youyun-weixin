$(document).on 'page:change', ->

  showAddButton = ->
    dayString = $(this).find('.add-calender').attr('id')
    openid = $('h4#openid').text().trim()
    today = new Date()
    day = new Date(dayString)
    $(this).find('.add-calender').empty()
    if nextDay(day, today)
      $(this).find('.add-calender').append($("<a class=\"ui mini red button\"" + " href=\"/manage/calenders/new?date=" + dayString + "&openid=" + openid + "\" data-remote=\"true\">添加</a>"))

  hideAddButton = ->
    $(this).find('.add-calender').empty()

  nextDay = (day, today) ->
    new Date(day.getYear(), day.getMonth(), day.getDate()) >= new Date(today.getYear(), today.getMonth(), today.getDate())

  $('#doctor-calender').on 'mouseenter', 'td.day', showAddButton
  $('#doctor-calender').on 'mouseleave', 'td.day', hideAddButton
