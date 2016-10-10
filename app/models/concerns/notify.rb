module Notify
  extend ActiveSupport::Concern

  class ListenerSet
    def add_listener(listener)
      (@listeners || []) << listener
    end

    def notify(resource, event_name, *args)
      @listeners && @listeners.each do |listener|
        if listener.respond_to?("on_#{event_name}")
          listener.public_send("on_#{event_name}", resource, *args)
        end
      end
    end
  end

  class GenericListener
    def initialize(event_name, handler)
      @event_name = event_name
      @handler    = handler
    end

    def respond_to_missing?(method_name, include_private=false)
      method_name.to_s == "on_#{@event_name}"
    end

    def method_missing(method_name, *args)
      if respond_to_missing?(method_name)
        @handler.call(*args)
      else
        super
      end
    end
  end

  class ListenerSetBuilder
    def initialize(listeners)
      @listeners = listeners
    end

    def method_missing(method_name, &block)
      event_name = method_name.to_s.sub(/^on_/, '')
      listener   = GenericListener.new(event_name, block)
      @listeners.add_listener(listener)
    end
  end

end
