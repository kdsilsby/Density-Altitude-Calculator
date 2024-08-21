//
//  ContentView.swift
//  Density Altitude Calculator
//
//  Created by Kurt Silsby on 8/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var elevation = 0
    @State private var temperature = 15
    @State private var altimeter = 29.92
    
    var body: some View {
        VStack {
            HStack {
                Text("Field Elevation: ")
                TextField("Field Elevation", value: $elevation, format: .number)
            }
            HStack {
                Text("Temperature: ")
                TextField("Temperature in C", value: $temperature, format: .number)
            }
            HStack {
                Text("Altimeter: ")
                TextField("Altimeter in inHG", value: $altimeter, format: .number)
            }
            HStack {
                Text("Dry Density Altitude Calculator")
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
