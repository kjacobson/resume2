class ChangeLoginValidationAndLinkHashColumns < ActiveRecord::Migration
  def up
    rename_column :login_validations, :hash, :unique_key
    rename_column :links, :hash, :unique_key
  end

  def down
    rename_column :login_validations, :unique_key, :hash
    rename_column :links, :unique_key, :hash
  end
end
