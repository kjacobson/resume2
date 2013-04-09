class ChangeLoginValidationExpirationToExpirationDate < ActiveRecord::Migration
  def up
    rename_column :login_validations, :expiration, :expiration_date
    rename_column :links, :expiration, :expiration_date
  end

  def down
    rename_column :login_validations, :expiration_date, :expiration
    rename_column :links, :expiration, :expiration_date
  end
end
