require 'sinatra'
require 'json'

require_relative './my_user_model'

set('views', './views')

#enable :clear;
enable :sessions
set :port, 8080
set :bind, '0.0.0.0'

get '/' do 
    erb :index
end

#Show all existing users *
get '/users' do
  User.all.map do |row|
    row.to_hash.to_json
  end
end

#create a new user (no redundance of email, ie one email for one user) *
post '/users' do 
    User.creat(params)
    "User successfully created"
end  

#change the password of the sign-in user *
put '/users' do 
    if session[:user_id]
        User.update($user.id,:password,params['password'])
        "SUCCESSFUL UPDATE"
    else
        "UNAUTORISED"
    end
end

#delete en existing *
delete '/users' do 
    if session[:user_id]
        User.destroy($user.id)
        "User deleted"
    else
        "UNAUTHORISED"
    end
end 

#Creat a session for a user *
post '/sign-in' do 
    p User.all
    params['email']
    params['password']
    users=User.all
    $user= users.filter { |user| user.email==params['email'] && user.password== params['password']}.first 
    if $user
        session[:user_id]=$user.id 
        "signed in"
    else
        "unauthorised"
    end
end

#exit a session
delete '/sign-out' do
    session[:user_id]=nil
    "logged-out"
end 