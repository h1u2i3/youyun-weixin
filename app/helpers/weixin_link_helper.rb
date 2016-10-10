module WeixinLinkHelper

  def primary_link_to(name = nil, options = nil, html_options = nil, &block)
    if html_options && html_options[:class]
      html_options[:class] += ' weui_btn weui_btn_primary'
    else
      html_options = {
        class: 'weui_btn weui_btn_primary'
      }.merge( html_options ? html_options : {} )
    end
    link_to(name, options, html_options, &block)
  end

  def warn_link_to(name = nil, options = nil, html_options = nil, &block)
    if html_options && html_options[:class]
      html_options[:class] += ' weui_btn weui_btn_warn'
    else
      html_options = {
        class: 'weui_btn weui_btn_warn'
      }.merge( html_options ? html_options : {} )
    end
    link_to(name, options, html_options, &block)
  end

  def back_button
    content_tag("button", "点此返回", class: 'back_btn weui_btn weui_btn_primary').html_safe
  end

  def normal_button(title, link)
    content_tag("button", title, data: { link: link }, class: 'nm_btn weui_btn weui_btn_primary').html_safe
  end

  def normal_button(title, link)
    content_tag("button", title, data: { link: link }, class: 'nm_btn post weui_btn weui_btn_primary').html_safe
  end

  def qrcode_link(apm)
    apm_verify_code = Rails.application.message_verifier(apm.doctor.openid).generate(apm.appoint_unique_number)
    image_tag("http://qr.topscan.com/api.php?&w=200&m=0&logo=http://example.com/images/logo.jpg&text=#{apm_verify_code}")
  end

end
