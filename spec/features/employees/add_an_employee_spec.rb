require "rails_helper"

feature "Add a coworker" do
  scenario "A coworker can be properly added and passes validation" do
    session_info = default_session_info

    login_as(session_info.member)

    # load new employees page
    visit(new_dashboard_profile_path)
    expect(page).to have_content(I18n.t("common.titles.profile.add_profile"))

    # fill in some invalid data
    fill_in(
      I18n.t("simple_form.labels.profile.given_name"),
      with: "Pascal"
    )

#   skip this one to trigger an error
#    fill_in(
#      I18n.t("simple_form.labels.profile.family_name"),
#      with: "Fluffy"
#    )

    fill_in(
      I18n.t("simple_form.labels.profile.email"),
      with: "bademail@not_a_working_domain_for_this.zzz"
    )

    # submit invalid data
    click_on I18n.t("buttons.defaults.profile.create")

    # check for error messages
    expect(page).to have_content(I18n.t("errors.messages.blank"))

    # correct invalid data
    fill_in(
      I18n.t("simple_form.labels.profile.family_name"),
      with: "Fluffy"
    )

    # submit the form
    click_on I18n.t("buttons.defaults.profile.create")

    # ensure redirect to teams page and member added
    expect(page).to have_content("Pascal Fluffy")
  end
end
