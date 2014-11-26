module SegmentIO

  def self.user_account_information_for_segment_io current_user
    # In case
    return unless current_user

    user_account = Hash.new 
    user_account["email"] = current_user.email
    user_account["username"] = current_user.name
    
    # The company and role for the user, if any:
    # In the format such as: “account_roles”: [“Groupon: member”, "PPM America: administrator”] 
    user_account["account_roles"] = Array.new
    current_user.try(:account_roles).map { |x| user_account["account_roles"] <<  x.account.name + ": " + x.role }

    user_account 
  end

  def self.identify_traits current_user
    # In case
    return unless current_user
    
    user_account = Hash.new
    user_account["email"] = current_user.email
    user_account["name"] = current_user.first_name + " " + current_user.last_name 
    user_account["account_roles"] = Array.new
    current_user.try(:account_roles).map { |x| user_account["account_roles"] <<  x.account.name + ": " + x.role }

    user_account
  end 

end  
