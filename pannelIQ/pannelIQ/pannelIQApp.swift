//
//  pannelIQApp.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-01-28.
//

import SwiftUI
//import AWSIoT

@main
struct pannelIQApp: App {
    
    let IoTDataManager = AWSIoTConnect()
    let IoTClientID = getAWSClientID { clientId, error in
        connectToAWSIoT(clientId: clientId)
    }
    
    @StateObject var energyMeasurements = EnergyMeasurements()
    
    var body: some Scene {
        WindowGroup {
            AWSData()
            MainView()
                .task {
                    let AWSDynamoManager = AWSDynamoData()
                    self.energyMeasurements.data = await AWSDynamoManager?.pullDynamoTableData().data ?? []
                    self.energyMeasurements.hasLoaded = true
                    self.energyMeasurements.registerSubscriptions()
                    print("EnergyMeasurements Size \(self.energyMeasurements.data.count)")
                    if(self.energyMeasurements.data.isEmpty) {
                        let emptyPan = PanelState()
                        self.energyMeasurements.data.append(emptyPan)
                    }
                    print("Energy Measurement last item \(self.energyMeasurements.data[0])")
                }
                .environmentObject(energyMeasurements)
        }
    }
}
