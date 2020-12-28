class GdprExport < ApplicationRecord
  belongs_to :profile

  has_one_attached :export_file
end
