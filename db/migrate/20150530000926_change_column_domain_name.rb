class ChangeColumnDomainName < ActiveRecord::Migration
  def change
    add_index :domains, :name
  end
end
