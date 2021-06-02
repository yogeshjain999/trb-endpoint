class Status < Struct.new(:id, :user, :text)
  def self.find_by(id:)
    return if id.to_i == 2
    new(id, User.find(id), "#{id} Punch")
  end

  def self.load(user:, limit:)
    limit.downto(1).map do |id|
      new(id, user, "tweet-#{id}")
    end
  end
end
