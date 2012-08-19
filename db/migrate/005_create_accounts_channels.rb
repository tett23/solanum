migration 5, :create_accounts_channels do
  up do
    create_table :accounts_channels do
      column :id, Integer, :serial => true
      column :account_id, Integer
      column :channel_id, Integer
    end
  end

  down do
    drop_table :accounts_channels
  end
end
