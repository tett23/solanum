migration 1, :create_logs do
  up do
    create_table :logs do
      column :id, Integer, :serial => true
      column :channel, String, :length => 255
      column :body, Text
    end
  end

  down do
    drop_table :logs
  end
end
