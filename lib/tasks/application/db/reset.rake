namespace :application do
  namespace :db do
    desc "Clear the database and reload needed models for testing"
    task :reset => :environment do
      if Rails.env.production?
        raise StandardError.new("This task is not runnable in production")
      end

      puts "Revoking all authenticated credentials..."
      AuthCredential.all.each do |auth_credential|
        Authentication::Revoker.for(auth_credential)
      end
      puts "Revoking all auth credentials completed."
      puts "Beginning DB reset..."
      puts "Truncating the database..."
      Rake::Task["db:truncate_all"].invoke
      puts "Truncating the database completed."

      puts "Importing Stripe seed data" 
      Billing::Stripe::Sync.perform
      puts "Importing Stripe seed data completed."
      puts "Finished DB reset. Happy developing!"
    end

    desc "Reset billing to a blank slate for all users"
    task :reset_billing => :environment do
      if Rails.env.production?
        raise StandardError.new("This task is not runnable in production")
      end

      puts "Deleting Subscriptions"
      ::Billing::Subscription.all.delete_all
      puts "Deleting Sources"
      ::Billing::Source.all.delete_all
      puts "Deleting charges"
      ::Billing::Charge.all.delete_all
      puts "Deleting customers"
      ::Billing::Customer.all.delete_all
      puts "Deleting payment intents"
      ::Billing::PaymentIntent.all.delete_all
      puts "Deleting invoices"
      ::Billing::Invoice.all.delete_all
      puts "Deleting webhooks"
      ::Billing::Webhook.all.delete_all

      puts "Cleaning up external ids"
      # NOTE: DO NOT drop all the external ids. Products and Plans will get 
      # messed up
      ::Billing::ExternalId.all.map do |external_id|
        if external_id.objectable.blank?
          external_id.destroy
        end
      end
    end
  end
end

