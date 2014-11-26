delete  from event_vendors
where event_id in(
  select id from events where event_schedule_id > 0
);

delete  from events
where event_schedule_id > 0;

update event_schedules set processed_until = null;
