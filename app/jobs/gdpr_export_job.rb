class GdprExportJob < ApplicationJob
  queue_as :exports

  def perform(gdpr_expert_id)
    export = GdprExport.find(gdpr_expert_id)
    profile = export.profile

    exporter = GdprExporter.for(profile)

    # ensure the folder exists
    Documents::Folder.for("/tmp/gdpr_exports")
    filename = "#{SecureRandom.uuid}.json"
    full_path = "/tmp/gdpr_exports/#{filename}"

    File.open(full_path, "wb") do |f|
      f.write(exporter.export.to_json)
    end

    export.export_file.attach(
      io: File.open(full_path),
      filename: filename
    )

    # TODO: send email notification
    export.update(sent_at: DateTime.now)
  end
end
