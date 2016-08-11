module AttendeaseSDK
  module Configuration

    class << self

      def set_config
        data_path = Rails.root.join('lib','tasks','lib','client_integration','attendease_sdk')
        configuration = YAML::load_file(File.join(data_path, 'configuration.yml'))

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
