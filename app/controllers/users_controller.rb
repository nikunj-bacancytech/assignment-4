class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy update_status ]
  before_action :current_user

  # GET /users or /users.json
  def index
    ActionCable.server.broadcast "activity_channel", user_id: current_user.id, status: 'online'
    file = File.read(Rails.root.join('storage/online_users.json'))
    data_hash = JSON.parse(file)
    @currently_online = data_hash['users']
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    3.times { @user.addresses.build }
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_status
    params.permit :id, :active
    user_id = params[:id]
    status = (params[:active] == 'true') ? 'active' : 'inactive'
    
    user = User.find(user_id)
    user.status = status
    output = 
      if user.save
        {success: 1, message: 'Status Changed successfully!', status: user.status}.to_json
      else
        {success: 0, message: 'Error in status change', status: user.status}.to_json
      end

    render :json => output
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(
        :name, :dob, :gender, :status,
        addresses_attributes: [ :id, :address, :_destroy ]
      )
    end
end