# -*- coding: utf-8 -*-
"""
Created on Sun Aug 16 12:56:55 2020

@author: sealo
"""

import loginscript as ls
import pandas as pd

import datetime

import betfairlightweight as bfl
from betfairlightweight import filters


trading = ls.trading

#### Grabbing all the event type ids

event_types = trading.betting.list_event_types()

sport_ids = pd.DataFrame({
    'Sport': [event_type_object.event_type.name for event_type_object in event_types],
    'ID': [event_type_object.event_type.id for event_type_object in event_types]
}).set_index('Sport').sort_index()
##############################################################################
# Finding the Event Type ID for Politics

#making a filter for just Politics
politics_filter = bfl.filters.market_filter(text_query='Politics')

# Returns a list using the filter
politics_event_type = trading.betting.list_event_types(filter=politics_filter)

# return first element in list
politics_event_type = politics_event_type[0]

politics_event_type_id = politics_event_type.event_type.id
print(f"the event type id for Politics is {politics_event_type_id}")



#############################################################################
# Seems to be defining a time variable then asking for the at datetime_in_a_week
datetime_in_a_week = (datetime.datetime.utcnow() + datetime.timedelta(weeks=1)).strftime("%Y-%m-%dT%TZ")
# creating a competition filter
competition_filter = bfl.filters.market_filter(
    event_type_ids=[politics_event_type_id],
#    event_type_ids=[2378961],
#    market_start_time={
#        'to':datetime_in_a_week}
    )

#get a list of competitions for Politics
competition = trading.betting.list_competitions(
    filter=competition_filter)

#for comp in competition:
#    print(comp.competition.name + comp.competition.id)
    
    
#create a filter on the competition ID (or name?) for 2020 US Presidential Election
politics_filter = bfl.filters.market_filter(
        event_type_ids=[2378961],
        )


#get a list of all events that come back under this filter as objects
US_elec_events = trading.betting.list_events(
        filter=politics_filter,
        )

#create a DF with all the events by iterating over each event object    
politics_event_names = pd.DataFrame({
        'Event Name': [event_object.event.name for event_object in US_elec_events],
        'Event ID': [event_object.event.id for event_object in US_elec_events],
        })

print(politics_event_names)







