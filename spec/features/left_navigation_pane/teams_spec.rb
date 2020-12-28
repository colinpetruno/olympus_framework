require "rails_helper"

feature "Team left navigation pane" do
  scenario "teams are listed alphabetically" do
    session_info = default_session_info

    Team.create(company: session_info.company, team_name: "ZZZ team")
    Team.create(company: session_info.company, team_name: "BBB team")
    Team.create(company: session_info.company, team_name: "AAA team")

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarTeamsButton").click

    expect(page).to have_content("AAA team")

    names = page.
      all(".dashboard-left_navigation_pane-team_list .list > .team > a").
      collect(&:text)

    expect(names).to eql(["AAA team", "BBB team", "Unassigned", "ZZZ team"])
  end

  scenario "teams should be able to be navigated to" do
    session_info = default_session_info

    Team.create(company: session_info.company, team_name: "BBB team")

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarTeamsButton").click

    expect(page).to have_content("BBB team")

    click_on "BBB team"

    within ".dashboard-teams-show" do
      expect(page).to have_content("BBB team")
    end
  end
end
