require './models/incident.rb'

class SodData

  def years_overview
    Incident.select_data_for('year')
  end

  def overview_for(dateToSearch)
    if dateToSearch.size == 1
      File.read('./date_responses/data_sample_months.json')
    else
      File.read('./date_responses/data_sample_days.json')
    end
  end
end
