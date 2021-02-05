require 'rails_helper'

RSpec.describe Profiles::Finder, type: :model do
  describe '.for' do
    it 'should instantiate a new object' do
      session_info = default_session_info

      expect(Profiles::Finder).to receive(:new).with(session_info)

      Profiles::Finder.for(session_info)
    end
  end

  describe '#for_company_and_id' do
  end

  describe '#for_company' do
  end

  describe '#for_company_paginated' do
  end
end
