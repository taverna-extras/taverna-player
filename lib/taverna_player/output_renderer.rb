
module TavernaPlayer
  class OutputRenderer
    # The renderers are all called in the scope of this class so we include
    # ActionView::Helpers here so that they are all available to them.
    include ActionView::Helpers

    # Taverna Workflow error MIME type
    TAVERNA_ERROR_TYPE = MIME::Type.new("application/x-error")

    def initialize
      @hash = Hash.new
      MIME::Types.add(TAVERNA_ERROR_TYPE)
    end

    def add(mimetype, method, default = false)
      type = MIME::Types[mimetype].first

      @hash[type.media_type] ||= {}
      @hash[type.media_type][type.sub_type] = method
      @hash[type.media_type][:default] = method if default
    end

    def type_default(media_type, method)
      @hash[media_type] ||= {}
      @hash[media_type][:default] = method
    end

    def default(method)
      @hash[:default] = method
    end

    def render(content, mimetype)
      type = MIME::Types[mimetype].first

      renderer = begin
        @hash[type.media_type][type.sub_type]
      rescue
        begin
          @hash[type.media_type][:default]
        rescue
          @hash[:default]
        end
      end

      if renderer.is_a? Proc
        renderer.call(content, type)
      else
        method(renderer).call(content, type)
      end
    end

  end
end
