task make_goals: [:environment] do
	Herd.all.each do |herd|
		herd.users.each do |user|
			user.focus_areas.each do |focus_areas|
				3.times do
					focus_areas.goals.create(
						body: Faker::Lorem.paragraph(1),
						due_date: 1.month.from_now
						)
				end
				2.times do
					focus_areas.goals.create(
						body: Faker::Lorem.paragraph(1),
						due_date: 3.months.from_now
						)
				end
				3.times do
					focus_areas.goals.create(
						body: Faker::Lorem.paragraph(1),
						due_date: 1.year.from_now
						)
				end
				2.times do
					focus_areas.goals.create(
						body: Faker::Lorem.paragraph(1),
						due_date: 3.years.from_now)
				end
				focus_areas.goals.create(
					body: Faker::Lorem.paragraph(1),
					due_date: 10.years.from_now)
			end
		end

	end
end