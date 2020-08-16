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

##############################################################################
# Finding the Event Type ID for Politics

#making a filter for just Politics
politics_filter = bfl.filters.market_filter(event_type_ids=[2378961])
#politicsfilter = bfl.filters.market_filter(competition_ids=[10393583])

filter2 = bfl.filters.market_filter(event_ids = [28009878])

# Returns a list using the filter
state_markets = trading.betting.list_market_catalogue(
        filter=filter2,
        max_results='100'
        )

TEST_INDEX = 0

print(state_markets[TEST_INDEX].market_name)
print(state_markets[TEST_INDEX].market_id)

state_market_ids = [market.market_id for market in state_markets]

state_market_books = trading.betting.list_market_book(
        market_ids=state_market_ids
        )

print(state_market_books[TEST_INDEX].market_id)

df2 = ls.process_runner_books(state_market_books[TEST_INDEX].runners)

print(df2)

#this seems not to work because the 'ex' property of the market books is a None
#suggest going back to the example and looking up how to apply PRICE FILTERS

