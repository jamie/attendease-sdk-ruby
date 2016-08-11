module AttendeaseSDK
  module Configuration

    class << self

      def set_config
        
        configuration = YAML::load_file(File.dirname(__FILE__) + "/configuration.yml")

        AttendeaseSDK.environment = Rails.env

        AttendeaseSDK.user_token = case AttendeaseSDK.environment
        when 'preview'
          configuration['attendease_sdk']['user_token']['preview']
        else
          configuration['attendease_sdk']['user_token']['production']
        end

      end
    end
  end
end
