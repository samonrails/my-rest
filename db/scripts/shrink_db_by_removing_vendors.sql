delete from line_items
where event_id in (
  select id from events where event_start_time > CURRENT_DATE
);

delete from documents
where event_id in (
  select id from events where event_start_time > CURRENT_DATE
);

delete from menu_level_discounts
where event_vendor_id in (
  select id from  event_vendors
  where event_id in (
    select id from events where event_start_time > CURRENT_DATE
  )
);

delete from event_vendors
where event_id in (
  select id from events where event_start_time > CURRENT_DATE
);

delete from billing_references
where event_id in (
  select id from events where event_start_time > CURRENT_DATE
);

delete from events where event_start_time > CURRENT_DATE;

delete from menu_level_discounts
where event_vendor_id in (
  select id from  event_vendors
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from event_vendors
where vendor_id in (
  select id from vendors where id > 10
);

delete from menu_level_discounts
where menu_template_id in (
  select id from  menu_templates
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from menu_template_inventory_items
where menu_template_group_id in (
  select id from menu_template_groups
  where menu_template_id in (
    select id from  menu_templates
    where vendor_id in (
      select id from vendors where id > 10
    )
  )
);


delete from menu_template_groups
where menu_template_id in (
  select id from  menu_templates
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from menu_template_inventory_items
where menu_template_id in (
  select id from  menu_templates
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from menu_templates
where vendor_id in (
  select id from vendors where id > 10
);

delete from vendor_product_types
where vendor_id in (
  select id from vendors where id > 10
);

delete from vendor_products
where vendor_id in (
  select id from vendors where id > 10
);

delete from contacts
where vendor_id in (
  select id from vendors where id > 10
);

delete from inventory_item_product_types
where inventory_item_id in (
  select id from inventory_items
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from line_items
where inventory_item_id in (
  select id from inventory_items
  where vendor_id in (
    select id from vendors where id > 10
  )
);

delete from inventory_items
where vendor_id in (
  select id from vendors where id > 10
);
delete from vendors where id > 10;


delete from billing_references
where event_id in (
  select id from events
  where id not in
        (select event_id from event_vendors)
);

delete from line_items
where event_id in (
  select id from events
  where id not in
        (select event_id from event_vendors)
);

delete from documents
where event_id in (
  select id from events
  where id not in
        (select event_id from event_vendors)
);

delete from events
where id not in(
  select event_id from event_vendors)





