# frozen_string_literal: true

require 'rails_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password' do
    session_info = default_session_info

    login_as(session_info.member)

    visit(dashboard_root_path)

    expect(find('#LeftNavPaneContent').visible?).to eql(true)
    width = page.evaluate_script("$('#LeftNavPaneContent').width();")
    expect(width).to be >= 250

    find('#LeftNavPaneToggle').click
    width = page.evaluate_script("$('#LeftNavPaneContent').width();")
    expect(width).to eql(0)

    find('#LeftNavPaneToggle').click
    expect(find('#LeftNavPaneContent', visible: :all).visible?).to eql(true)
    width = page.evaluate_script("$('#LeftNavPaneContent').width();")
    expect(width).to be >= 250
  end
end
