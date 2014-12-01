class FocusAreaSerializer < ActiveModel::Serializer
	attributes :id, :name
	attributes :ten_year_goals, :three_year_goals, :one_year_goals, :three_month_goals, :one_month_goals

	def ten_year_goals
		ten_year_goals = []
		object.goals.each do |goal|
			ten_year_goals << GoalsSerializer.new(goal) if (goal.due_date.to_date > 3.years.from_now.to_date)
		end
		ten_year_goals
	end

	def three_year_goals
		three_year_goals = []
		object.goals.each do |goal|
			three_year_goals << GoalsSerializer.new(goal) if ((1.year.from_now.to_date)..(3.year.from_now.to_date)).cover?(goal.due_date.to_date)
		end
		three_year_goals
	end

	def one_year_goals
		one_year_goals = []
		object.goals.each do |goal|
			one_year_goals << GoalsSerializer.new(goal) if ((3.months.from_now.to_date)..(1.year.from_now.to_date)).cover?(goal.due_date.to_date)
		end
		one_year_goals
	end

	def three_month_goals
		three_month_goals = []
		object.goals.each do |goal|
			three_month_goals << GoalsSerializer.new(goal) if ((1.months.from_now.to_date)..(3.months.from_now.to_date)).cover?(goal.due_date.to_date)
		end
	end

	def one_month_goals
		three_month_goals = []
		object.goals.each do |goal|
			three_month_goals << GoalsSerializer.new(goal) if goal.due_date.to_date < 1.month.from_now.to_date
		end
	end
end
