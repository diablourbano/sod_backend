Sequel.migration do
  change do
    create_table(:incidents) do
      primary_key :id
      foreign_key :country_id, :countries
      Date :date
      Integer :kills
      Integer :injuries
    end
  end
end
