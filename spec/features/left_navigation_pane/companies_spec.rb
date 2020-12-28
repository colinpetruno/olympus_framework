require "rails_helper"

feature "Company left navigation pane" do
  scenario "can navigate to employees" do
    session_info = default_session_info

    login_as(session_info.member)
    visit(dashboard_root_path)

    find("#navbarCompaniesButton").click
    expect(page).to have_content(I18n.t("common.titles.company.your_company"))

    click_on I18n.t("common.titles.profile.employees")

    within(".content-frame") do
      expect(page).to have_content(I18n.t("common.titles.profile.employees"))
      expect(page).to have_link(session_info.profile.full_name)
    end
  end
end
