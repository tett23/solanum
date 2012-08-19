migration 2, :create_channels do
  up do
    create_table :channels do
      column :id, Integer, :serial => true
      column :title, String, :length => 255
      column :description, Text
      column :permission, Integer
    end
  end

  down do
    drop_table :channels
  end
end
