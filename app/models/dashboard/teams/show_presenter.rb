module Dashboard
  module Teams
    class ShowPresenter
      attr_reader :team

      def self.for(team, session_info)
        new(team, session_info)
      end

      def initialize(team, session_info)
        @session_info = session_info
        @team = team
      end

      def team_name
        @team.team_name
      end

      def team_members

      end

      private

      attr_reader :session_info
    end
  end
end
