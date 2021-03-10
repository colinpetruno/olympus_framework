# frozen_string_literal: true

# Template table for mails
class CreateMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_templates do |t|
      t.string :class_name, null: false
      t.string :method_name, null: false
      t.string :subject, null: false
      t.string :content, null: false
      t.string :bcc, null: true
      t.boolean :active, null: true
      t.timestamps

      t.index :class_name
      t.index :method_name
    end
  end
end
