# SoD - Backend
## Symphony of Dead

This is the backend for [SoD project](https://github.com/diablourbano/sod).

## requirements

- ruby > 2.3.0
- postgresql > 9.2.0

## how to

- Create the database

```
$> bundle install
$> rake db:migrations:apply
$> rake import_data:csv -f ./tasks/import.rake
$> rake import_data:country_code -f ./tasks/import.rake
```

- To run execute ```rackup```

