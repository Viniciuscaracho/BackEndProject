class CreateCpfs < ActiveRecord::Migration[7.1]
  def change
    create_table :cpfs do |t|
      t.string :cpf, null: false
      t.timestamps
    end
  end
end
