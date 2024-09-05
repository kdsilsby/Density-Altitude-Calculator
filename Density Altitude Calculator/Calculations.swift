//
//  Calculations.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

import Foundation


//Uses the NOAA calculation equation: h_alt = (1-(P_sta/1013.25)^0.190284)*145366.45 where P_sta is station pressure in millibars. Equation bellow accounts for the use in inHg and is multiplied by the conversion rate to mb which is 1 inHg to 33.8639 mb
//Source: https://www.weather.gov/media/epz/wxcalc/densityAltitude.pdf
func pressureAltitude(elevation_ft: Int, altimeter_inHg: Double) -> Double {
    let p_Sta = altimeter_inHg * 33.8639
    
    return ((1 - pow(p_Sta / 1013.25, 0.190284)) * 145366.45) + Double(elevation_ft)
}

//General rounding function to round to specified amount. Currently for formatting, but could be replaced with %f formatting method later.
extension Double {
    func rounded(toPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(toPlaces))
        return (self*divisor).rounded() / divisor
    }
}

//Deviation from standard temperature for a given altitude, station temperature - standard temperature. Standard temp is 15°C and 29.92 inHg at sea level. Standard laps rate is 1.9812°C/1000 ft (rounded result with standard laps rate of 6.5°C/km)
func ISADeviation (tempC: Double, elevation_ft: Int) -> Double {
    return tempC - (15 - ((Double(elevation_ft)/1000)*1.9812))
}

//Simple dry density altitude begins with pressure altitude corrected for temperature deviation. Laps rate for temp deviation for altitude is 118.8 ft/°C. Found typically in FAA private pilot manuals, corrected to have slightly more accurate values. 
func dryDensityAlt(tempC: Double, elevation_ft: Int, altimeter_inHg: Double) -> Double {
    return (pressureAltitude(elevation_ft: elevation_ft, altimeter_inHg: altimeter_inHg) + 118.8 * ISADeviation(tempC: tempC, elevation_ft: elevation_ft)).rounded(toPlaces: 0)
}

//Simple NOAA equation to determine density altitude but does not account for vapor pressure/dew point
func dryDensityAlt_NOAA(tempC: Double, altimeter_inHg: Double, fieldElevation: Int) -> Double {
    let stationPressure = actualStationPressure(fieldElevation: fieldElevation, altimeter_inHg: altimeter_inHg)
    let tempR = (tempC * (9 / 5) + 32) + 459.69
    return 145442.16*(1 - pow((17.326 * stationPressure) / tempR, 0.235))
}

/*
 Polynomial algorithm developed by Herman Wobus to determine vapor pressure Vp.
 
 Vp = e_so/p^8
 
 e_so is the saturation vapor pressure over liquid water at 0°C with a constant value of 6.1078, and the coefficients (i.e. cX) of the polynomial were chosen when fitting to the data values in the meteorological tables they used.
 p = c0 + c1 * dewPoint_C + c2 * dewPoint_C^2 + c3 * dewPoint_C^3 + c4 * dewPoint_C^4 + c5 * dewPoint_C^5 + c6 * dewPoint_C^6 + c7 * dewPoint_C^7 + c8 * dewPoint_C^8 + c9 * dewPoint_C^9
 dewPoint_C is dew point temperature from station information
 Valid approximation for -50 to 100°C.
 
 Result value units in millibar, mb.
 
 Sources:
 https://wahiduddin.net/calc/density_altitude.htm
 https://icoads.noaa.gov/software/other/profs
 */
func vaporPressure_Wobus(dewPoint_C: Double) -> Double {
    let e_so = 6.1078
    let c0 = 0.99999683
    let c1 = -9.0826951e-3
    let c2 = 7.8736169e-5
    let c3 = -6.1117958e-7
    let c4 = 4.3884187e-9
    let c5 = -2.9883885e-11
    let c6 = 2.1874425e-13
    let c7 = -1.7892321e-15
    let c8 = 1.1112018e-17
    let c9 = -3.0994571e-20
    
    let p = c0 + c1 * dewPoint_C + c2 * pow(dewPoint_C, 2) + c3 * pow(dewPoint_C, 3) + c4 * pow(dewPoint_C, 4) + c5 * pow(dewPoint_C, 5) + c6 * pow(dewPoint_C, 6) + c7 * pow(dewPoint_C, 7) + c8 * pow(dewPoint_C, 8) + c9 * pow(dewPoint_C, 9)
    
    return e_so/pow(p, 8)
}


/*
 Alternative curve fitting equation called "Teten's Formula" to determine vapor pressure, Vp.
 
 Vp = e_so * 10^(c1 * dewPoint_C / (c2 + dewPoint_C))

 e_so is the saturation vapor pressure over liquid water at 0°C with a constant value of 6.1078
 dewPoint_C is dew point temperature from station information
 c1 and c2 are constants
 Slightly less accurate but has good results at higher ambient temperatures.
 
 Result value units in millibar, mb
 
 Sources:
 https://wahiduddin.net/calc/density_altitude.htm
 https://icoads.noaa.gov/software/other/profs
 */
func vaporPressure_Tetens(dewPoint_C: Double) -> Double {
    let e_so = 6.1078
    let c1 = 7.5
    let c2 = 237.3
    
    let exponent = (c1 * dewPoint_C) / (c2 + dewPoint_C)
    
    return e_so * pow(10.0, exponent)
}

/*
 Actual station pressure, Pa. Determining station pressure from altimeter setting and field elevation.
 
 Pa = [AS^(L*R/g*M_d) - (L/T_0)*(P_0^(L*R/g*M_d)*H)]^(g*M_d/L*R)
 
 Can be simplified to:
 
 Pa = (AS^k1 - k2*H)^(1/k1), since L, R, g, M_d, P_0 and T_0 are all constants anyway.
 
 k1 = L*R/g*M_d ≈ 0.190263
 k2 = (L/T_0)*(P_0^(L*R/g*M_d) ≈ 8.417286e-5
 
 AS is station altimeter setting given in ATIS/AWOS report in inHg.
 L is the standard laps rate.
 R is the universal gas constant.
 g is the average gravitational constant at the surface of the Earth.
 M_d is the molar weight of dry air.
 T_0 is standard temperature at sea level
 P_0 is the standard pressure at sea level
 H is the geopotential station elevation determined from station elevation/geometric elevation (Z) and converting that based on the potential gravitational ratio between what gravity should be compared to sea level.
 H = (E*Z)/(Z+E)
 E is the average Earth radius
 
 Result values in millibar, mb.
 
 Sources:
 https://wahiduddin.net/calc/density_altitude.htm
 */
func actualStationPressure(fieldElevation: Int, altimeter_inHg: Double) -> Double {
    let earthsRadius_E = 6356766.0 //Earth radius in meters, m
    let standardISATemp_T0 = 288.15 //Standard temp at sea level in Kelvin
    let standardISAPressure_P0 = 1013.25 //Standard pressure at sea level in millibars, mb
    let universalGasConst_R = 8.314462618 // J/mol*K or (Kg*m^2)/(s^2*K*mol) since J is the same as kg*m^2/s^2
    let tempLapseRate_L = 0.0065 // K/m
    let earthGravityConst_g = 9.80665 // m/s^2
    let m_d = 0.02896968 //molecular weight of dry air. Based on nitrogen/oxygen ratio in the atmosphere. kg/mol
    let geometricFieldElevation_Z_m = Double(fieldElevation) / 3.28084 //Converting from feet to meters. 1 m = 3.28084 ft
    let geopotentialStationElevation_H = (geometricFieldElevation_Z_m * earthsRadius_E) / (geometricFieldElevation_Z_m + earthsRadius_E) //Determining geopotential altitude from geometric altituden (same as field elevations). Needs to be in  meters
    let altimeter_mb = altimeter_inHg * 33.8639 //Conversion to mb.
    let k1 = (tempLapseRate_L * universalGasConst_R) / (earthGravityConst_g * m_d) // (L*R)/(g*Md)
    let k2 = (tempLapseRate_L / standardISATemp_T0)*(pow(standardISAPressure_P0, k1)) //(L/T_0) * P_0^k1
    let altimeterSettingResult = pow(altimeter_mb, k1)
    
    return pow(altimeterSettingResult - (k2 * geopotentialStationElevation_H), 1/k1)
}
