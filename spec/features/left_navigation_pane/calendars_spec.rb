require "rails_helper"

feature "Calendar left navigation pane" do
  scenario "calendars are listed alphabetically" do
    session_info = default_session_info
    create_calendar_for(session_info.member, options: { name: "qqq" })
    create_calendar_for(session_info.member, options: { name: "zzz" })
    create_calendar_for(session_info.member, options: { name: "aaa" })
    create_calendar_for(session_info.member, options: { name: "rrr" })

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarCalendarsButton").click

    expect(page).to have_content("aaa")

    names = page.
      all(".dashboard-left_navigation_pane-calendar_list .calendar > header > div").
      collect(&:text)

    expect(names).to eql(["aaa", "qqq", "rrr", "zzz"])
  end

  scenario "toggling a calendar on and off" do
    session_info = default_session_info
    calendar = create_calendar_for(
      session_info.member,
      options: { name: "qqq" }
    ).first

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarCalendarsButton").click


    expect(page).to have_content("qqq")
    expect(page).to have_selector("#calendar-#{calendar.id}.toggle.enabled")
    find("#calendar-#{calendar.id} .toggle-container").click

    visit current_path
    find("#navbarCalendarsButton").click
    expect(page).to have_content("qqq")
    expect(page).not_to have_selector("#calendar-#{calendar.id}.toggle.enabled")
    expect(page).to have_selector("#calendar-#{calendar.id}.toggle")
  end

  scenario "a calendar can be nagivated to" do
    session_info = default_session_info
    calendar = create_calendar_for(
      session_info.member,
      options: { name: "Colin's Calendar" }
    ).first

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarCalendarsButton").click

    click_on("Colin's Calendar")
    expect(page).to have_content("Colin's Calendar", minimum: 2)
  end
end
