Sequel.migration do
  change do
    create_table(:countries) do
      primary_key :id
      String :name, null: false
      Integer :code, null: false
      String :code_name
    end
  end
end
