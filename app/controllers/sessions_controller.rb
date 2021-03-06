class SessionsController < ApplicationController
    def welcome
    end

    def new
    end

    def create
        @user = User.find_by(username: params[:user][:username])
        if @user && @user.authenticate(params[:user][:password])
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            flash[:message] = "Login Error, please try again."
            redirect_to login_path
        end
    end

    def destroy
        reset_session
        redirect_to '/'
    end

    def google_login #option 1
        if @user = User.find_by(email: auth["info"]["email"]) # if google user exists, team reassigning method not needed
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            @user = User.create(email: auth["info"]["email"]) do |user|
                user.username = auth[:info][:first_name]
                user.email = auth[:info][:email]
                user.password = SecureRandom.hex(10)
                user.team = Team.all.first #sets a random team for the user first (so I won't lose @user), have user change later
            end
            session[:user_id] = @user.id
            redirect_to edit_user_path(@user)
        end
    end

    # def google_login #option 2
    #     @user = User.find_or_initialize_by(email: auth["info"]["email"]) do |user|
    #         user.username = auth[:info][:first_name]
    #         user.email = auth[:info][:email]
    #         user.password = SecureRandom.hex(10)
    #         user.team ||= Team.all.first
    #     end
    #     session[:user_id] = @user.id
    #     if @user.new_record? # check if you need to .save?
    #         redirect_to(edit_user_path(@user))
    #     else
    #         redirect_to(user_path(@user))
    #     end
    # end

    # def google_login #option 3
    #     @user = User.find_or_initialize_by(email: auth["info"]["email"]) do |user|
    #         user.username = auth[:info][:first_name]
    #         user.email = auth[:info][:email]
    #         user.password = SecureRandom.hex(10)
    #     end
    #     session[:user_id] = @user.id
    #     @user.new_record? ? render(:edit_user_path(User.find_by_id(params[:id])) : redirect_to(user_path(@user))
    # end

    private
    def auth
      request.env['omniauth.auth']
    end
end