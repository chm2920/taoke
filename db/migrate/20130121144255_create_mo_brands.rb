class CreateMoBrands < ActiveRecord::Migration
  def change
    create_table :mo_brands do |t|
      t.string :name
    end
  end
end
