class UserGoalsController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        @usergoal = UserGoal.new
    end

    def create
        @usergoal = current_user.user_goals.build(usergoal_params)
        @usergoal.save
        redirect_to user_path(@usergoal.user) # redirect to the user page instead, users don't need to know about usergoal page
    end

    def last_updated
        @sort_last_updated = UserGoal.all.ordered_by_updated_at
    end
    
    private
        def usergoal_params
            params.require(:user_goal).permit(:goal_id, :notes)
        end
end
