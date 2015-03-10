module AnypresenceGenerator
  module Utils
    module WrapCalls

      DEFAULT_MAX_NETWORK_RETRY = 3
      ## 
      # Retry the provided block when it raises and exception up to +up_to+ times.
      #
      def with_retry(up_to=DEFAULT_MAX_NETWORK_RETRY, &block)
        up_to = DEFAULT_MAX_NETWORK_RETRY if up_to.nil?
        (1..up_to).each do |attempt|
          delay_seconds = 2**attempt
          begin
            return block.call
          rescue => e
            sleep(delay_seconds)

            if attempt == up_to
              # Give up by re-raising the exception
              raise e
            end
          end
        end
      end

    end
  end
end