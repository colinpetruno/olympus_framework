module Accounts
  class Creator
    # this creates accounts from atttributes and is called via the callback
    # creator processor from omniauth but will need to get hooked to a form
    # at some point
    def self.for(attrs={ member: {}, company: {} })
      new(attrs).create
    end

    def initialize(attrs={ member: {}, company: {} })
      @attrs = attrs
    end

    def create
      # Ensure these exist in scope of return values
      company = nil
      member = nil

      ApplicationRecord.transaction do
        account = Account.create
        company = Company.create(attrs[:company].merge(account: account))

        team = Team.create!(
          company: company,
          team_name: I18n.t("models.defaults.team.unassigned_team_name"),
          deletable: false
        )

        member = ::Accounts::AddMember.add(
          attrs[:member].deep_merge({
            company: company,
            profile_attributes: {
              company: company,
              team: team,
              role: :company_admin,
              external_slug: SecureRandom.uuid
            }
          })
        )
      end

      { company: company, member: member }
    end

    private

    attr_reader :attrs
  end
end
