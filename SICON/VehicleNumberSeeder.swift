//
//  VehicleNumberSeeder.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 28/03/24.
//

import Foundation
import SwiftUI
import SwiftData

struct VehicleNumberSeeder{
    
    func seedData(in context: ModelContext){
        let vehicleNumbers = [
//                VehicleNumber(number: "ABC123", ownerName: "John Doe", workplace: "Company A", contact: "123-456-7890"),
//                VehicleNumber(number: "XYZ456", ownerName: "Jane Smith", workplace: "Company B", contact: "987-654-3210"),
                VehicleNumber(number: "B 5520 BCT", ownerName: "Dixon Willow", workplace: "Apple Developer Academy", contact: "813-8492-2646", vehicle: "motorcycle"),
                VehicleNumber(number: "B 4805 TSZ", ownerName: "Fadhil Keren", workplace: "Apple Developer Academy", contact: "813-8492-2646", vehicle: "motorcycle"),
                VehicleNumber(number: "L 1892 RR", ownerName: "Vincent", workplace: "Apple Developer Academy", contact: "813-8492-2646", vehicle: "car"),
                VehicleNumber(number: "B 2503 FLM", ownerName: "Padhil Keren", workplace: "Apple Developer Academy", contact: "813-8492-2646", vehicle: "motorcycle")
            ]
        
        for vehicleNumber in vehicleNumbers {
                do {
                    context.insert(vehicleNumber)
                    try context.save()
                    print("Vehicle number \(vehicleNumber.number) seeded successfully.")
                } catch {
                    print("Error seeding vehicle number \(vehicleNumber.number): \(error)")
                }
            }
    }
}
