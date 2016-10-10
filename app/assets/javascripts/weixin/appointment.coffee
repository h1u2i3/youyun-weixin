$ ->
  $('#buy-appointment--form-submit').click ->

    # showTooltops = ->
    #   tooltips = $('.js_tooltips')
    #   if tooltips.css('display') != 'none'
    #     return
    #   $('.page.cell').removeClass('slideIn')
    #   tooltips.show()
    #   hide = ->
    #     tooltips.hide()
    #   setTimeout hide, 2000
    #
    # if $('#appointment_cellphone').val().length == 0 || ! /^1\d{10}$/.test($('#appointment_cellphone').val())
    #   $('#appointment_cellphone').parent().parent().addClass('weui_cell_warn')
    #   showTooltops()
    # else
    #   $('#appointment_cellphone').parent().parent().removeClass('weui_cell_warn')
    # if $('#appointment_case_attributes_symptom').val().length <= 10
    #   $('#appointment_case_attributes_symptom').parent().parent().addClass('weui_cell_warn')
    #   showTooltops()
    # else
    #   $('#appointment_case_attributes_symptom').parent().parent().removeClass('weui_cell_warn')
    # if /^1\d{10}$/.test($('#appointment_cellphone').val()) && $('#appointment_case_attributes_symptom').val().length > 10
      $('.buy-appointment--form').submit()

  $('#cancel-appointment').click ->
    confirmDialog = $('#cancel-dialog')
    id = $(this).data('id')
    confirmDialog.show()
    $('.weui_btn_dialog.default').click ->
      confirmDialog.hide()
    $('.weui_btn_dialog.primary').click ->
      confirmDialog.hide()
      $.ajax
        type: 'POST'
        url: "#{location.origin}/appointments/#{id}/cancel"

  $('#pay-appointment').click ->
    showLoading = ->
      loadingToast = $('#loadingToast')
      if loadingToast.css('display') != 'none'
        return
      loadingToast.show()
      hide = ->
        loadingToast.hide()
      setTimeout hide, 2000
    $.ajax
      type: 'POST'
      url: "#{location.origin}/appointments/pay"
      data: {id: $(this).data('id')}
    showLoading()
