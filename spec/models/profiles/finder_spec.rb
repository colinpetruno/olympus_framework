require "rails_helper"

RSpec.describe Profiles::Finder, type: :model do
  describe ".for" do
    it "should instantiate a new object" do
      session_info = default_session_info

      expect(Profiles::Finder).to receive(:new).with(session_info)

      Profiles::Finder.for(session_info)
    end
  end

  describe "#for_email" do
    it "should not find hidden profiles" do
      member = create_member(
        deleted_at: DateTime.now,
        profile_attributes: {
          deleted_at: DateTime.now,
          external_slug: SecureRandom.uuid
        }
      )

      finder = Profiles::Finder.new(default_session_info)

      expect(finder.for_email(member.email)).to eql(nil)
    end
  end

  describe "#by_id" do
    it "should find the correct profile" do
      member = create_member

      finder = Profiles::Finder.new(default_session_info)
      expect(finder.by_id(member.profile.id)).to eql(member.profile)
    end
  end

  describe "#for_company_and_id" do
  end

  describe "#for_company" do
  end

  describe "#for_company_paginated" do
  end

  describe "#for_session" do
    it "should find the correct profile" do
      finder = Profiles::Finder.new(default_session_info)
      expect(finder.for_session).to eql(default_session_info.profile)
    end
  end
end
