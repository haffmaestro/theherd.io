                  Prefix Verb     URI Pattern                            Controller#Action
        new_user_session GET      /users/sign_in(.:format)               devise/sessions#new
            user_session POST     /users/sign_in(.:format)               devise/sessions#create
    destroy_user_session DELETE   /users/sign_out(.:format)              devise/sessions#destroy
 user_omniauth_authorize GET|POST /users/auth/:provider(.:format)        devise/omniauth_callbacks#passthru {:provider=>/(?!)/}
  user_omniauth_callback GET|POST /users/auth/:action/callback(.:format) devise/omniauth_callbacks#:action
           user_password POST     /users/password(.:format)              devise/passwords#create
       new_user_password GET      /users/password/new(.:format)          devise/passwords#new
      edit_user_password GET      /users/password/edit(.:format)         devise/passwords#edit
                         PATCH    /users/password(.:format)              devise/passwords#update
                         PUT      /users/password(.:format)              devise/passwords#update
cancel_user_registration GET      /users/cancel(.:format)                registrations#cancel
       user_registration POST     /users(.:format)                       registrations#create
   new_user_registration GET      /users/sign_up(.:format)               registrations#new
  edit_user_registration GET      /users/edit(.:format)                  registrations#edit
                         PATCH    /users(.:format)                       registrations#update
                         PUT      /users(.:format)                       registrations#update
                         DELETE   /users(.:format)                       registrations#destroy
                   herds GET      /herds(.:format)                       herds#index
               edit_herd GET      /herds/:id/edit(.:format)              herds#edit
                    herd GET      /herds/:id(.:format)                   herds#show
                         PATCH    /herds/:id(.:format)                   herds#update
                         PUT      /herds/:id(.:format)                   herds#update
                         DELETE   /herds/:id(.:format)                   herds#destroy
            weekly_index GET      /herd_weeklies(.:format)               herd_weeklies#index
                         POST     /herd_weeklies(.:format)               herd_weeklies#create
              new_weekly GET      /herd_weeklies/new(.:format)           herd_weeklies#new
             edit_weekly GET      /herd_weeklies/:id/edit(.:format)      herd_weeklies#edit
                  weekly GET      /herd_weeklies/:id(.:format)           herd_weeklies#show
                         PATCH    /herd_weeklies/:id(.:format)           herd_weeklies#update
                         PUT      /herd_weeklies/:id(.:format)           herd_weeklies#update
                         DELETE   /herd_weeklies/:id(.:format)           herd_weeklies#destroy
                   goals GET      /goals(.:format)                       goals#index
                         POST     /goals(.:format)                       goals#create
                new_goal GET      /goals/new(.:format)                   goals#new
               edit_goal GET      /goals/:id/edit(.:format)              goals#edit
                    goal GET      /goals/:id(.:format)                   goals#show
                         PATCH    /goals/:id(.:format)                   goals#update
                         PUT      /goals/:id(.:format)                   goals#update
                         DELETE   /goals/:id(.:format)                   goals#destroy
                         GET      /                                      herds#show
                  invite GET      /invite(.:format)                      herds#invite_friends
                    join GET      /join(.:format)                        redirect(301, /users/sign_up)
       api_herd_weeklies GET      /api/herd_weeklies(.:format)           api/herd_weeklies#index
                         POST     /api/herd_weeklies(.:format)           api/herd_weeklies#create
     new_api_herd_weekly GET      /api/herd_weeklies/new(.:format)       api/herd_weeklies#new
    edit_api_herd_weekly GET      /api/herd_weeklies/:id/edit(.:format)  api/herd_weeklies#edit
         api_herd_weekly GET      /api/herd_weeklies/:id(.:format)       api/herd_weeklies#show
                         PATCH    /api/herd_weeklies/:id(.:format)       api/herd_weeklies#update
                         PUT      /api/herd_weeklies/:id(.:format)       api/herd_weeklies#update
                         DELETE   /api/herd_weeklies/:id(.:format)       api/herd_weeklies#destroy
        api_weekly_tasks POST     /api/weekly_tasks(.:format)            api/weekly_tasks#create
         api_weekly_task PATCH    /api/weekly_tasks/:id(.:format)        api/weekly_tasks#update
                         PUT      /api/weekly_tasks/:id(.:format)        api/weekly_tasks#update
                new_herd GET      /new(.:format)                         herds#new
                         POST     /herds(.:format)                       herds#create
                    root GET      /                                      onboarding#index
