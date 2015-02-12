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
end
