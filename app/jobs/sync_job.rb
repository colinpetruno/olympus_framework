class SyncJob < ApplicationJob
  queue_as :default

  def perform(sync_log_id)
    @sync_log = SyncLog.find(sync_log_id)
    @sync_base_class = sync_log.sync_class.constantize
    @sync_log.update(time_start: DateTime.now)

    sync
  end

  def sync
    sync_base_class.for(
      syncable: sync_log.syncable,
      sync_log: sync_log
    )
  rescue StandardError => error
    update_sync_log_error(error)
  end

  private

  attr_reader :sync_log, :sync_provider, :sync_base_class, :member_id

  def update_sync_log_error(error)
    Errors::Reporter.notify(error, false)

    sync_log.update(
      time_end: DateTime.now,
      sync_status: :failed,
      sync_log_output_attributes: {
        id: sync_log.sync_log_output.id,
        company_id: sync_log.company_id,
        output: error.full_message
      }
    )
  end
end
