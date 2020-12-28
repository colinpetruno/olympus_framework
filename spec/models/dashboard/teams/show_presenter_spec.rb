require "rails_helper"

RSpec.describe ::Dashboard::Teams::ShowPresenter, type: :model do
  describe "#team_name" do
    it "should return the proper team name" do
      session_info = default_session_info

      team = Team.new(
        team_name: "Test team name",
        company: session_info.company
      )

      presenter = ::Dashboard::Teams::ShowPresenter.for(team, session_info)

      expect(presenter.team_name).to eql("Test team name")
    end
  end
end
