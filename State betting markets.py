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
politicsfilter = bfl.filters.market_filter(event_type_ids=[2378961])
#politicsfilter = bfl.filters.market_filter(competition_ids=[10393583])

# Returns a list using the filter
state_markets = trading.betting.list_events(
        filter=politicsfilter,
        )

df1 = pd.DataFrame({
        'Name':[market.event.name for market in state_markets],
        'ID':[market.event.id for market in state_markets],
        })

print(df1)
