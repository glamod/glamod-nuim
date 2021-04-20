# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 15:06:58 2019

@author: snoone
"""

import datetime
basedate="1"
formatfrom="%H"
formatto=" %H GMT"
print (datetime.datetime.strptime(basedate,formatfrom).strftime(formatto))


from datetime import datetime
from pytz import timezone

date_str = "10"
datetime_obj_naive = datetime.strptime(date_str, "%H")

datetime_obj_pacific = timezone('US/Pacific').localize(datetime_obj_naive)
print (datetime_obj_pacific.strftime("%H"))