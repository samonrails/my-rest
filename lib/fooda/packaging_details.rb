class PackagingDetails

  def self.available_values
    [self.buffet_style, self.individually_packaged]
  end

  def self.buffet_style
    "Family Style"
  end

  def self.individually_packaged
    "Individually Packaged"
  end
end
