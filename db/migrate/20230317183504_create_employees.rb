class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :full_name, null: false
      t.string :email, null: false, unique: true
      t.integer :age, null: false
      t.string :gender, null: false, default: "female"
      t.integer :height, null: false
      t.float :weight
      t.string :image
      t.jsonb :hair, default: {}
      t.inet :ip
      t.string :job_title, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    add_index :employees, :full_name, unique: true
    add_index :employees, :email, unique: true
  end
end
