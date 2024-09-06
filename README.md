This is meant to be a simple application that calculates density altitude by various methods. More info to be provided as things are flushed out. 

First calculation determines density altitude be determining current pressure alitutude from current field elevation and altimeter setting. Then uses the current temperature to determine the difference between standard temperature and current temperature, and uses this difference with a standard model for air pressure to determine what equivalent altitude the air pressure would be at. This does not account for dew point, which accounts for moisture conent in the air. This will be done in future updates to the program. 

Second calculation uses the current NOAA method of determining density altitude. It uses station pressure and an equation derived from atmospheric phsyics to approximate a density altitude that does not account for dew point/vapor pressure.

Third calculation uses the NOAA mothod modified with a vertual temperature calcuatlion that is used to approximate what station temperature would be given a dew point measurement. This allows the NOAA method to account for dew point/vapor pressure.

Forth calcualtion uses a full air density calculation combined with geopotential and geometic altitdue relation to account for several factors in determining density altitude. 

Primarily this is used for aviation to help determine the performance of aircraft to be realistically expected given current airfield conditions. Typical weather information pilots have access to in a METAR or TAF are temperature, altimeter setting and dew point. Field eleveation is found on sectional charts used in navigation or in airfield directories/chart supplimentals that provide basic information for mulitple airfields. 

Currently this is the basic intended implementation of the program. Will continue to add more documentation and application interactions to give more guidance and better interface to use. 
