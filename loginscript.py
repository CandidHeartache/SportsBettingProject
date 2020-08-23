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

outputs_path = "C:\\Sports betting\\"
certs_path = "C:\\Sports betting\\Credentials\\"


filenames = ('password.txt','username.txt','app_key.txt')
my_password, my_username, my_app_key = [open(certs_path + name,'r').read() for name in filenames]

trading = bfl.APIClient(username=my_username,
                        password=my_password,
                        app_key=my_app_key,
                        certs=certs_path)

trading.login()

