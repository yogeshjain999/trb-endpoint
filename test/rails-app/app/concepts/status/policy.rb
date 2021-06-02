class Status::Policy
  def initialize(user, model)
    @user   = user
    @model  = model
  end

  def update?
    @user.id == @model.id
  end
end
