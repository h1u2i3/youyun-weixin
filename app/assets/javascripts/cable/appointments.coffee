App.appointments = App.cable.subscriptions.create "AppointmentsChannel",
  collection: -> $("[data-channel='appointments']")

  connected: ->
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @subCurrentAppointment()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    if data.status
      window.location.href = window.location.href

  subCurrentAppointment: ->
    if appointmentId = @collection().data('appointment')
      @perform 'follow', appointment_id: appointmentId
    else
      @perform 'unfollow'
    @installedPageChangeCallback = true


  # smart so smart!!!
  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).ready -> App.appointments.subCurrentAppointment()
