try
  <% if(@menu_template.valid?) %>

  <% if(@menu_template_group.nil?) %>

  modalWrapper      = $('.update_menu_template_no_group_form')
  modalWrapper.modal('hide')

  menuTemplateGroupWrapper = $('.menu_template_no_group_form')

  menuTemplateGroupWrapper.empty()
  menuTemplateGroupWrapper.append("<%= j render(:partial=>'menu_templates/menu_template_no_group') %>")

  <% else %>

  modalWrapper      = $('.update_menu_template_group_form')
  modalWrapper.modal('hide')

  menuTemplateGroupChanged = "<%= @menu_template_group.id %>"
  menuTemplateGroupWrapper = $('#menu_template_group_form_' + menuTemplateGroupChanged)

  menuTemplateGroupWrapper.empty()
  menuTemplateGroupWrapper.append("<%= j render(:partial=>'menu_templates/menu_template_group',locals:{:mtg => @menu_template_group}) %>")

  <% end %>

  <% end %>

catch e
  console.log "Error parsing response in menu_templates/change_inventory_items.js.coffee", e.message, _.unescape("<%= @menu_template.errors.to_json %>")