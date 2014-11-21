task clear_db: [:environment] do
  Herd.all.destroy_all
  User.all.destroy_all

end