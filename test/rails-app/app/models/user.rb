class User < Struct.new(:id, :email)
  def self.find(id)
    User.new(id, "email-#{id}@gmail.com")
  end
end
