$ ->
  if ( typeof($('#percentage').val()) != 'undefined' )
      is_primary_button = $('#percentage').attr('class').match(/btn\-primary/);

      if ( is_primary_button instanceof Array ) 
        $('#cap_options_for_percentage').show();
      else 
        $('#cap_options_for_percentage').hide();

  if ( typeof ($('#subsidy_fixed_amount').val()) != 'undefined' )
      is_fixed_amount_primary_button = $('#subsidy_fixed_amount').attr('class').match(/btn\-primary/);
      if ( is_fixed_amount_primary_button instanceof Array ) 
         $('#subsidy_fixed_amount_option').show();
      else
        $('#subsidy_fixed_amount_option').hide();

  if ($("#select_event_schedule_is_subsidy_percentage_capped_true").is(':checked'))
      $("#subsidy_percentage_fixed_amount_cap_span").show();
  else 
      $("#subsidy_percentage_fixed_amount_cap_span").hide();

  if ($("#select_event_is_subsidy_percentage_capped_true").is(':checked'))
      $("#subsidy_percentage_fixed_amount_cap_span").show();
  else 
      $("#subsidy_percentage_fixed_amount_cap_span").hide();


