# -*- coding: utf-8 -*-
"""
Created on Sun Aug 16 12:56:55 2020

@author: sealo
"""

import loginscript as ls
import functions as fn
import pandas as pd
import datetime
import betfairlightweight as bfl
from betfairlightweight import filters


trading = ls.trading

##############################################################################
# Finding the Event Type ID for Politics

#making a filter for just Politics
#the event type id for Politics is 2378961
#the event id for USA - Presidential Election State Betting is 29959405
# the event id for USA - Presidential Election 2020 is 28009878
politics_filter = bfl.filters.market_filter(event_type_ids=[2378961])
state_filter = bfl.filters.market_filter(event_ids = [29959405])

# Returns a list of market_catalogue objects using the filter
state_markets = trading.betting.list_market_catalogue(
        filter=state_filter,
        max_results='100'
        )
#
#TEST_INDEX = 1
#
#print(state_markets[TEST_INDEX].market_name)
#print(state_markets[TEST_INDEX].market_id)

state_market_lookup = [(market.market_id,market.market_name) for market in state_markets]
state_market_lookup = pd.DataFrame(state_market_lookup,columns=["ID","Name"])


state_market_ids = list(state_market_lookup["ID"])

####
price_filter = bfl.filters.price_projection(
    price_data=['EX_BEST_OFFERS']
)

df = pd.DataFrame()
for n in range(5):
    state_market_books = trading.betting.list_market_book(
            market_ids=state_market_ids[n*10:n*10+10],
            price_projection=price_filter
            )
    for market_book in state_market_books:
        tempdf = fn.process_runner_books(market_book.runners)
        
        tempdf['Market Name'] = state_market_lookup[state_market_lookup["ID"]==market_book.market_id]["Name"].sum()
        df = df.append(tempdf)
####

#    
#for market_id in state_market_ids:
#    state_market_book = trading.betting.list_market_book(
#            market_ids=[market_id],
#            price_projection=price_filter
#            )
#    tempdf = fn.process_runner_books(state_market_book[0].runners)
#    df = df.append(tempdf)

####
print(df)
####

#the result of list_market_catalogue contains a list that is the runner_catalogue

#this seems to work but runs very slowly
#next steps:
#work out a way to process runner books without using a df until the end
#work out how many market ids can be passed to list_market_book so it can be done in batches
#need to correctly label the runners and the markets
