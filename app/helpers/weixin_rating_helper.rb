module WeixinRatingHelper

  def rating_tag rating
    Rating.new(self, rating, weixin_appointment_ratings_path).tag
  end

  class Rating < Struct.new(:view, :rating, :link)

    delegate :content_tag, to: :view

    def tag
      keys_tag + submit_btn
    end

    def keys_tag
      [ :attitude,
        :professional,
        :communicate,
        :statisfication ].map do |key|
          key_tag(key)
      end.join.html_safe
    end

    def key_tag key
      content_tag 'div', '', data: { key: key.to_s, "max-rating": 5 }, class: 'ui massive heart rating'
    end

    def submit_btn
      content_tag 'button', "提交评分", data: { link: link, doctor: rating.doctor_id, user: rating.user_id }, class: 'rating-submit'
    end

  end

end

__END__
validates_presence_of  :attitude
validates_presence_of  :professional
validates_presence_of  :communicate
validates_presence_of  :statisfication
