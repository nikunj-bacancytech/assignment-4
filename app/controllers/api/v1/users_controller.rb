class Api::V1::UsersController < Api::V1::BaseController
	skip_before_action :verify_authenticity_token
	before_action :set_user, only: %i[ show update destroy update_status]

	def index
		@users = User.all
		render json: {success: 1, data: {users: @users}, error: {}}
	end

	def create
		@user = User.new(user_params)

		if @user.save
			render json: {success: 1, message: 'User created successfully!', data: {user: @user}}
		else
			render json: {success: 0, message: 'Error while creating user', data: {}, error: @user.errors}, status: 400
		end
	end

	def update
		if @user.update(user_params)
			render json: {success: 0, message: 'User updated successfully!', data: {user: @user}, error: {}}
		else
			render json: {success: 0, message: 'Error while updating user', error: @user.errors}, status: 400
		end
	end

	def destroy
		if @user.destroy
			render json: {success: 1, message: 'User deleted successfully!', data: {}, error: {}}
		else
			render json: {success: 0, message: 'Error while deleting user', data: {}, error: {}}, status: 400
		end
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:name, :dob, :gender, :status)
		end
end