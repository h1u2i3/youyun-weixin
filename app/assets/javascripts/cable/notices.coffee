App.notices = App.cable.subscriptions.create "NoticesChannel",
  collection: -> $("[data-channel='notices']")

  connected: ->
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @subCurrentDoctor()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    switch data.status
      when 'appointment'
        $("[data-day='#{data.day}']").parent().empty().append($(data.view))
      when 'good'
        console.log data
        mask = $('#mask')
        weuiActionsheet = $('#calender-actionsheet')
        unless mask.css('display') == 'none'
          weuiActionsheet.removeClass('weui_actionsheet_toggle')
          mask.removeClass('weui_fade_toggle')
          weuiActionsheet.on 'transitionend', ->
            mask.hide()
          weuiActionsheet.on 'webkitTransitionEnd', ->
            mask.hide()
        $("[data-doctor-goods='#{data.doctor}']").empty().append($(data.view))
      when 'calender'
        $('#calender-actionsheet').empty().append($(data.view))

  subCurrentDoctor: ->
    if doctorId = @collection().data('doctor')
      @perform 'follow', doctor_id: doctorId
    else
      @perform 'unfollow'
    @installedPageChangeCallback = true


  # smart so smart!!!
  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).ready -> App.notices.subCurrentDoctor()
