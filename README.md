This is meant to be a simple application that calculates density altitude by various methods. More info to be provided as things are flushed out. 

Current calculation determines density altitude be determining current pressure alitutude from current field elevation and altimeter setting. Then uses the current temperature to determine the difference between standard temperature and current temperature, and uses this difference with a standard model for air pressure to determine what equivalent altitude the air pressure would be at. This does not account for dew point, which accounts for moisture conent in the air. This will be done in future updates to the program. 

Current work in progress is vapor pressures and actual station pressure. Content has been documented in code to explain basics and sources. Still needs to be completed and cleaned up for more suitable and easy understanding. 

Primarily this is used for aviation to help determine the performance of aircraft to be realistically expected given current airfield conditions. Typical weather information pilots have access to in a METAR or TAF are temperature, altimeter setting and dew point. Field eleveation is found on sectional charts used in navigation or in airfield directories/chart supplimentals that provide basic information for mulitple airfields. 
