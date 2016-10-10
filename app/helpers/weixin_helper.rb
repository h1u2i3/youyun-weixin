module WeixinHelper

  def weixin_header(title, path=nil)
    content = []
    if path
      content << content_tag("div", "", data: { link: path }, class: "back icon icon-left-nav")
    end
    content << content_tag("h1", title, class: "page_title")
    content_tag "div", class: "hd" do
      content.join.html_safe
    end.html_safe
  end

  def weixin_content(*args, &block)
    content = self.capture(args, &block)
    content_tag "div", class: "bd" do
      content
    end.html_safe
  end

  def weixin_doctor_list(doctors, title=nil)
    title ||= "推荐医生"
    content = content_tag "div", title, class: "weui_cells_title"
    content << render(partial: 'weixin/page/doctor', collection: doctors)
    content_tag "div", class: "weui_cells weui_cells_access" do
      content
    end.html_safe
  end

  def weixin_doctor(*args)
    render(partial: 'weixin/doctors/doctor', locals: { doctor: args[0], ratings: args[1], comments: args[2], calenders: args[3] })
  end

end

__END__

.appointment-detail
  i.weui_icon_msg.weui_icon_waiting
  .appointment-detail--price
    | ￥
    = appointment.good.price
  = render partial: "weixin/appointments/action/base", locals: {appointment: appointment}
