class ActivitiesSerializer < ActiveModel::Serializer
  attributes :id, :trackable_type, :key, :owner, :recipient, :created_at, :updated_at, :target, :text

  def owner
    user = User.find(object.owner_id)
    SimpleUserSerializer.new(user, root: false)
  end

  def recipient
    if object.recipient_id
      user = User.find(object.recipient_id)
      return SimpleUserSerializer.new(user, root: false)
    end
    return nil
  end

  def target
    begin
      target = object.trackable_type.classify.constantize.find(object.trackable_id)
    rescue Exception=>e
      target = nil
    end
    if target
      if object.trackable_type == "Goal"
        return ExtendedGoalSerializer.new(target, root: false)
      elsif object.trackable_type == "UserWeekly"
        return SimpleUserWeeklySerializer.new(target, root: false)
      else
        return "#{object.trackable_type}Serializer".classify.constantize.new(target, root: false)
      end
    else
      return nil
    end
  end


end
