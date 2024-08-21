//
//  ContentView.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

//Default US aviation units for weather are celsius (C), inches of mercury (inHg) and feet (ft). Rest of the world commonly uses celsius, hecto pascals (hPa) and meters (m). Common unit of temperature measurement in the US otherwise is fahrenheit (F) which can be an extra option since some old manuals have values in F instead of C for performance calculations. 

import SwiftUI

struct ContentView: View {
    @State private var elevation = 0
    @State private var temperature = 15
    @State private var altimeter = 29.92
    
    var body: some View {
        VStack {
            HStack {
                //Currently default altitude will be in feet. Add options later for meters
                Text("Field Elevation: ")
                TextField("Field Elevation in Feet", value: $elevation, format: .number)
                    .padding(.leading)
                Text("Feet")
                    .padding(.trailing)
            }
            HStack {
                //Currently default temperature will be celsius. Will add option for fahrenheit.
                Text("Temperature: ")
                TextField("Temperature in C", value: $temperature, format: .number)
                    .padding(.leading)
                Text("Celsius")
                    .padding(.trailing)
            }
            HStack {
                //Current default altimeter units are inHg. Will add option for hPa
                Text("Altimeter: ")
                TextField("Altimeter in inHG", value: $altimeter, format: .number)
                    .padding(.leading)
                Text("inHg")
                    .padding(.trailing)
            }
            HStack {
                Text("Dry Density Altitude: ")
                //String(dryDensityAlt(tempC: $temperature, elevation_ft: $elevation, altimeter_inHg: $altimeter))
                Text("Ft")
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
