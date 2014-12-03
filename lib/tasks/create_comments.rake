namespace :create_comments do
	task call: [:environment] do
		Section.all.each do |section|
			if section.body == nil
				section.body = Faker::Lorem.paragraph(3)
			end
			if section.comments.count == 0
				rand(5).times do 
					section.comments.create(
						user: User.all.sample,
						body: Faker::Hacker.say_something_smart
						)
				end
			end
			section.save
		end
	end
end
