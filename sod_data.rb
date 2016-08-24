class SodData

  def years_overview
    File.read('./date_responses/data_sample_years.json')
  end

  def overview_for(dateToSearch)
    if dateToSearch.size == 1
      File.read('./date_responses/data_sample_months.json')
    else
      File.read('./date_responses/data_sample_days.json')
    end
  end
end
