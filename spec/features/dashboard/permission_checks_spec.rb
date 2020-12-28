require "rails_helper"

feature "Admins should see extra buttons" do
  scenario "They should get a settings & billing icon as well as settings" do
    session_info = default_session_info
    login_as(session_info.member)

    visit(dashboard_settings_root_path)
    expect(page).to have_content("Settings")

    expect(page).to have_link("Company Settings")
    expect(page).to have_link("Billing & Subscription")
    expect(page).to have_link("Data & Privacy")

    expect(page).to have_selector("#BillingLink")

    # NOTE: Ensure we check all future roles as well
    hidden_roles = Profile.roles.keys - ["company_admin"]
    hidden_roles.map do |role|
      session_info.profile.update(role: role.to_sym)

      visit(dashboard_settings_root_path)

      expect(page).to have_content("Settings")
      expect(page).to have_link("Data & Privacy")

      # NOTE: Ensure assert hidden elements
      expect(page).to_not have_link("Company Settings")
      expect(page).to_not have_link("Billing & Subscription")
      expect(page).to_not have_selector("#BillingLink")
    end
  end
end
