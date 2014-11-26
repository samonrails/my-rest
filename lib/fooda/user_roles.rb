class UserRoles

  def self.available_values user = nil
    if user and user.role? :super_admin
      %w(super_admin fooda_employee accounting catering_foodizen foodizen)
    else
      %w(fooda_employee catering_foodizen foodizen)
    end
  end

end

