class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    add_index :departments, [:name, :company_id], unique: true, name: 'unique_company_department_names'
  end
end
