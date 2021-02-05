require 'rails_helper'

feature 'Login and out' do
  scenario 'it should redirect to the dashboard and allow you to log out' do
    session_info = default_session_info
    login_as(session_info.member)

    visit(dashboard_root_path)

    expect(page).to have_content(
      I18n.t('dashboard.home.show.title')
    )

    find('#logoutLink').click
    page.driver.browser.navigate.refresh
    expect(page).to have_content(
      I18n.t('marketing.static_pages.homepage.hero.message').strip, normalize_ws: true
    )
  end
end
