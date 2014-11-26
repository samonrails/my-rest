# This file will setup database constants for Snappea that are not persisted in source code. -DJB

require 'fooda/util'

Fooda::Util.create_pricing_tiers
Fooda::Util.create_line_item_types
Fooda::Util.create_ssp_persistences
Fooda::Util.create_markets
Fooda::Util.create_account
Fooda::Util.create_god_user
