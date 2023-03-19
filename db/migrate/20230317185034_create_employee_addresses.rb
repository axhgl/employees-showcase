class CreateEmployeeAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_addresses do |t|
      t.string :street
      t.string :city
      t.point :coordinates
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
