# Static Data Sources

We have defined some static data sources, for cuisines, inventory tags, dietary restrictions.  These are currently stored as text files in the
`db/lists` folder.  They are turned into an array from the `StaticData` model and can be accessed in Ruby via:

- `StaticData::Cuisines`
- `StaticData::InventoryTags`
- `StaticData::DietaryRestrictions`

On the front end, you can access these through javascript on the `Application.data` object.

These data sources are useful for creating data sources for static dropdowns, and especially tags.

### Creating Select2 Tag Fields

Check out the cuisine_list field.

```haml
  = simple_form_for(@vendor) do |f|
    .row-fluid
      .span4
        = f.input :name
        = f.input :legal_name
        = f.input :description
        = f.input :cuisine_list, label: "Cuisines (primary first)", :input_html => {class: "select2 input-large", "data-restricted"=>true,"data-tag-source"=>"Application.data.cuisines"}

```

These work agains the `Vendor` model which has an `acts_as_ordered_taggable_on :cuisines` directive.

Accomplishing this is simple enough:

- Use the `taggable_field_list` name for your input.
- Add the `select2` class to the input.
- Adding `data-tag-source` and specifying a string which points to your data source: `Application.data.cuisines` or any other array of values.
- Adding `data-restricted='true'` will prevent the user from input tags which are not in the list.
