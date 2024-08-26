//
//  Calculations.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

import Foundation


//Uses the NOAA calculation equation: h_alt = (1-(P_sta/1013.25)^0.190284)*145366.45 where P_sta is station pressure in millibars. Equation bellow accounts for the use in inHg and is multiplied by the conversion rate to mb which is 1 inHg to 33.8639 mb
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

func ISADeviation (tempC: Double, elevation_ft: Int) -> Double {
    return tempC - (15 - ((Double(elevation_ft)/1000)*1.9812))
}

func dryDensityAlt(tempC: Double, elevation_ft: Int, altimeter_inHg: Double) -> Double {
    return (pressureAltitude(elevation_ft: elevation_ft, altimeter_inHg: altimeter_inHg) + 118.8 * ISADeviation(tempC: tempC, elevation_ft: elevation_ft)).rounded(toPlaces: 0)
}

/*
 Polynomial algorithm developed by Herman Wobus to determine vapor pressure Vp.
 e_so is the saturation vapor pressure over liquid water at 0°C, and the coefficients of the polynomial were chosen when fitting to the data values in the meteorological tables they used.
 Valid approximation for -50 to 100°C.
 Sources:
 https://wahiduddin.net/calc/density_altitude.htm
 https://wahiduddin.net/calc/refs/density_algorithms.pdf
 */
func vaporPressure(tempC: Double) -> Double {
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
    
    let p = c0 + c1 * tempC + c2 * pow(tempC, 2) + c3 * pow(tempC, 3) + c4 * pow(tempC, 4) + c5 * pow(tempC, 5) + c6 * pow(tempC, 6) + c7 * pow(tempC, 7) + c8 * pow(tempC, 8) + c9 * pow(tempC, 9)
    
    return e_so/pow(p, 8)
}
