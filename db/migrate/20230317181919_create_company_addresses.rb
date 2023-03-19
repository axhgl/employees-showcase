class CreateCompanyAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :company_addresses do |t|
      t.string :street, null: false
      t.string :city
      t.point :coordinates, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
