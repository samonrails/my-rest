module IssuesHelper

  def show_priority(priority)
    label_class = case priority
      when "High"
        "label label-important"
      when "Normal"
        "label label-warning"
      when "Low"
        "label label-success"
      else
        "label"
    end
    content_tag :span, priority, class: label_class
  end

end
