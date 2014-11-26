namespace :intialize do
  task first_herd_weekly: [:environment] do
    herd = Herd.last
    service = Reports.CreateHerdWeekly.new(herd: herd)
    service.call
  end
end
