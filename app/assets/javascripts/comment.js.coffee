#= require jquery
#= require jquery_ujs
#= require rating


  $ ->
    $('.back, .back_link, .back_btn').click ->
      window.location = "#{location.origin}#{$('.back.icon').data('link')}"

    $('.rating').rating()

    $('#new-rating-button').click ->
      target = $(this)
      $.ajax
        type: "POST"
        url: "#{location.origin}#{target.data("link")}"
        data:
          user_id: target.data("user")
          doctor_id: target.data("doctor")
          attitude: $('#attitude').rating('get rating')
          professional: $('#professional').rating('get rating')
          statisfication: $('#statisfication').rating('get rating')

    $('#new-comment-button').click ->
      target = $(this)
      $.ajax
        type: "POST"
        url: "#{location.origin}#{target.data("link")}"
        data:
          user_id: target.data("user")
          doctor_id: target.data("doctor")
          content: $("textarea[name='content']").val()
