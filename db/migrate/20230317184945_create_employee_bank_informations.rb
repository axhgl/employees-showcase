class CreateEmployeeBankInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_bank_informations do |t|
      t.string :card_expiration
      t.string :card_number
      t.string :card_type
      t.string :currency
      t.string :iban
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
