
module AttendeaseSDK

  class Milestone

    attr_accessor :id, :name, :start_date, :end_date

    def initialize(params = {})
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

  end

end
