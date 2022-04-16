//
//  AWSData.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-11.
//

import Foundation
import AWSCore
import AWSIoT
import AWSDynamoDB
import SwiftUI

struct AWSData: View {
    
    @EnvironmentObject var energyMeasurements: EnergyMeasurements
    
    var body: some View {
        Text("")
    }
}

class AWSDynamoData: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    let queryTime:String = String( Date.now.timeIntervalSince1970*1000)
    @objc var device_id: String = "0"
    @objc var timestamp: String?
//    @objc var timestampSince: String = String(Date().timeIntervalSince1970 - 3600*24)
    @objc var system_data: Dictionary<String, Any>?
    
//    @StateObject var energyMeasurements = EnergyMeasurements()
    
    
    class func dynamoDBTableName() -> String {
        return "Measurements"
    }
    
    class func hashKeyAttribute() -> String {
        return "_device_id"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "device_id" : "device_id",
            "timestamp" : "timestamp",
            "system_data" : "system_data",
        ]
    }
    
    // TRY THIS METHOD AGAIN WITH AN ESCAPING CLOSURE AND ASSIGN THE VALUE OF THE ESCAPING TO ENERGYMEASURMENT
    
    func pullDynamoTableData() async -> EnergyMeasurements {
//        @EnvironmentObject var energyMeasurements: EnergyMeasurements
        
        let timeNow = Date()
        let queryTime = Calendar.current.date(byAdding: .minute, value: -70, to: timeNow)!.timeIntervalSince1970*1000
        let queryString = String(queryTime)
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#device_id = :device_num AND #time >= :time"//"device_id = :device_num"
        queryExpression.expressionAttributeNames = [
            "#device_id":"device_id",
            "#time":"timestamp"
        ]
        queryExpression.expressionAttributeValues = [
            ":device_num":"0",
            ":time": queryString
        ]
        let energyMeasurements: EnergyMeasurements = EnergyMeasurements()
        /// Try to move out of class and declare an empty struct to use as 1st param in this call
        
        do {
            let response = try await objectMapper.query(AWSDynamoData.self, expression: queryExpression)
            print("Dynamo wrote back.....")
            if (response.items.count == 0) {
                print("... and there was no data...")
            } else {
                print("Number of items = \(response.items.count)")
                response.items.forEach { item in
                    if let sys_data = item.value(forKey: "system_data"),
                       let time = item.value(forKey: "timestamp") as? String,
                       let sys_dict = sys_data as? Dictionary<String,NSNumber>,
                       let breaker_0 = sys_dict["breaker_0_current"] as? Double,
                       let breaker_1 = sys_dict["breaker_1_current"] as? Double,
                       let breaker_2 = sys_dict["breaker_2_current"] as? Double,
                       let breaker_3 = sys_dict["breaker_3_current"] as? Double,
                       let breaker_4 = sys_dict["breaker_4_current"] as? Double,
                       let breaker_5 = sys_dict["breaker_5_current"] as? Double,
                       let breaker_6 = sys_dict["breaker_6_current"] as? Double,
                       let breaker_7 = sys_dict["breaker_7_current"] as? Double,
                       let voltage = sys_dict["voltage"] as? Double {
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
                        let timeDouble = (time as NSString).doubleValue / 1000
                        let panState = PanelState(breakers: breakerArr, volt: Double(voltage), time: timeDouble)
                        energyMeasurements.data.insert(panState, at: 0)
//                        print(energyMeasurements.data[0].timestamp)
                    }
                    else {
                        print("Data not formatted, next entry")
                    }
                }
                print("AWSDynamo EnergyMeasurements Size \(energyMeasurements.data.count)")
            }
        } catch {
            print("AWS Dynamo Error: \(error)")
        }
//        energyMeasurements.data.sort {
//            $0.timestamp > $1.timestamp
//        }
        return energyMeasurements
    }
}

/// General AWS Helpers
enum AWSType: Hashable {
    case iot, dynamodb
}

func getConfig(configType: AWSType) -> AWSServiceConfiguration {
    // Initialize the Amazon Cognito credentials provider
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
       identityPoolId:"us-east-1:ea3c14ad-4eec-473b-938f-30e6885a29ba")

    let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
    AWSServiceManager.default().defaultServiceConfiguration = configuration

    var endPoint: AWSEndpoint
    
    switch configType {
    case .iot:
        AWSIoT.register(with: configuration!, forKey: "kAWSIoT")  // Same configuration var as above
        endPoint = AWSEndpoint(urlString: "wss://a2yx07piif85pi-ats.iot.us-east-1.amazonaws.com/mqtt") // Access from AWS IoT Core --> Settings
    case .dynamodb:
        AWSDynamoDB.register(with: configuration!, forKey: "USEast1DynamoDB")
        endPoint = AWSEndpoint(urlString: "https://dynamodb.us-east-1.amazonaws.com") // Access from AWS IoT Core --> Settings
    }
    // Initialising AWS IoT And IoT DataManager
    let dataConfiguration = AWSServiceConfiguration(region: .USEast1,     // Use AWS typedef .Region
                                                    endpoint: endPoint,
                                                    credentialsProvider: credentialsProvider)  // credentials is the same var as created above
    return dataConfiguration!
}

func jsonDataToDict(jsonData: Data?) -> Dictionary <String, Any> {
        // Converts data to dictionary or nil if error
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            let convertedDict = jsonDict as! [String: Any]
            return convertedDict
        } catch {
            // Couldn't get JSON
            print(error.localizedDescription)
            return [:]
        }
}

/// IoT Connections

func AWSIoTConnect() -> AWSIoTDataManager {
    let config = getConfig(configType: .iot)
        
    AWSIoTDataManager.register(with: config, forKey: "kDataManager")

    // Access the AWSDataManager instance as follows:
    return AWSIoTDataManager(forKey: "kDataManager")
}

func getAWSClientID(completion: @escaping (_ clientId: String?,_ error: Error? ) -> Void) {
        // Depending on your scope you may still have access to the original credentials var
        let credentials = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId: "us-east-1:ea3c14ad-4eec-473b-938f-30e6885a29ba")
        
        credentials.getIdentityId().continueWith(block: { (task:AWSTask<NSString>) -> Any? in
            if let error = task.error as NSError? {
                print("Failed to get client ID => \(error)")
                completion(nil, error)
                return nil  // Required by AWSTask closure
            }
            
            let clientId = task.result! as String
            print("Got client ID => \(clientId)")
            completion(clientId, nil)
            return nil // Required by AWSTask closure
        })
    }

func connectToAWSIoT(clientId: String!) {
        
    func mqttEventCallback(_ status: AWSIoTMQTTStatus ) {
        switch status {
        case .connecting: print("Connecting to AWS IoT")
        case .connected:
            print("Connected to AWS IoT")
            // Register subscriptions here
            // Publish a boot message if required
        case .connectionError: print("AWS IoT connection error")
        case .connectionRefused: print("AWS IoT connection refused")
        case .protocolError: print("AWS IoT protocol error")
        case .disconnected: print("AWS IoT disconnected")
        case .unknown: print("AWS IoT unknown state")
        default: print("Error - unknown MQTT state")
        }
    }
    
    // Ensure connection gets performed background thread (so as not to block the UI)
    DispatchQueue.global(qos: .background).async {
        do {
            print("Attempting to connect to IoT device gateway with ID = \(clientId)")
            let dataManager = AWSIoTDataManager(forKey: "kDataManager")
            dataManager.connectUsingWebSocket(withClientId: clientId,
                                              cleanSession: true,
                                              statusCallback: mqttEventCallback)
            
        } catch {
            print("Error, failed to connect to device gateway => \(error)")
        }
    }
}

//func registerSubscriptions() {
//        func messageReceived(payload: Data) {
//            let payloadDictionary = jsonDataToDict(jsonData: payload)
//            print("Message received: \(payloadDictionary)")
//            guard let sys_dict = payloadDictionary as? [String:Any],
//                  let breaker_0 = sys_dict["breaker_0_current"] as? Double,
//                  let breaker_1 = sys_dict["breaker_1_current"] as? Double,
//                  let breaker_2 = sys_dict["breaker_2_current"] as? Double,
//                  let breaker_3 = sys_dict["breaker_3_current"] as? Double,
//                  let breaker_4 = sys_dict["breaker_4_current"] as? Double,
//                  let breaker_5 = sys_dict["breaker_5_current"] as? Double,
//                  let breaker_6 = sys_dict["breaker_6_current"] as? Double,
//                  let breaker_7 = sys_dict["breaker_7_current"] as? Double,
//                  let voltage = sys_dict["voltage"] as? Double
//            else {
//                print("Data not formatted, next entry")
//                return
//            } // end else after guard
////                            print("made it thru")
//            //TODO: Make for loop later, with logic above as well
//            let breaker0 = BreakerData(cur: breaker_0, pF: nil, breaker: 0)
//            let breaker1 = BreakerData(cur: breaker_1, pF: nil, breaker: 1)
//            let breaker2 = BreakerData(cur: breaker_2, pF: nil, breaker: 2)
//            let breaker3 = BreakerData(cur: breaker_3, pF: nil, breaker: 3)
//            let breaker4 = BreakerData(cur: breaker_4, pF: nil, breaker: 4)
//            let breaker5 = BreakerData(cur: breaker_5, pF: nil, breaker: 5)
//            let breaker6 = BreakerData(cur: breaker_6, pF: nil, breaker: 6)
//            let breaker7 = BreakerData(cur: breaker_7, pF: nil, breaker: 7)
//            let breakerArr = [breaker0, breaker1, breaker2, breaker3, breaker4, breaker5, breaker6, breaker7]
//            let timeDouble = Date()
//            let panState = PanelState(breakers: breakerArr, volt: Double(voltage), time: timeDouble)
//            
////            @EnvironmentObject var energyMeasurements: EnergyMeasurements
////            energyMeasurements.addPanelState(panState: panState)
//            
//            // Handle message event here...
//            // updateDataModel() // Redraw graph, update numerical data
//            
//        }
//        
//        let topicArray = ["measure/basic", "control/basic"]
//        let dataManager = AWSIoTDataManager(forKey: "kDataManager")
//        
//        for topic in topicArray {
//            print("Registering subscription to => \(topic)")
//            dataManager.subscribe(toTopic: topic,
//                                  qoS: .messageDeliveryAttemptedAtLeastOnce,  // Set according to use case
//                                  messageCallback: messageReceived)
//        }
//}

func publishMessage(message: String!, topic: String!) {
    let dataManager = AWSIoTDataManager(forKey: "kDataManager")
    let publish_success = dataManager.publishString(message, onTopic: topic, qoS: .messageDeliveryAttemptedAtLeastOnce) // Set QoS as needed
    print("Message was successful – \(publish_success)")
}


/// DynamoDB Connections
//func AWSDynamoConnect() /*-> AWSDynamoDB*/ {
//    // get a client with a custom configuration
//    let config = getConfig(configType: .dynamodb)
//    AWSDynamoDB.register(with: config, forKey: "USEast1DynamoDB");
////    let dynamoDBCustom = AWSDynamoDB()
////
////    return dynamoDBCustom
//}

//func connectToAWSDynamo(clientId: String!) {
//
//    func mqttEventCallback(_ status: AWSIoTMQTTStatus ) {
//        switch status {
//        case .connecting: print("Connecting to AWS DynamoDB")
//        case .connected:
//            print("Connected to AWS DynamoDB")
//            // Register subscriptions here
//            // Publish a boot message if required
//        case .connectionError: print("AWS DynamoDB connection error")
//        case .connectionRefused: print("AWS DynamoDB connection refused")
//        case .protocolError: print("AWS DynamoDB protocol error")
//        case .disconnected: print("AWS DynamoDB disconnected")
//        case .unknown: print("AWS DynamoDB unknown state")
//        default: print("Error - unknown MQTT state")
//        }
//    }
//
//    // Ensure connection gets performed background thread (so as not to block the UI)
//    DispatchQueue.global(qos: .background).async {
//        do {
//            print("Attempting to connect to DynamoDB device gateway with ID = \(clientId)")
//            let dataManager = AWSDynamoDB(forKey: "USEast1DynamoDB")
//            dataManager. connectUsingWebSocket(withClientId: clientId,
//                                              cleanSession: true,
//                                              statusCallback: mqttEventCallback)
//
//        } catch {
//            print("Error, failed to connect to device gateway => \(error)")
//        }
//    }
//}
