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
                         GET      /                                      herds#show
                  invite GET      /invite(.:format)                      herds#invite_friends
                    join GET      /join(.:format)                        redirect(301, /users/sign_up)
                new_herd GET      /new(.:format)                         herds#new
                         POST     /herds(.:format)                       herds#create
                    root GET      /                                      welcome#index
