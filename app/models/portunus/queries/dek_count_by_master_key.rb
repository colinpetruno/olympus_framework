module Portunus::Queries
  class DekCountByMasterKey
    class MasterKeyDekCount
      attr_reader :master_keyname, :count

      def initialize(master_keyname:, count:)
        @count = count
        @master_keyname = master_keyname
      end
    end

    def self.get_counts
      new().get_counts
    end

    def get_counts
      return results
    end

    private

    def results
      @_results ||= rows.map do |row|
        MasterKeyDekCount.new(
          count: row["count"],
          master_keyname: row["master_keyname"]
        )
      end
    end

    def rows
      @_rows ||= ApplicationRecord.connection.execute(sql)
    end

    def sql
      <<~SQL
        SELECT master_keyname, count(1)
          FROM portunus_data_encryption_keys
          GROUP BY master_keyname
      SQL
    end
  end
end
