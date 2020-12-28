require "rails_helper"

feature "Onboarding" do
  scenario "The onboarding happy path can be clicked through to the dashboard" do
    session_info = default_session_info

    login_as(session_info.member)

    # load new employees page
    visit(dashboard_onboarding_company_settings_path)

    expect(page).to have_content(
      I18n.t("dashboard.onboarding.company_settings.index.step_title")
    )

    click_on(
      I18n.t("dashboard.onboarding.company_settings.index.next_step_button")
    )

    expect(page).to have_content(
      I18n.t("dashboard.onboarding.calendars.index.step_title")
    )

    click_on(
      I18n.t("dashboard.onboarding.calendars.index.next_step_button")
    )

    expect(page).to have_content(
      I18n.t("dashboard.onboarding.introductions.index.description").strip
    )

    click_on(
      I18n.t("dashboard.onboarding.introductions.index.next_step_button")
    )

    expect(page).to have_content(
      I18n.t("dashboard.home.show.title")
    )
  end
end
