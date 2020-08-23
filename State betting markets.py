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
        max_results='100',
        market_projection=['RUNNER_DESCRIPTION']
        )
#
#TEST_INDEX = 1
#
#print(state_markets[TEST_INDEX].market_name)
#print(state_markets[TEST_INDEX].market_id)

state_market_lookup_helper = [(market.market_id,market.market_name) for market in state_markets]
state_market_lookup = pd.DataFrame(state_market_lookup_helper,columns=["Market ID","Market Name"])

runner_lookup = pd.DataFrame()
for market in state_markets:
    tempdf_helper = [(runner.selection_id,runner.runner_name,market.market_id) for runner in market.runners]
    tempdf = pd.DataFrame(tempdf_helper,columns=["Selection ID","Runner Name","Market ID"])
    runner_lookup = runner_lookup.append(tempdf)
    

state_market_ids = list(state_market_lookup["Market ID"])

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
        tempdf["Market Name"] = state_market_lookup[state_market_lookup["Market ID"]==market_book.market_id]["Market Name"].sum()
        tempdf["Market ID"] = market_book.market_id
        df = df.append(tempdf)
####

df2 = df.merge(runner_lookup,how="left")
df2.to_csv(ls.outputs_path+"betfair_states_odds.csv",index=False)

