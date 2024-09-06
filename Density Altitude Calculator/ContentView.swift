//
//  ContentView.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

//Default US aviation units for weather are celsius (C), inches of mercury (inHg) and feet (ft). Rest of the world commonly uses celsius, hecto pascals (hPa) and meters (m). Common unit of temperature measurement in the US otherwise is fahrenheit (F) which can be an extra option since some old manuals have values in F instead of C for performance calculations. 

import SwiftUI

struct ContentView: View {
    @State private var elevation: Double = 0
    @State private var temperature: Double = 15
    @State private var altimeter: Double = 29.92
    @State private var dewPoint: Double = 5.0
    
    var body: some View {
        VStack {
            HStack {
                //Currently default altitude will be in feet. Add options later for meters
                Text("Field Elevation: ")
                Spacer()
                TextField("Field Elevation in Feet", value: $elevation, format: .number)
                    .border(.secondary)
                    .frame(minWidth: 10, idealWidth: 50, maxWidth: .leastNormalMagnitude, minHeight: 10, idealHeight: 20, maxHeight: .leastNormalMagnitude, alignment: .leading)
                Text("Feet")
            }
            HStack {
                //Currently default temperature will be celsius. Will add option for fahrenheit.
                Text("Temperature: ")
                Spacer()
                TextField("Temperature in C", value: $temperature, format: .number)
                    .border(.secondary)
                    .frame(minWidth: 10, idealWidth: 50, maxWidth: .leastNormalMagnitude, minHeight: 10, idealHeight: 20, maxHeight: .leastNonzeroMagnitude, alignment: .leading)
                Text("Celsius")
            }
            HStack {
                //Current default altimeter units are inHg. Will add option for hPa
                Text("Dew Point: ")
                Spacer()
                TextField("Dew Point in C", value: $dewPoint, format: .number)
                    .border(.secondary)
                    .frame(minWidth: 10, idealWidth: 50, maxWidth: .leastNormalMagnitude, minHeight: 10, idealHeight: 20, maxHeight: .leastNonzeroMagnitude, alignment: .leading)
                Text("inHg")
            }
            HStack {
                //Current default altimeter units are inHg. Will add option for hPa
                Text("Altimeter: ")
                Spacer()
                TextField("Altimeter in inHG", value: $altimeter, format: .number)
                    .border(.secondary)
                    .frame(minWidth: 10, idealWidth: 50, maxWidth: .leastNormalMagnitude, minHeight: 10, idealHeight: 20, maxHeight: .leastNonzeroMagnitude, alignment: .leading)
                Text("inHg")
            }
            VStack {
                HStack {
                    Text("Simple Density Altitude: ")
                    Spacer()
                    Text(String(format: "%.0f", dryDensityAlt(tempC: temperature, elevation_ft: Int(elevation), altimeter_inHg: altimeter)))
                    Text("Ft")
                }
                HStack {
                    Text("NOAA Density Altitude: ")
                    Spacer()
                    Text(String(format: "%.0f", determineDensityAlt().dryDensityAlt_NOAA(tempC: temperature, altimeter_inHg: altimeter, fieldElevation: Int(elevation))))
                    Text("Ft")
                }
                HStack {
                    Text("Modified NOAA Density Altitude: ")
                    Spacer()
                    Text(String(format: "%.0f", determineDensityAlt().dryDensityAlt_NOAA_Tv_Wobus(tempC: temperature, altimeter_inHg: altimeter, dewPoint_C: dewPoint, elevation_ft: Int(elevation))))
                    Text("Ft")
                }
                HStack {
                    Text("Geometric Density Altitude: ")
                    Spacer()
                    Text(String(format: "%.0f", determineDensityAlt().geometricDensityAltitude_Wobus(tempC: temperature, altimeter_inHg: altimeter, dewPoint_C: dewPoint, elevation_ft: Int(elevation))))
                    Text("Ft")
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
