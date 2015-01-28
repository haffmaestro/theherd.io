class SimpleUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :full_name

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end
