require 'json'
class ActivityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "activity_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    file = File.read(Rails.root.join('storage/online_users.json'))
    data_hash = JSON.parse(file)
    if (data_hash['users'].include? current_user.id)
      data_hash['users'].delete(current_user.id)
    end
    File.write(Rails.root.join('storage/online_users.json'), JSON.dump(data_hash))
    ActionCable.server.broadcast "activity_channel", user_id: current_user.id, status: 'offline'
  end

  def appear
    file = File.read(Rails.root.join('storage/online_users.json'))
    data_hash = JSON.parse(file)
    if (!data_hash['users'].include? current_user.id)
      data_hash['users'].push(current_user.id)
    end
    File.write(Rails.root.join('storage/online_users.json'), JSON.dump(data_hash))
    ActionCable.server.broadcast "activity_channel", user_id: current_user.id, status: 'online'
  end
end
