require "rails_helper"

feature "checkbox toggles" do
  scenario "should properly update the fields" do
    visit(styleguide_path)

    expect(page).to have_content("Styleguide")

    expect(page).to have_css("#testToggle")

    checkbox_value = find("#testToggleCheckbox", visible: false).checked?
    expect(page).to_not have_css("#testToggle.active")
    expect(checkbox_value).to eq(false)

    find("#testToggle > .toggle-container").click

    checkbox_value = find("#testToggleCheckbox", visible: false).checked?
    expect(page).to have_css("#testToggle.active")
    expect(checkbox_value).to eq(true)

    find("#testToggle > .toggle-container").click

    checkbox_value = find("#testToggleCheckbox", visible: false).checked?
    expect(page).to_not have_css("#testToggle.active")
    expect(checkbox_value).to eq(false)
  end
end
