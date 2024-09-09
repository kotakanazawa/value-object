class Address
  attr_reader :prefecture, :city, :street, :postal_code

  def initialize(prefecture, city, street, postal_code)
    @prefecture = prefecture
    @city = city
    @street = street
    @postal_code = normalize_postal_code(postal_code)
    validate!
  end

  def ==(other)
    other.is_a?(Address) &&
      other.prefecture == prefecture &&
      other.city == city &&
      other.street == street &&
      other.postal_code == postal_code
  end
  alias eql? ==

  def hash
    [prefecture, city, street, postal_code].hash
  end

  def to_s
    "〒#{postal_code} #{prefecture}#{city}#{street}"
  end

  private

  def normalize_postal_code(postal_code)
    postal_code.to_s.gsub(/\D/, '')
  end

  def validate!
    raise ArgumentError, "Invalid postal code" unless postal_code.match?(/\A\d{7}\z/)
    raise ArgumentError, "Prefecture cannot be empty" if prefecture.to_s.strip.empty?
    raise ArgumentError, "City cannot be empty" if city.to_s.strip.empty?
    raise ArgumentError, "Street cannot be empty" if street.to_s.strip.empty?
  end
end
