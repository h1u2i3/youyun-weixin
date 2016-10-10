module WeixinTableHelper
  def weixin_table(datas=[], options={}, &block)
    WeixinTable.new(self, datas, options, block).table
  end

  class WeixinTable < Struct.new(:view, :datas, :options, :callback)

    delegate :content_tag, to: :view

    def table
      content_tag :ul, options do
        content
      end
    end

    def content
      datas.map do |data|
        content_tag :li, class: 'nm_btn', data: { link: Rails.application.routes.url_helpers.send("weixin_#{data.class.to_s.pluralize.downcase}_path", {id: data.id }) } do
          callback.call(data)
        end
      end.join.html_safe
    end

  end
end
