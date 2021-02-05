require 'rails_helper'

feature 'Settings data and privacy' do
  scenario 'A person can export their data' do
    session_info = default_session_info

    login_as(session_info.member)

    visit(dashboard_settings_data_and_privacy_path)

    expect(page).to have_content('Data & Privacy')
    expect(page).to have_link('Back')
    expect(page).to have_button('Export my personal data', disabled: false)
    expect(page).to have_link('Close account')

    click_on 'Export my personal data'

    expect(page).to have_content(
        "Your export has been started. We will email it as soon as it's ready!"
      )

    # button is disabled while an export is exporting
    expect(page).to have_button('Export my personal data', disabled: true)

    export = GdprExport.last
    export.update(sent_at: DateTime.now)

    export.export_file.attach(
        io: File.open(Rails.root.join('spec/support/files/empty.json')),
        filename: "#{SecureRandom.uuid}.json"
      )

    page.driver.browser.navigate.refresh

    expect(page).to have_content('Download your last export')
    # enable button after last export is done
    expect(page).to have_button('Export my personal data', disabled: false)

    accept_confirm do
      click_link 'Close account'
    end

    expect(page).to have_content(
        'Your account was disabled and scheduled for removal'
      )
    expect(page).to have_link('Login')
    within find(:css, '.marketing-shared-header') do
      find(:css, '#loginLink').click
    end
    page.driver.browser.navigate.refresh
    expect(page).to have_link('Continue with Google')
  end
end
