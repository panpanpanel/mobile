//
//  EnergyMeasurements.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-22.
//

import SwiftUI
import AWSDynamoDB
import AWSIoT

public protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
  public var description: String {
    let mirror = Mirror(reflecting: self)
    
    var str = "\(mirror.subjectType)("
    var first = true
    for (label, value) in mirror.children {
      if let label = label {
        if first {
          first = false
        } else {
          str += ", "
        }
        str += label
        str += ": "
        str += "\(value)"
      }
    }
    str += ")"
    
    return str
  }
}

class BreakerData: ReflectedStringConvertible {
    let current: Double
    let breaker: Int
    let powerFactor: Double?
    let adjustedCurrent: Double
    
    init(cur: Double, pF: Double?, breaker: Int) {
        self.current = cur
        self.powerFactor = pF
        self.breaker = breaker
        self.adjustedCurrent = self.current * (pF ?? 1.0)
    }
}

struct PanelState: ReflectedStringConvertible {
    let breakerData: [BreakerData]
    let voltage: Double
    let totalEnergy: Double // in kW
    let timestamp: Date
    
    init() {
        self.breakerData = []
        self.voltage = 120
        self.totalEnergy = 0.0
        self.timestamp = Date.now
    }
    
    init(breakers: [BreakerData], volt: Double, time: Double) {
        self.timestamp = Date(timeIntervalSince1970: time)
        self.breakerData = breakers
        self.voltage = volt
        var sumAdjustedCurrent: Double = breakers[0].current
//        for breaker in breakers {
//            sumAdjustedCurrent += breaker.adjustedCurrent
//        }
        self.totalEnergy = self.voltage * sumAdjustedCurrent / 1000.0
    }
    init(breakers: [BreakerData], volt: Double, time: Date) {
        self.timestamp = time
        self.breakerData = breakers
        self.voltage = volt
        var sumAdjustedCurrent: Double = breakers[0].current
//        for breaker in breakers {
//            sumAdjustedCurrent += breaker.adjustedCurrent
//        }
        self.totalEnergy = self.voltage * sumAdjustedCurrent / 1000.0
    }
}

class EnergyMeasurements: ObservableObject {
    @Published var data: [PanelState]
    @Published var hasLoaded: Bool
    @Published var newData: Bool
    @Published var queuedData: [PanelState]
    @Published var hourData: [Double]
    
    init() {
        self.data = []
        self.hasLoaded = false
        self.queuedData = []
        self.hourData = []
        self.newData = false
    }
    
    
    private func addDataToQueue(payload: Data) {
        let payloadDictionary = jsonDataToDict(jsonData: payload)
//        print("Message received: \(payloadDictionary)")
        guard let sys_dict = payloadDictionary as? [String:Any],
           let breaker_0 = sys_dict["breaker_0_current"] as? Double,
           let breaker_1 = sys_dict["breaker_1_current"] as? Double,
           let breaker_2 = sys_dict["breaker_2_current"] as? Double,
           let breaker_3 = sys_dict["breaker_3_current"] as? Double,
           let breaker_4 = sys_dict["breaker_4_current"] as? Double,
           let breaker_5 = sys_dict["breaker_5_current"] as? Double,
           let breaker_6 = sys_dict["breaker_6_current"] as? Double,
           let breaker_7 = sys_dict["breaker_7_current"] as? Double,
           let voltage = sys_dict["voltage"] as? Double
         else {
             print("Data not formatted, next entry")
             return
         } // end else after guard
 //                            print("made it thru")
         //TODO: Make for loop later, with logic above as well
         let breaker0 = BreakerData(cur: breaker_0, pF: nil, breaker: 0)
         let breaker1 = BreakerData(cur: breaker_1, pF: nil, breaker: 1)
         let breaker2 = BreakerData(cur: breaker_2, pF: nil, breaker: 2)
         let breaker3 = BreakerData(cur: breaker_3, pF: nil, breaker: 3)
         let breaker4 = BreakerData(cur: breaker_4, pF: nil, breaker: 4)
         let breaker5 = BreakerData(cur: breaker_5, pF: nil, breaker: 5)
         let breaker6 = BreakerData(cur: breaker_6, pF: nil, breaker: 6)
         let breaker7 = BreakerData(cur: breaker_7, pF: nil, breaker: 7)
         let breakerArr = [breaker0, breaker1, breaker2, breaker3, breaker4, breaker5, breaker6, breaker7]
         let timeDouble = Date()
         let panState = PanelState(breakers: breakerArr, volt: Double(voltage), time: timeDouble)
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.toggle()
            // ^ this may work to refresh every other update
            self.data.insert(panState, at: 0)
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            formatter.dateStyle = .short
            let energy = round(100000.0*self.data[0].totalEnergy)/100000.0
            
            print("Data Added \tEnergy: \(energy)\tTime: \(formatter.string(from: self.data[0].timestamp))")
//            print("Added Data into self \(self.data[0])")
        }
    }
    
    func toggle() {
        self.newData = !self.newData
    }
    
    func getTotalWH(dateEnd: Date) -> Double {
        let dateStart = Calendar.current.date(byAdding: .hour, value: -1, to: dateEnd)!
        
        let hourlyEnergy = self.getEnergyData(beginningTime: dateStart, endTime: dateEnd, binType: .minute, binSize: 5)
        var returnEnergy = 0.0
        hourlyEnergy.forEach { item in
            returnEnergy += item
        }
//        print("Total WH \(returnEnergy/12.0)")
        return returnEnergy/12.0
    }
    
    func registerSubscriptions() {
        let topicArray = ["measure/basic", "control/basic"]
        let dataManager = AWSIoTDataManager(forKey: "kDataManager")
        
        for topic in topicArray {
            print("Registering subscription to => \(topic)")
            dataManager.subscribe(toTopic: topic,
                                  qoS: .messageDeliveryAttemptedAtLeastOnce,  // Set according to use case
                                  messageCallback: addDataToQueue)
        }
    }
    
   func addPanelState() -> [PanelState] {
       let panArray = self.queuedData
       self.queuedData = []
       return panArray
    }
    
    func printEnergyArr(printNum: Int) {
//        let formatter = DateFormatter()
//
//        formatter.timeStyle = .full
//        formatter.dateStyle = .full
        print("Printing the first \(printNum) states of \(self.data.count) total size:\n")
        for i in 0...(printNum - 1) {
            print("\(self.data[i])\n")
        }
    }
    
    func getEnergyData(beginningTime: Date, endTime: Date, binType: Calendar.Component, binSize: Int) -> [Double] {
        var energyArray: [Double] = []
        
        var bucket_num = 1
        guard var index = self.data.firstIndex(where: { panState in
            panState.timestamp <= endTime
        }) else {
            print("Couldn't find data")
            return energyArray
        }
        var binEnergy: Double = 0
        var countElements: Double = 0
        
        var indexContained: Bool = self.data.indices.contains(index)
        var dataPointTime = self.data[index].timestamp
        var lowerBound = Calendar.current.date(byAdding: binType, value: -binSize*bucket_num, to: endTime)
        
//        print("EndTime = \(endTime), BeginningTime = \(beginningTime)")
        
        while(indexContained && beginningTime <= dataPointTime) {
            if(dataPointTime >= lowerBound!){
                binEnergy += self.data[index].totalEnergy
                countElements += 1
            } else {
                if(countElements == 0) {
                    energyArray.append(0.0)
                } else {
                    energyArray.append(binEnergy/countElements)
                }
                bucket_num+=1
                lowerBound = Calendar.current.date(byAdding: binType, value: -binSize*bucket_num, to: endTime)
                countElements = 0
                binEnergy = 0
                index -= 1
            }
            index+=1
            indexContained = self.data.indices.contains(index)
            if indexContained {
                dataPointTime = self.data[index].timestamp
            }
        }
        return energyArray
    }
}
