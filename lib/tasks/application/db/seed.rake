namespace :application do
  namespace :db do
    desc "Fill out some recent support requests to mess with"
    task :seed_support_requests => :environment do
      return if Rails.env.production?

      (1..10).each do  |i|
        resolved_at = nil
        profile = Profile.order(Arel.sql('RANDOM()')).first

        resolved = [false, false, false, true].sample
        if resolved
          resolved_at = DateTime.now
        end

        SupportRequest.create(
          supportable: profile,
          company_id: profile.company_id,
          submitted_at: (DateTime.now - 2.weeks..DateTime.now).to_a.sample,
          resolved_at: resolved_at,
          support_request_messages_attributes: [{
            message: Faker::Lorem.sentences(number: 12).join(" "),
            sendable: profile,
            sent_by_staff: false,
            hidden_from_customer: false,
            sent_at: DateTime.now
          }]
        )
      end
    end
  end
end
