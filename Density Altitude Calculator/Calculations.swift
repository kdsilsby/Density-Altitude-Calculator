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

//General rounding function to round to specified amount. Currently for formatting, but could be replaced with %f formatting method later.
extension Double {
    func rounded(toPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(toPlaces))
        return (self*divisor).rounded() / divisor
    }
}

func ISADeviation (tempC: Double, elevation_ft: Int) -> Double {
    return tempC - (15 - ((Double(elevation_ft)/1000)*1.9812))
}

func dryDensityAlt(tempC: Double, elevation_ft: Int, altimeter_inHg: Double) -> Double {
    return (pressureAltitude(elevation_ft: elevation_ft, altimeter_inHg: altimeter_inHg) + 118.8 * ISADeviation(tempC: tempC, elevation_ft: elevation_ft)).rounded(toPlaces: 0)
}

//polynomial algorithm developed by Herman Wobus to determine vapor pressure Vp.
func vaporPressure(tempC: Double) {
    let e_so = 6.1078
    let c0 = 0.99999683
    let c1 = -9.0826951 * pow(10.0, -3.0)
    let c2 = 7.8736169E-05
    let c3 = -6.1117958E-07
    let c4 = 4.3884187E-09
    let c5 = -2.9883885E-11
    let c6 = 2.1874425E-13
    let c7 = -1.7892321E-15
    let c8 = 1.1112018E-17
    let c9 = -3.0994571E-20
}
