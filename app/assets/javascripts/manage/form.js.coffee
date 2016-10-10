$(document).on 'page:change', ->

  $('select.dropdown').dropdown()

  $('#search-user-button').on
    click: ->
      remoteUrl = location.origin + "/manage/users/search"
      data = $('#search-user-value').val()
      $('#search-user-value').val('')
      $.get remoteUrl, { keyword: data }

  $('#detail-user-button').on
    click: ->
      remoteUrl = location.origin + "/manage/users/detail_search"
      data = $('#detail-user-value').val()
      $('#detail-user-value').val('')
      $.post remoteUrl, { openid: data }

  $('#search-doctor-button').on
    click: ->
      remoteUrl = location.origin + "/manage/doctors/search"
      data = $('#search-doctor-value').val()
      $('#search-doctor-value').val('')
      $.get remoteUrl, { keyword: data }

  $('#search-calender-button').on
    click: ->
      remoteUrl = location.origin + "/manage/calenders"
      data = $('#search-calender-value').val()
      if data
        $('#search-calender-value').val('')
        $.get remoteUrl, { openid: data }

  $('#search-good-button').on
    click: ->
      remoteUrl = location.origin + "/manage/goods"
      data = $('#search-good-value').val()
      # if data
      $('#search-good-value').val('')
      $.get remoteUrl, { openid: data }

  $('#detail-doctor-button').on
    click: ->
      remoteUrl = location.origin + "/manage/doctors/detail_search"
      data = $('#detail-doctor-value').val()
      $('#detail-doctor-value').val('')
      $.post remoteUrl, { openid: data }

  $('#baseinfo-add-hospital').on
    click: ->
      remoteUrl = location.origin + "/manage/baseinfo/hospitals"
      data = $('#baseinfo-hospital-value').val()
      if data
        $('#baseinfo-hospital-value').val('')
        $.post remoteUrl, { name: data }

  $('#baseinfo-add-department').on
    click: ->
      remoteUrl = location.origin + "/manage/baseinfo/departments"
      data = $('#baseinfo-department-value').val()
      if data
        $('#baseinfo-department-value').val('')
        $.post remoteUrl, { name: data }

  $('#baseinfo-add-skill').on
    click: ->
      remoteUrl = location.origin + "/manage/baseinfo/skills"
      data = $('#baseinfo-skill-value').val()
      if data
        $('#baseinfo-skill-value').val('')
        $.post remoteUrl, { name: data }

  $('#baseinfo-add-grade').on
    click: ->
      remoteUrl = location.origin + "/manage/baseinfo/grades"
      data = $('#baseinfo-grade-value').val()
      if data
        $('#baseinfo-grade-value').val('')
        $.post remoteUrl, { name: data }

  $('#baseinfo-add-tag').on
    click: ->
      remoteUrl = location.origin + "/manage/baseinfo/tags"
      data = $('#baseinfo-tag-value').val()
      if data
        $('#baseinfo-tag-value').val('')
        $.post remoteUrl, { name: data }

  $('#search-appointment-button').on
    click: ->
      remoteUrl = location.origin + "/manage/appointments"
      data = $('#search-appointment-value').val()
      $('.ui.button.appointment').removeClass('active')
      if data
        $('#search-appointment-value').val('')
        $.ajax
          url: remoteUrl
          type: "GET"
          data: { key: data }
          dataType: "script"
