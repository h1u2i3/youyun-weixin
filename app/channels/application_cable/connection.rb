module ApplicationCable
  class Connection < ActionCable::Connection::Base

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.openid
    end

    protected

      def find_verified_user
        if verified_user = User.find_by(openid: cookies.signed[:weixin_user_openid])
          verified_user
        else
          reject_unauthorized_connection
        end
      end

  end
end
