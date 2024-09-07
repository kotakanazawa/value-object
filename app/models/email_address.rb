# app/models/email_address.rb
class EmailAddress
  attr_reader :address

  def initialize(address)
    @address = address.downcase
    raise ArgumentError, "Invalid email address" unless valid?
  end

  def valid?
    address =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

  def domain
    address.split('@').last
  end

  def ==(other)
    other.is_a?(EmailAddress) && other.address == address
  end
  alias eql? ==

  def hash
    address.hash
  end

  def to_s
    address
  end
end
