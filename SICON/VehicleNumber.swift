//
//  VehicleNumber.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 28/03/24.
//

import Foundation
import SwiftData

@Model
class VehicleNumber{
    @Attribute(.unique ) var number: String
    var ownerName: String
    var workplace: String
    var contact: String
    var vehicle: String
    
    init(number: String, ownerName: String, workplace: String, contact: String, vehicle: String) {
        self.number = number
        self.ownerName = ownerName
        self.workplace = workplace
        self.contact = contact
        self.vehicle = vehicle
    }
}
