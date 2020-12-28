require "rails_helper"

feature "Create and manage booking spec" do
  scenario "An external person can create and manage their booking" do
    session_info = default_session_info

    # the default availabilities are Mon-Friday 9am-4pm in 15 min increments
    # we will freeze a time that works for us
    Timecop.travel(DateTime.parse("20201111"))

    login_as(session_info.member)

    visit(scheduling_profile_path(session_info.profile.external_slug))

    expect(page).to have_content("The schedule of")

    click_on "30 min"

    expect(page).to have_content("Choose the time which works best for you")

    find("div[data-date='20201113']").click

    expect(page).to have_content("12:30pm")

    expect(page).to have_button("Confirm Appointment", disabled: true)

    # NOTE: The default calendar seeded from the data is Europe / Amsterdam
    # and thus we need to offset an hour back when getting the UTC time
    time_unix = DateTime.parse("202011131130").to_i

    find("div.availability[data-unix-time='#{time_unix}']").click

    expect(page).to have_button("Confirm Appointment", disabled: false)

    click_on "Confirm Appointment"

    expect(page).to have_content("30 minutes")
    expect(page).to have_content("12:30 - 1:00pm on November 13th, 2020")
    expect(page).to have_content("Europe - Amsterdam")

    click_on "Confirm appointment"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Email can't be blank")

    fill_in "Name", with: "Pascal Fluffy"
    fill_in "Email", with: "pfluffy@example.com"
    fill_in "Details", with: "Hey let's meow"

    click_on "Confirm appointment"

    expect(page).to have_content("Hey let's meow")
    expect(page).to have_link("Update event")
    expect(page).to have_link("Reschedule event")
    expect(page).to have_link("Cancel event")

    # Check various display states based on time
    Timecop.travel(DateTime.parse("20201120"))

    page.driver.browser.navigate.refresh

    expect(page).to have_content("This event is now over.")

    Timecop.travel(DateTime.parse("20201111"))

    page.driver.browser.navigate.refresh
    expect(page).to have_content("Hey let's meow")

    click_on "Update event"
    expect(page).to have_content("Review and confirm your changes")

    fill_in "Details", with: "Hey, let's meow more"
    click_on "Confirm appointment"

    expect(page).to have_content("Hey, let's meow more")
    expect(page).to have_content("Your event was updated successfully")

    click_on "Reschedule event"
    expect(page).to have_content("Change your upcoming appointment")

    find("div[data-date='20201117']").click
    expect(page).to have_content("12:30pm")

    # NOTE: The default calendar seeded from the data is Europe / Amsterdam
    # and thus we need to offset an hour back when getting the UTC time
    time_unix = DateTime.parse("202011171130").to_i

    find("div.availability[data-unix-time='#{time_unix}']").click

    expect(page).to have_button("Confirm Appointment", disabled: false)

    click_on "Confirm Appointment"

    expect(page).to have_content("30 minutes")
    expect(page).to have_content("12:30 - 1:00pm on November 17th, 2020")
    expect(page).to have_content("Europe - Amsterdam")

    click_on "Confirm"
    expect(page).to have_content(
      "Your meeting has been successfully rescheduled"
    )

    click_on "Cancel event"
    expect(page).to have_content("Cancel your appointment")
    fill_in "Cancellation reason", with: "Sorry, I need to move this"
    click_on "Confirm cancellation"

    expect(page).to have_content("Your meeting was cancelled successfully")
    expect(page).to have_content("This meeting was cancelled on")
    expect(page).to have_link("Book a new appointment")

    Timecop.return
  end
end
