namespace :lol do
	task test: [:environment] do
		Rails.logger("Working")
	end
end
