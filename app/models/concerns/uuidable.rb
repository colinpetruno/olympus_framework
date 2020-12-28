module Uuidable
  module InstanceMethods
    def generate_uuid
      self.uuid = SecureRandom.uuid
    end

    def to_param
      self.uuid
    end
  end

  def self.included(base)
    base.send :include, InstanceMethods
    base.before_create :generate_uuid

    base.send :validates_uniqueness_of, :uuid, { on: :update }
    base.send :validates_presence_of, :uuid, { on: :update }
  end
end
