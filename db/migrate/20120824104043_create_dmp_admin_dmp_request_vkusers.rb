class CreateDmpAdminDmpRequestVkusers < ActiveRecord::Migration
  def change
    create_table :dmp_admin_dmp_request_vkusers do |t|
      t.integer :vkuser_id
      t.integer :dmp_admin_id
      t.integer :dmp_request_id
      t.timestamps
    end
  end
end
