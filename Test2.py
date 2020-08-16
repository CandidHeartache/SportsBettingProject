# -*- coding: utf-8 -*-
"""
Created on Sun Aug 16 12:56:55 2020

@author: sealo
"""

import loginscript as ls
import pandas as pd
trading = ls.trading

event_types = trading.betting.list_event_types()

sport_ids = pd.DataFrame({
    'Sport': [event_type_object.event_type.name for event_type_object in event_types],
    'ID': [event_type_object.event_type.id for event_type_object in event_types]
}).set_index('Sport').sort_index()

sport_ids