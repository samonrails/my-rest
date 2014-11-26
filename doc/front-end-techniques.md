### Modal Popups

Sometimes you may want to include a form on a page, and have it display in a modal
popup when a user clicks a button.

Adding the classes 'modal' and 'hide' to an element, will allow that element
to act as a modal popup, and ensure that it isn't displayed until called upon.

```haml
.new-vendor-form.modal.hide.fade
  = render :partial => "vendors/partials/new"
```

#### Creating a modal display button

Adding a class of 'toggle-modal' with a "data-target" attribute that points
to a css selector will create a button that displays a modal window when clicked.

Notice the data-target attribute points to the modal element created above.

```haml
.controls.pull-right
  %a.btn.btn-small.btn-success.toggle-modal{"data-target"=>".new-vendor-form"}
    %i.icon.icon-plus-sign.icon-white
    Add New Vendor
```

### AJAX Form Actions

On forms which have the `remote: true` set, or links which have the `data-remote` attribute
set to true, Rails will use the unobtrusive javascript methods to make AJAX interactions simpler.

The Controller actions merely need to respond to the 'js' format, and by including
a view with the `js.coffee` extension, will run the javascript in response to the
AJAX call.

For example, the process of creating a new vendor utilizes the `remote:true` object for configuring the form:

```haml
- @vendor ||= Vendor.new

.modal-wrapper
  = simple_form_for @vendor, remote: true  do |f|
    .modal-header
      %button.close{:type=>"button","data-dismiss"=>"modal"}
        &times;

      %h3 Add New Vendor

    .modal-body
      = f.input :name
      = f.input :legal_name
      = f.input :description
      = f.input :cuisine_list, label: "Cuisines (primary first)"
      = f.input :website

    .modal-footer
      = f.submit(:class => "btn btn-primary")
```

The controller action which handles it is simple:

```ruby
class VendorsController < ApplicationController
  def create
    @vendor = Vendor.create(permitted_params.vendor)
    respond_with(@vendor)
  end
end
```

respond with encompasses common patterns for responding to HTML and JS requests.  It will
render the view whose name matches the controller action.  In this case `app/views/vendors/create.js.coffee`

```coffeescript
modalWrapper      = $('.new-vendor-form')
tableBody         = $('.vendors.results table tbody')
vendorForm        = $('.new-vendor-form form')

try
  <% if(@vendor.valid?) %>

  modalWrapper.modal('hide')
  Application.successMessage tableBody.parents('.results')

  tableBody.prepend("<%= j render(:partial=>'vendors/partials/table_row',locals:{:vendor=>@vendor}) %>")

  # clear the form so it can be used again
  Application.forms.clear(vendorForm)

  <% else %>
  Application.displayModelErrors("<%= @vendor.errors.to_json %>", model:"vendor").onForm(vendorForm)
  <% end %>

catch e
  console.log "Error parsing response in vendors/create.js.coffee", e.message, _.unescape("<%= @vendor.errors.to_json %>")
```

Notice the use of erb tags.  This can be a little confusing, since the erb tag is not present in the filename.  It is available by default for JS views.

However, what happens is this snippet of javascript gets evaluated in the context of the page.  A couple areas to note:

1) The use of Application javascript methods.  These files are defined in the `app/assets/javascripts/helpers` folder and are generic helpers to handle common scenarios.
2) The `<%= j render(...) %>` call which renders a snippet of HTML from a partial, escapes the content for use in javascript, and then appends the content to the given DOM selector using jQuery.

### Handling DELETE requests with AJAX

The `app/views/vendors/index.html.haml` file has another interesting method.

```haml
%a.btn.btn-danger{:href=>vendor_path(vendor), "data-remote"=>true, "data-method"=>"delete", :rel=>"nofollow", "data-confirm"=>"Are you sure?"}
```

Notice:
- data-remote attribute set to true
- data-method attribute set to delete
- data-confirm attribute set to 'Are you sure?'

This ends up calling the `VendorsController#destroy` action which renders the `app/views/vendors/destroy.js.coffee` file, similar to the create action above.  Notice the consistency of the naming convention.

Upon success, this view gets rendered, and the code gets evaluated.  This results in the row being removed from the table on the page.
