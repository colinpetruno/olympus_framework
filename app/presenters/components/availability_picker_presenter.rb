module Components
  class AvailabilityPickerPresenter
    attr_reader :meeting_template

    def initialize(meeting_template)
      @meeting_template = meeting_template
    end

    def morning_hours
      (morning_start.to_i..morning_end.to_i)
    end

    def work_hours
      (work_hours_start.to_i..work_hours_end.to_i)
    end

    def evening_hours
      (evening_hours_start.to_i..evening_hours_end.to_i)
    end

    def weekdays
      # rotate is to shift the start day of the week
      (0..6).to_a.rotate(0)
    end

    def availabilities_for(day_num)
      availabilities.select do |object|
        object.day == day_num
      end.sort_by { |object| object.start_time }
    end

    def availability_json
      availabilities.map(&:as_json).to_json
    end

    private

    def availabilities
      @_availabilities ||= find_or_build_availabilities
    end

    def find_or_build_availabilities
      if meeting_template.meeting_availabilities.present?
        meeting_template.meeting_availabilities
      else
        MeetingAvailabilities::Builder.build_for(meeting_template)
      end
    end

    def morning_start
      DateTime.now.utc.beginning_of_day
    end

    def morning_end
      DateTime.now.utc.beginning_of_day + 8.hours
    end

    def work_hours_start
      DateTime.now.utc.beginning_of_day + 8.hours
    end

    def work_hours_end
      work_hours_start + 10.hours
    end

    def evening_hours_start
      DateTime.now.utc.beginning_of_day + 18.hours
    end

    def evening_hours_end
      DateTime.now.utc.end_of_day
    end

  end
end
