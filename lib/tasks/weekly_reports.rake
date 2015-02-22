namespace :weekly_reports do

  desc "Generate section content"
  task bootstrap_sections: [:environment] do
    Section.all.each do |section|
      section.body = Faker::Lorem.paragraph(rand(10))
      section.save
    end
  end

  desc "Generate weekly tasks"
  task :add_tasks => [:environment] do
    Section.all.each do |section|
      rand(7).times do 
        task = section.weekly_tasks.new({body: Faker::Hacker.say_something_smart})
        task.save
      end
    end
  end
  desc "Display current HerdWeeklies"
  task :display => [:environment] do
    Herd.all.each do |herd|
      puts "#{herd.name}"
      herd.herd_weeklies.each do |weekly|
        puts "ID: #{weekly.id}, year: #{weekly.year}, week: #{weekly.week}, year_week_id: #{weekly.year_week_id}"
      end
    end
  end
end
