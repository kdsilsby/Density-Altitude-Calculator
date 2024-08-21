//
//  Calculations.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

import Foundation


//Uses the NOAA calculation equation: h_alt = (1-(P_sta/1013.25)^0.190284)*145366.45 where P_sta is station pressure in millibars. Equation bellow accounts for the use in inHg and is multiplied by the conversion rate to mb which is 1 inHg to 33.8639 mb
func pressureAltitude(elevation_ft: Int, altimeter_inHg: Double) -> Double {
    return ((1 - pow((altimeter_inHg * 33.8639) / 1013.25, 0.190284)) * 145366.45) + Double(elevation_ft)
}


func ISADeviation (tempC: Double, elevation_ft: Int) -> Double {
    return tempC - (15 - ((Double(elevation_ft)/1000)*1.9812))
}

func dryDensityAlt(tempC: Double, elevation_ft: Int, altimeter_inHg: Double) -> Double {
    return pressureAltitude(elevation_ft: elevation_ft, altimeter_inHg: altimeter_inHg) + 118.8 * ISADeviation(tempC: tempC, elevation_ft: elevation_ft)
}
