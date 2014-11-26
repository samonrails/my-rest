class CateringOrder

  attr_accessor :zip_code
  attr_accessor :num_guests
  attr_accessor :datetime

  def initialize(zip_code, num_guests, datetime)
    @zip_code = zip_code
    @num_guests = num_guests
    @datetime = datetime
  end

end
