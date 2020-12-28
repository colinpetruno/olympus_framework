class ApplicationRecord < ActiveRecord::Base
  include Portunus::Encryptable
  include Harpocrates::Base

  self.abstract_class = true
end
