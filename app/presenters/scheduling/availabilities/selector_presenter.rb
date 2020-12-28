module Scheduling::Availabilities
  class SelectorPresenter
    def initialize(session_info, meeting_template, target_date, selected_date)
      @meeting_template = meeting_template
      @session_info = session_info
      @target_date = Utilities::Time::UnixToDateTime.for(target_date) || (DateTime.now)
      @selected_date = if selected_date.present?
                         selected_date
                       else
                         (@target_date + 1.day)
                       end
    end

    def dates
      (target_date..(target_date + 6.days))
    end

    def classes_for(date)
      classes = ["date"]
      classes.push("today") if date.to_date === Date.today
      classes.push("selected") if date.to_date === selected_date.to_date
      classes.push("disabled") if date.to_date < Date.today

      classes.join(" ")
    end

    def classes_for_availability_window(date_key)
      active = selected_date.strftime("%Y%m%d") == date_key
      classes = ["availabilities", "availabilities-for-#{date_key}"]
      classes.push("show") if active

      classes.join(" ")
    end

    def classes_for_prev
      classes = ["change-week", "prev-week"]
      classes.push("disabled") if (target_date - 1.week).to_date < Date.today

      classes.join(" ")
    end

    def classes_for_next
      classes = ["change-week", "next-week"]
      classes.push("disabled") if target_date.to_date > (Date.today + 3.months)

      classes.join(" ")
    end

    def availability_keys
      availabilities.availability_map.keys.sort
    end

    def availabilities_for(date_key)
      availabilities.availability_map[date_key].sort_by(&:start_time)
    end

    def availabilities
      @_availabilities ||= Scheduling::AvailabilityList.new(
        session_info,
        meeting_template,
        dates
      )
    end

    def next_week_date
      target_date.to_i + 60 * 60 * 24 * 7
    end

    def previous_week_date
      target_date.to_i - 60 * 60 * 24 * 7
    end

    def empty_message_for(date_key)
      availabilities.next_availabilities_message(date_key)
    end

#    private

    attr_reader :target_date, :selected_date, :session_info, :meeting_template
  end
end
