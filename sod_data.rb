require './models/incident.rb'

class SodData

  def years_overview
    Incident.years_overview('year')
  end

  def overview_for(dateToSearch)
    if dateToSearch.size == 1
      Incident.year_overview('month', dateToSearch)
    else
      Incident.month_overview('day', dateToSearch)
    end
  end
end
