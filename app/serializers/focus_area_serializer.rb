class FocusAreaSerializer < ActiveModel::Serializer
	attributes :id, :name, :href

	has_many :ten_year_goals
	has_many :three_year_goals
	has_many :one_year_goals
	has_many :three_month_goals
	has_many :one_month_goals

	def href
		"##{name.downcase}"
	end

	def ten_year_goals
		goals = []
		object.goals.each do |goal|
			goals << goal if (goal.due_date.to_date > 3.years.from_now.to_date)
		end
		goals
	end

	def three_year_goals
		three_year_goals = []
		object.goals.each do |goal|
			three_year_goals << goal if ((1.year.from_now.to_date)..(3.year.from_now.to_date)).cover?(goal.due_date.to_date)
		end
		three_year_goals
	end

	def one_year_goals
		one_year_goals = []
		object.goals.each do |goal|
			one_year_goals << goal if ((3.months.from_now.to_date)..(1.year.from_now.to_date)).cover?(goal.due_date.to_date)
		end
		one_year_goals
	end

	def three_month_goals
		three_month_goals = []
		object.goals.each do |goal|
			three_month_goals << goal if ((1.month.from_now.to_date)..(3.months.from_now.to_date)).cover?(goal.due_date.to_date)
		end
		three_month_goals
	end

	def one_month_goals
		one_month_goals = []
		object.goals.each do |goal|
			one_month_goals << goal if (goal.due_date.to_date <= 1.month.from_now.to_date)
		end
		one_month_goals
	end
end
