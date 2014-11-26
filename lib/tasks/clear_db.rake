task clear_db: [:environment] do
  Herd.all.destroy_all
  User.all.destroy_all
  Section.destroy_all
  UserWeekly.destroy_all
  HerdWeekly.destroy_all
  FocusArea.destroy_all
  Comment.destroy_all
  Goal.destroy_all
  WeeklyTask.destroy_all
end