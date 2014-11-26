module AccountsHelper

  def account_contacts
    @account.contacts.with_deleted.sort_by{|c| c.name}
  end

  def event_schedule_and_select_event_schedule account
  	event_schedules =  account.event_schedules
  	select_event_schedules = account.select_event_schedules

  	all_events = event_schedules + select_event_schedules
  	all_events.sort_by{ |e| e.active_friendly_string }
  end
    
  def tab_selected?(tab, style)
    selected = params.has_key?(:selected) && params[:selected] == tab
    return "active" if style == :active && selected
    return "display: none;" if style == :visibility && !selected
  end

  def account_tabs
    %w(events event_schedules finance pricing_tiers contacts locations preferences membership issues reviews)
  end

  def account_tab_name(tab)
    tab.gsub('_', ' ').split.map(&:capitalize).join(" ")
  end

end
