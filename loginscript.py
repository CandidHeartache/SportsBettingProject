# -*- coding: utf-8 -*-
"""
Created on Sat Aug 15 12:16:05 2020

@author: Daniel
"""

# Import libraries
import betfairlightweight as bfl
from betfairlightweight import filters
import pandas as pd
import numpy as np
import os
import datetime
import json
from pathlib import Path


certs_path = "C:\\Sports betting\\Credentials\\"


filenames = ('password.txt','username.txt','app_key.txt')
my_password, my_username, my_app_key = [open(certs_path + name,'r').read() for name in filenames]

trading = bfl.APIClient(username=my_username,
                        password=my_password,
                        app_key=my_app_key,
                        certs=certs_path)

trading.login()

#


event_types = trading.betting.list_event_types()

sport_ids = pd.DataFrame({
    'Sport': [event_type_object.event_type.name for event_type_object in event_types],
    'ID': [event_type_object.event_type.id for event_type_object in event_types]
}).set_index('Sport').sort_index()

sport_ids